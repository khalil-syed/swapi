//Created on 27/5/20

import Foundation
import CoreData

extension CDPeople: People {
    
    // MARK: - Initializer
    
    convenience init<T>(withPeople people: T,
                        insertIntoContext context: NSManagedObjectContext) where T: People {
        /* Looking for entity description in specific context is solution to "multiple entities claim the object" error
         */
        let entityDesc = NSEntityDescription.entity(forEntityName: "CDPeople", in: context)!
        
        self.init(entity: entityDesc, insertInto: context)
        self.id = people.id
        self.name = people.name
    }
    
    // MARK: - Getters
    
    var url: String? {
        "http://swapi.dev/api/people/\(id)/"
    }
    
    // MARK: - Fetch Requests / Static Methods
    
    static func fetchRequest(forID id: Int16) -> NSFetchRequest<CDPeople> {
        let request: NSFetchRequest<CDPeople> = fetchRequest()
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        return request
    }
}
