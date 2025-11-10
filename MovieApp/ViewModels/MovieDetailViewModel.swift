//  MovieDetailViewModel.swift
//  MovieApp
//  Created by Automated Assistant on 10/11/25.
//
//  Handles fetching detailed movie information by imdbID.

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var detail: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let imdbID: String
    private var cancellables = Set<AnyCancellable>()
    
    init(imdbID: String) {
        self.imdbID = imdbID
        fetchDetail()
    }
    
    func fetchDetail() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        APIManager.shared.fetchMovieDetail(imdbID: imdbID) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let detail):
                    self.detail = detail
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
