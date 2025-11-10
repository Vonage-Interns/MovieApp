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

    
    func validateUser(username: String, password: String) -> Bool {
        // Get the managed object context
        let context = CoreDataManager.shared.context
       
        // If a matching user is found, it returns true  otherwise, it returns false.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        //filter users by username
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)  //what is NSpredicate: A Foundation class that specifies how data should be fetched or filtered from a data store.
        
        do {
            let result = try context.fetch(fetchRequest)
            if let user = result.first,
               let storedPassword = user.value(forKey: "password") as? String {
                
                let enteredHashed = hashPassword(password)
                return enteredHashed == storedPassword
            }
            return false
        }catch {
            print("Error fetching user: \(error)")
            return false
        }
    }
}

