//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import Foundation
import SwiftUI // SwiftUI re-exports ObservableObject & @Published

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchQuery = "" {
        didSet { handleSearchQueryChange() }
    }
    @Published var isLoading = false
    @Published var page = 1
    
    private var canLoadMore = true
    private var searchTask: Task<Void, Never>? // debounce task
    
    init() {
        preloadCached()
    }
    
    private func currentQueryOrDefault() -> String { searchQuery.isEmpty ? "Batman" : searchQuery }
    
    private func preloadCached() {
        let cached = CoreDataManager.shared.loadCachedMovies(search: currentQueryOrDefault())
        if !cached.isEmpty { movies = cached }
    }
    
    private func handleSearchQueryChange() {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        // Cancel previous debounce
        searchTask?.cancel() //Cancels the previous task if user keeps typing
        searchTask = Task { [weak self] in
            // Debounce 400ms
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard let self = self, !Task.isCancelled else { return }
            if trimmed.isEmpty || trimmed.count >= 2 { self.resetSearch() }
        }
    }
    
    func fetchMovies() { // public trigger (infinite scroll / onAppear)
        //is loading: must not already be fetching movies,
        //must be true (means there are more pages left)
        guard !isLoading, canLoadMore else { return }
        Task { await loadMovies() }
    }
    
    private func loadMovies() async {
        isLoading = true
        defer { isLoading = false } // automatically reset after function ends
        do {
            let fetched = try await APIManager.shared.fetchMovies(search: currentQueryOrDefault(), page: page)
            if fetched.isEmpty {
                canLoadMore = false
            } else {
                movies.append(contentsOf: fetched)
                CoreDataManager.shared.upsertMovies(fetched)
                page += 1
            }
        } catch {
            print("Error fetching movies: \(error)")
            if movies.isEmpty { // offline fallback
                let cached = CoreDataManager.shared.loadCachedMovies(search: currentQueryOrDefault())
                if !cached.isEmpty { movies = cached }
            }
        }
    }
    
    func resetSearch() {
        page = 1
        movies.removeAll()
        canLoadMore = true
        preloadCached() // show cached instantly
        fetchMovies()
    }
}
