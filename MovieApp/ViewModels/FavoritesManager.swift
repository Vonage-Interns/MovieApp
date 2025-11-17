//
//  FavoritesManager.swift
//  MovieApp
//
//  Created on 06/11/25.
//

import Foundation
import SwiftUI
import UserNotifications

class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: [Movie] = [] // List of favorite movies


    private var favoriteIDs: Set<String> = [] // To track favorite movie IDs
    var currentUserID: String? // currently logged-in user (String)
    
    func loadPersisted(for userID: String) { // load favorites for userID (String)
        currentUserID = userID
        let movies = CoreDataManager.shared.fetchFavorites(for: userID)
        favorites = movies
        favoriteIDs = Set(movies.map { $0.imdbID })
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favoriteIDs.contains(movie.imdbID)
    }

    func toggleFavorite(_ movie: Movie) {
        if isFavorite(movie) {
            favoriteIDs.remove(movie.imdbID)
            favorites.removeAll { $0.imdbID == movie.imdbID }
            if let uid = currentUserID { CoreDataManager.shared.removeFromFavorites(movieID: movie.imdbID, for: uid) }
        } else {
            favoriteIDs.insert(movie.imdbID)
            favorites.append(movie)
            if let uid = currentUserID { CoreDataManager.shared.addToFavorites(movie: movie, for: uid) }
            if favorites.count == 10 {
                triggerMilestoneNotification()
            }
        }
    }

    
    private func triggerMilestoneNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Movie Milestone Reached!"
        content.subtitle = "Congratulations 🎉"
        content.body = "You’ve added 10 favorite movies!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func logout() { // Clear state so next user doesn’t see prior favorites
        currentUserID = nil
        favorites = []
        favoriteIDs.removeAll()
    }
}
