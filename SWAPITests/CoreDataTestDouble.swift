//Created on 27/5/20

import Foundation
import CoreData
import XCTest
@testable import SWAPI

struct CoreDataTestDouble: CoreDataProtocol {
    
    // MARK: - Properties
    
    let mainContext: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    
    // MARK: - Initializer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: Self.containerName)
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType

        self.persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }

        mainContext = NSManagedObjectContextSpy(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
    
    // MARK: - Methods
    
    func save() {
        
    }
    
    func destroyPersistentContainer() {
        self.persistentContainer.destroyPersistentStore(storeType: NSInMemoryStoreType)
    }
}

// MARK: -

class NSManagedObjectContextSpy: NSManagedObjectContext {
    
    // MARK: - Properties
    
    var expectation: XCTestExpectation?
    var saveWasCalled = false

    // MARK: - Overridden Methods
    
    override func performAndWait(_ block: () -> Void) {
        super.performAndWait(block)
        expectation?.fulfill()
    }

    override func save() throws {
        try super.save()
        self.saveWasCalled = true
    }
}
