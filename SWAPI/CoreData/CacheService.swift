//Created on 27/5/20

import Foundation
import CoreData
import Combine

class CacheService {
    
    // MARK: - Properties
    
    let context: NSManagedObjectContext
    var disposables = Set<AnyCancellable>()
    
    // MARK: - Singleton
    
    static let shared = CacheService()
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext = CoreDataManager.sharedInstance().mainContext,
         fileManager: FileManager = .default) {
        self.context = context
    }
    
    // MARK: - General Methods
    
    func saveDB() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func deleteAll<T>(fetchRequest: NSFetchRequest<T>) where T: NSManagedObject {
        guard let objects = try? context.fetch(fetchRequest),
            !objects.isEmpty else {
                return
        }
        
        objects.forEach { object in
            context.delete(object)
        }
        saveDB()
    }
    
    // MARK: - Delete
    
    func deleteMovies(fetchRequest:
        NSFetchRequest<CDMovie> = CDMovie.fetchRequest()) {
        deleteAll(fetchRequest: fetchRequest)
    }
    
    func deletePeople(fetchRequest:
        NSFetchRequest<CDPeople> = CDPeople.fetchRequest()) {
        deleteAll(fetchRequest: fetchRequest)
    }
    
    func deletePeople(id: Int16) {
        let request = CDPeople.fetchRequest(forID: id)
        deletePeople(fetchRequest: request)
    }
    
    // MARK: - Cache
    
    func cache(movies: [ServiceObjMovie]) {
        guard !movies.isEmpty else { return }
        for movie in movies {
            _ = CDMovie(withMovie: movie, insertIntoContext: context)
        }
        saveDB()
    }
    
    func cache(people: ServiceObjPeople) {
        _ = CDPeople(withPeople: people, insertIntoContext: context)
        saveDB()
    }
    
    // MARK: - Fetch
    
    func fetchMovies() -> [CDMovie] {
        let request: NSFetchRequest<CDMovie> = CDMovie.fetchRequestSorted()
        return (try? context.fetch(request)) ?? []
    }
    
    func fetchPeople(id: Int16) -> CDPeople? {
        let request: NSFetchRequest<CDPeople> = CDPeople.fetchRequest(forID: id)
        return try? context.fetch(request).first
    }
}
