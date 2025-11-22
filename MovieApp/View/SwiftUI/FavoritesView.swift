//
//  FavoritesView.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//
import SwiftUI
import Kingfisher // Added for images

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager // Use shared manager
    @State private var showConfirmDelete = false
    @State private var selectedMovie: Movie?
    var body: some View {
        NavigationView {
            Group {
                if favoritesManager.favorites.isEmpty {
                    Text("No favorites yet!")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    List {
                        ForEach(favoritesManager.favorites) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                HStack {
                                    KFImage(URL(string: movie.poster))
                                        .resizable()
                                        .placeholder { ProgressView() }
                                        .scaledToFit()
                                        .frame(width: 50, height: 70)
                                        .cornerRadius(8)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(movie.title)
                                            .font(.headline)
                                        Text(movie.year)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Button {
                                        selectedMovie = movie
                                        showConfirmDelete = true
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                                .alert("Are you sure you want to delete this favorite?",
                                       isPresented: $showConfirmDelete) {
                                    Button("Cancel", role: .cancel) {}
                                    Button("Confirm", role: .destructive) {
                                        if let movie = selectedMovie {
                                            favoritesManager.toggleFavorite(movie)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Favorites")
        }
        
    }
}
