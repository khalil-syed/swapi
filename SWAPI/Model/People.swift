//Created on 27/5/20

import Foundation

protocol People {
    
    var id: Int16 { get }
    var name: String? { get set }
    var url: String? { get }
}

// MARK: -

struct ServiceObjPeople: People, Decodable {
    
    var name: String?
    var url: String?
    var id: Int16 {
        Int16(URL(string: url ?? "")?.pathComponents.last ?? "") ?? 0
    }
}

// MARK: - Mock

extension ServiceObjPeople {
    static func mock(id: Int, name: String = "Luke Skywalker") -> ServiceObjPeople {
        ServiceObjPeople(name: name,
                  url: "http://swapi.dev/api/people/\(id)/")
    }
}
