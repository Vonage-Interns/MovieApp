//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import Foundation
import CoreData

@objcMembers // Expose all members to Objective-C
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
    
    //Add this to support testing
      func setPersistentContainerForTesting(_ container: NSPersistentContainer) {
          self.persistentContainer = container
      }
    
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
            fetch.predicate = NSPredicate(format: "imdbID IN %@", incomingIDs) //
            fetch.resultType = .managedObjectResultType
            var existing: Set<String> = [] // to track existing imdbIDs
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
    
    //add the favorities
    func addToFavorites(movie: Movie, for userID: String) { // userID stored as String in Core Data
        let ctx = context
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetch.predicate = NSPredicate(format: "userID == %@ AND movieID == %@", userID, movie.imdbID)
        fetch.fetchLimit = 1
        if let existing = try? ctx.fetch(fetch), !existing.isEmpty { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: ctx) else { return }
        let favorite = NSManagedObject(entity: entity, insertInto: ctx)
        favorite.setValue(UUID(), forKey: "id")
        favorite.setValue(movie.imdbID, forKey: "movieID")
        favorite.setValue(movie.title, forKey: "title")
        favorite.setValue(movie.poster, forKey: "poster")
        favorite.setValue(movie.year, forKey: "year")
        favorite.setValue(userID, forKey: "userID")
        favorite.setValue(Date(), forKey: "timestamp")
        do { try ctx.save(); print("Favorite added for user \(userID)") } catch { print(" Error saving favorite: \(error)") }
    }
    
    //remove the favorities
    func removeFromFavorites(movieID: String, for userID: String) {
        let ctx = context
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetch.predicate = NSPredicate(format: "userID == %@ AND movieID == %@", userID, movieID)
        do {
            let results = try ctx.fetch(fetch)
            for obj in results {
                ctx.delete(obj)
            }
            try ctx.save()
            print("Favorite removed for user \(userID)")
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    // Fetch favorites for a given user, mapped back to Movie (type left blank as Favorite may not store it)
    func fetchFavorites(for userID: String) -> [Movie] { // Fetch by String userID
        let ctx = context
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "userID == %@", userID)
        do {
            let results = try ctx.fetch(request)
            return results.compactMap { obj in
                guard let movieID = obj.value(forKey: "movieID") as? String,
                      let title = obj.value(forKey: "title") as? String,
                      let poster = obj.value(forKey: "poster") as? String,
                      let year = obj.value(forKey: "year") as? String else { return nil }
                return Movie(title: title, year: year, imdbID: movieID, type: "", poster: poster)
            }
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
}
