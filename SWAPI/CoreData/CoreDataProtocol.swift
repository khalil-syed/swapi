//Created on 27/5/20

import Foundation
import CoreData

public protocol CoreDataProtocol {
    
    // MARK: - Properties
    
    static var containerName: String { get }
    var mainContext: NSManagedObjectContext { get }
    
    // MARK: - Methods
    
    func save()
}

extension CoreDataProtocol {
    
    // MARK: - Constants
    
    static var containerName: String {
        "SWAPI"
    }
}
