//
//  MoviesListView.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.

import SwiftUI
import Kingfisher

struct MoviesListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @EnvironmentObject var favoritesManager: FavoritesManager // Access shared favorites what is @enviornment
    @State private var showMilestoneAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        HStack {
                            KFImage(URL(string: movie.poster)) // Movie poster image
                                .resizable()
                                .placeholder { // Placeholder during image load
                                    ProgressView() // Show loading indicator
                                }
                                .scaledToFit()
                                .frame(width: 50, height: 70)
                                .cornerRadius(8)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(movie.title)
                                    .font(.headline)
                                Text(movie.year)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer() // Push favorite button to the right
                            Button(action: { favoritesManager.toggleFavorite(movie) }) {
                                Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart") // Favorite toggle for each movie
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .onAppear { // Infinite scrolling trigger
                        if movie == viewModel.movies.last {
                            viewModel.fetchMovies()
                        }
                    }
                }
                .listStyle(PlainListStyle()) // Cleaner list style
                .disabled(viewModel.isLoading) // Prevent rapid taps while loading

                if viewModel.isLoading { // Show loader when fetching
                    // Loader overlay
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.4)
                        Text("Loading movies...")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding(20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
            }// End ZStack
            
            .navigationTitle("Movies")
            .searchable(text: $viewModel.searchQuery, prompt: "Search movies")
            .onAppear { viewModel.fetchMovies() } // Initial fetch
      
        } // End NavigationView
        
    }
}
