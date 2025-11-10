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
        
    
    @objc func validateInputs(username: String?, password: String?) -> String? { //why objc : to expose to objective c
        guard let username = username, !username.isEmpty else {
            return "Username cannot be empty"
        }
        guard let password = password, !password.isEmpty else {
            return "Password cannot be empty"
        }
        //write for username and password should be grater than 5
        if username.count < 5 || password.count < 5 {
            return "Username and Password must be at least 5 characters long"
        }
        return nil // means valid
    }
    
    @objc func registerUser(username: String, password: String) -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@", username) //check if user already exists
        
        do {
            let existing = try context.fetch(fetchRequest)
            if !existing.isEmpty {
                print("User already exists.")
                return false
            }
            
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
            let user = NSManagedObject(entity: entity, insertInto: context)
            user.setValue(username, forKey: "username")
            
            //hash password before saving
            let hashedPassword = hashPassword(password)
            user.setValue(hashedPassword, forKey: "password")
            try context.save()
            return true
        } catch {
            print("Error registering user: \(error)")
            return false
        }
    }
}

