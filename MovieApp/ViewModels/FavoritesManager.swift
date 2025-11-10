//  FavoritesManager.swift
//  MovieApp
//  Created on 06/11/25.

import Foundation
import SwiftUI
import UserNotifications

class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: [Movie] = [] // List of favorite movies
    @Published var milestoneMessage: String? = nil

    private var favoriteIDs: Set<String> = [] // To track favorite movie IDs

    func isFavorite(_ movie: Movie) -> Bool {
        favoriteIDs.contains(movie.imdbID)
    }

    func toggleFavorite(_ movie: Movie) {
        if isFavorite(movie) {
            // Remove
            favoriteIDs.remove(movie.imdbID)
            favorites.removeAll { $0.imdbID == movie.imdbID }
        } else {
            // Add
            favoriteIDs.insert(movie.imdbID) // Add to set
            favorites.append(movie) // Add to list
            // Milestone check
            if favorites.count == 10 {
                milestoneMessage = "Wow, you are a movie enthusiast!"
                triggerMilestoneNotification()
            }
        }
    }

    func clearMilestone() {
        milestoneMessage = nil
    }
    
    private func triggerMilestoneNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Movie Milestone Reached!"
        content.body = "You’ve added 10 favorite movies!"
        content.sound = .default

        // Trigger instantly (you can delay if you want)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "favorites_milestone", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing milestone notification: \(error.localizedDescription)")
            } else {
                print("Milestone notification scheduled.")
            }
        }
    }
}
