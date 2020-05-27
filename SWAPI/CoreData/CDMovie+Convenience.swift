//Created on 27/5/20

import Foundation
import CoreData

extension CDMovie: Movie {
    
    // MARK: - Initializer
    
    convenience init<T>(withMovie movie: T,
                        insertIntoContext context: NSManagedObjectContext) where T: Movie {
        /* Looking for entity description in specific context is solution to "multiple entities claim the object" error
         */
        let entityDesc = NSEntityDescription.entity(forEntityName: "CDMovie", in: context)!
        
        self.init(entity: entityDesc, insertInto: context)
        self.id = movie.id
        self.title = movie.title
        self.releaseDate = movie.releaseDate
        self.characterListString = movie.characterListString
        self.openingCrawl = movie.openingCrawl
        self.director = movie.director
        self.producer = movie.producer
    }
    
    // MARK: - Getters
    
    var characters: [String]? {
        self.characterListString?.components(separatedBy: ",")
    }
    
    // MARK: - Fetch Requests / Static Methods
    
    static func fetchRequestSorted() -> NSFetchRequest<CDMovie> {
        let request: NSFetchRequest<CDMovie> = fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "releaseDate",
                                                    ascending: false)]
        return request
    }
}
