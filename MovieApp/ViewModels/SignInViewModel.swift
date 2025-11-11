//
//  SignInViewModel.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import Foundation
import CoreData
import CryptoKit


class SignInViewModel {
    
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    // Returns true if a user with matching email and password hash exists
    func validateUser(email: String, password: String) -> Bool {
        let context = CoreDataManager.shared.context
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let normalizedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", normalizedEmail)
        fetchRequest.fetchLimit = 1
        do {
            if let user = try context.fetch(fetchRequest).first,
               let storedPassword = user.value(forKey: "password") as? String {
                let enteredHashed = hashPassword(normalizedPassword)
                return enteredHashed == storedPassword
            }
            return false
        } catch {
            print("Error fetching user: \(error)")
            return false
        }
    }
    
    // Convenience: fetch stored username for an email (after successful auth)
    func fetchUsername(forEmail email: String) -> String? {
        let context = CoreDataManager.shared.context
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetch.predicate = NSPredicate(format: "email ==[c] %@", normalizedEmail)
        fetch.fetchLimit = 1
        guard let userObj = try? context.fetch(fetch).first,
              let storedUsername = userObj.value(forKey: "username") as? String,
              !storedUsername.isEmpty else { return nil }
        return storedUsername
    }
}
