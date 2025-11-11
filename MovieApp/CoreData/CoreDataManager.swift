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
    
    lazy var persistentContainer: NSPersistentContainer = { // what is lazy: 
        let container = NSPersistentContainer(name: "MovieApp")
        container.loadPersistentStores { (_, error) in
            if let error = error { fatalError("Core Data error: \(error)") }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    func saveContext() {
        if context.hasChanges {
            do { try context.save() } catch { print("Failed saving context: \(error)") }
        }
    }
    
    // Persist a batch of movies, avoiding duplicates by imdbID.
    // Assumes Movies entity with attributes: id(UUID), imdbID(String), title(String), type(String), year(String), poster(String optional).
    func upsertMovies(_ movies: [Movie]) {
        guard !movies.isEmpty else { return }
        let ctx = context
        ctx.perform {
            let incomingIDs = movies.map { $0.imdbID }
            // Fetch existing managed objects (avoid dictionary result type mismatch)
            let fetch = NSFetchRequest<NSManagedObject>(entityName: "Movies")
            fetch.predicate = NSPredicate(format: "imdbID IN %@", incomingIDs)
            fetch.resultType = .managedObjectResultType
            var existing: Set<String> = []
            if let objs = try? ctx.fetch(fetch) {
                existing = Set(objs.compactMap { $0.value(forKey: "imdbID") as? String })
            }
            for m in movies where !existing.contains(m.imdbID) {
                guard let entity = NSEntityDescription.entity(forEntityName: "Movies", in: ctx) else { continue }
                let obj = NSManagedObject(entity: entity, insertInto: ctx)
                obj.setValue(UUID(), forKey: "id")
                obj.setValue(m.imdbID, forKey: "imdbID")
                obj.setValue(m.title, forKey: "title")
                obj.setValue(m.type, forKey: "type")
                obj.setValue(m.year, forKey: "year")
                if entity.attributesByName.keys.contains("posterUrl") { obj.setValue(m.poster, forKey: "posterUrl") }
            }
            do { try ctx.save() } catch { print("Movie upsert save failed: \(error)") }
        }
    }
    
    // Load cached movies optionally filtered by search substring (case-insensitive on title).
    func loadCachedMovies(search: String, limit: Int? = nil) -> [Movie] {
        let ctx = context
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            fetch.predicate = NSPredicate(format: "title CONTAINS[c] %@", trimmed)
        }
        if let limit = limit { fetch.fetchLimit = limit }
        do {
            let results = try ctx.fetch(fetch)
            return results.compactMap { obj in
                guard let imdbID = obj.value(forKey: "imdbID") as? String,
                      let title = obj.value(forKey: "title") as? String,
                      let year = obj.value(forKey: "year") as? String,
                      let type = obj.value(forKey: "type") as? String else { return nil }
                let poster = obj.value(forKey: "posterUrl") as? String ?? ""
                return Movie(title: title, year: year, imdbID: imdbID, type: type, poster: poster)
            }
        } catch {
            print("Load cached movies failed: \(error)")
            return []
        }
    }
}
