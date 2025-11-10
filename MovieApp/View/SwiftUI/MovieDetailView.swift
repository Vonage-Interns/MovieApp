//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    let movie: Movie
    @EnvironmentObject var favoritesManager: FavoritesManager
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movie: Movie) {
        self.movie = movie
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(imdbID: movie.imdbID))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                KFImage(URL(string: movie.poster))
                    .resizable()
                    .placeholder { ProgressView() }
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Loading / Error / Content states
                if viewModel.isLoading {
                    HStack { Spacer(); ProgressView("Loading details..."); Spacer() }
                        .padding()
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 8) {
                        Text("Failed to load details")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Button("Retry") { viewModel.fetchDetail() }
                            .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                } else if let detail = viewModel.detail {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(detail.title)
                            .font(.title)
                            .bold()
                        
                        HStack(spacing: 12) {
                            Label(detail.year, systemImage: "calendar")
                            Label(detail.runtime, systemImage: "clock")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        if let imdbSource = detail.imdbSourceRating ?? (detail.imdbRating.isEmpty ? nil : detail.imdbRating) {
                            HStack {
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                                Text("IMDb: \(imdbSource)")
                                    .font(.headline)
                            }
                        }
                        
                        Group {
                            infoRow(title: "Released", value: detail.released)
                            infoRow(title: "Director", value: detail.director)
                            infoRow(title: "Writer", value: detail.writer)
                            infoRow(title: "Awards", value: detail.awards)
                            infoRow(title: "Box Office", value: detail.boxOffice)
                        }
                        .padding(.vertical, 4)
                    }
                    .padding(.horizontal)
                }
                
                // Favorites toggle always available (uses basic movie object for set uniqueness)
                Button(action: { favoritesManager.toggleFavorite(movie) }) {
                    Label(favoritesManager.isFavorite(movie) ? "Remove from Favorites" : "Add to Favorites",
                          systemImage: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(favoritesManager.isFavorite(movie) ? Color.red.opacity(0.15) : Color.blue.opacity(0.15))
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        if value != "N/A" && !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
        }
    }
}
