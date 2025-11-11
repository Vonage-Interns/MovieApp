//
//  SignUpViewModel.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import Foundation
import CoreData
import CryptoKit //for hashing password

@objc class SignUpViewModel: NSObject { // Inherit from NSObject for @objc compatibility
    
    private func hashPassword(_ password: String) -> String {
            let inputData = Data(password.utf8)
            let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
        
    
    @objc func validateInputs(username: String?, password: String?, email: String?) -> String? { //why objc : to expose to objective c
       // Combine username, email and password for empty validation and basic rules
        let trimmedUsername = username?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let username = trimmedUsername, !username.isEmpty else {
            return "Username cannot be empty"
        }
        guard let email = trimmedEmail, !email.isEmpty else {
            return "Email cannot be empty"
        }
        guard let password = trimmedPassword, !password.isEmpty else {
            return "Password cannot be empty"
        }
        if username.count < 5 || password.count < 5 {
            return "Username and Password must be at least 5 characters long"
        }
        // Simple email regex validation
        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailRegex = try! NSRegularExpression(pattern: emailPattern)
        let range = NSRange(location: 0, length: email.utf16.count)
        if emailRegex.firstMatch(in: email, options: [], range: range) == nil {
            return "Invalid email format"
        }
        return nil // valid
    }
    
    @objc func registerUser(username: String, password: String, email: String) -> Bool {
        let context = CoreDataManager.shared.context
        // Normalize inputs (trim + lowercase email)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        // Case-insensitive uniqueness check
        fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", trimmedEmail)
        
        do {
            if try context.count(for: fetchRequest) > 0 {
                print("User already exists.")
                return false
            }
            guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else {
                print("User entity not found")
                return false
            }
            let user = NSManagedObject(entity: entity, insertInto: context)
            user.setValue(trimmedUsername, forKey: "username")
            user.setValue(trimmedEmail, forKey: "email")
            user.setValue(UUID(), forKey: "id") // Store UUID attribute
            let hashedPassword = hashPassword(trimmedPassword)
            user.setValue(hashedPassword, forKey: "password")
            try context.save()
            return true
        } catch {
            print("Error registering user: \(error)")
            return false
        }
    }
}
