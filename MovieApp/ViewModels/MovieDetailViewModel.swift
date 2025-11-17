//  MovieDetailViewModel.swift
//  MovieApp
//  Created by Automated Assistant on 10/11/25.
//
//  Handles fetching detailed movie information by imdbID.

import Foundation
//import Combine

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var detail: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let imdbID: String
    
    init(imdbID: String) {
        self.imdbID = imdbID
        fetchDetail() // kick off initial load via Task wrapper
    }
    
    // Public convenience wrapper for UI buttons (Retry)
    func fetchDetail() {
        Task { await loadDetail() }
    }
    
    private func loadDetail() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            let detail = try await APIManager.shared.fetchMovieDetail(imdbID: imdbID)
            self.detail = detail
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
