//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import Foundation
import Combine // Added for debounce

class MovieListViewModel: ObservableObject { // what  is observableobject: A protocol from Combine framework that allows a class to be observed for changes. When properties marked with @Published change, any SwiftUI views observing this object will automatically update to reflect those changes.
    
    @Published var movies: [Movie] = [] // ui will observe this array for changes
    @Published var searchQuery = ""
    @Published var isLoading = false //
    @Published var page = 1
    
    private var canLoadMore = true
    private var cancellables = Set<AnyCancellable>() // Store Combine subscriptions
    
    init() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                // Trigger search only when empty (fallback) or length >= 2
                if trimmed.isEmpty || trimmed.count >= 2 {
                    self.resetSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchMovies() {
        guard !isLoading, canLoadMore else { return }
        isLoading = true

        APIManager.shared.fetchMovies(search: searchQuery.isEmpty ? "Batman" : searchQuery, page: page) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedMovies):
                    if fetchedMovies.isEmpty {
                        self.canLoadMore = false
                    } else {
                        self.movies.append(contentsOf: fetchedMovies)
                        self.page += 1
                    }
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                }
            }
        }
    }
    
    func resetSearch() {
        page = 1
        movies.removeAll()
        canLoadMore = true
        fetchMovies()
    }
}
