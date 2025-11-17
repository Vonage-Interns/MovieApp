//
//  HomeView.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import SwiftUI

struct HomeView: View {
    let username: String // Added
    let userID: String // new
    let onLogout: () -> Void // Added
    @StateObject private var favoritesManager = FavoritesManager() // Added shared favorites manager
    var body: some View {
        TabView {
            MoviesListView()
                .tabItem {
                    Label("Movies", systemImage: "film")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            ProfileView(username: username, onLogout: {
                favoritesManager.logout() // clear favorites state on logout
                onLogout()
            })
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .environmentObject(favoritesManager) // Provide to subtree
        .onAppear { favoritesManager.loadPersisted(for: userID) }
    }
}
