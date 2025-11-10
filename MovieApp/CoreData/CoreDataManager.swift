//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import Foundation
import CoreData

@objcMembers
class CoreDataManager: NSObject { // Exposed to Objective-C
    static let shared = CoreDataManager()
    private override init() { super.init() }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieApp")
        container.loadPersistentStores { (_, error) in
            if let error = error { fatalError("Core Data error: \(error)") }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do { try context.save() }
            catch { print("Failed saving context: \(error)") }
        }
    }
}
