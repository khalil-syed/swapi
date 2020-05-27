//Created on 27/5/20

import Foundation
import CoreData

class CoreDataManager: CoreDataProtocol {
    
    // MARK: - Properties
    
    private var storeType: String!
    
    // MARK: - Lazy Properties
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: Self.containerName)
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = storeType
        return persistentContainer
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }()
    
    // MARK: - Singleton
    
    private static let shared = CoreDataManager()
    
    static func sharedInstance(storeType: String? = nil) -> CoreDataManager {
        if shared.storeType == nil {
            shared.setup(storeType: storeType ?? NSSQLiteStoreType)
        }
        return shared
    }
    
    // MARK: - Setup
    
    func setup(storeType: String = NSSQLiteStoreType, completion: (() -> Void)? = nil) {
        self.storeType = storeType
        loadPersistentStore {
            completion?()
        }
    }
    private func loadPersistentStore(completion: @escaping () -> Void) {
        
        persistentContainer.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }

            completion()
        }
    }
    
    // MARK: - General Methods
    
    func save() {
        guard persistentContainer.viewContext.hasChanges else {
            return
        }
        do {
            try persistentContainer.viewContext.save()
        } catch (let err) {
            print(err)
        }
    }
    
    func destroyPersistentContainer() {
        self.persistentContainer.destroyPersistentStore(storeType: storeType)
    }
}

// MARK: -

extension NSPersistentContainer {
    
    func destroyPersistentStore(storeType: String) {
        guard let firstStoreURL = persistentStoreCoordinator.persistentStores.first?.url else {
            print("Missing first store URL - could not destroy")
            return
        }
        
        do {
            try persistentStoreCoordinator
                .destroyPersistentStore(at: firstStoreURL, ofType: storeType, options: nil)
        } catch {
            print("Unable to destroy persistent store: \(error) - \(error.localizedDescription)")
       }
    }
}
