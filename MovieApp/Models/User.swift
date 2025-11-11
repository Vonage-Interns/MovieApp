//
//  User.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import Foundation
import CoreData

struct AppUser { // previously `User`
    let id: UUID
    let username: String
    let email: String
    let hashedPassword: String
}

extension AppUser {
    init?(managedObject: NSManagedObject) {
        guard let id = managedObject.value(forKey: "id") as? UUID,
              let username = managedObject.value(forKey: "username") as? String,
              let email = managedObject.value(forKey: "email") as? String,
              let hashedPassword = managedObject.value(forKey: "password") as? String else {
            return nil
        }
        self.id = id
        self.username = username
        self.email = email
        self.hashedPassword = hashedPassword
    }
}
