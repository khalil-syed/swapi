//Created on 27/5/20

import Foundation

protocol Movie: Identifiable, Comparable {
    
    // MARK: - Properties
    
    var id: Int16 { get }
    var title: String? { get set }
    var releaseDate: Date? { get set }
    var characters: [String]? { get }
    var characterListString: String? { get }
    var openingCrawl: String? { get set }
    var director: String? { get set }
    var producer: String? { get set }
    
    func characterList() -> [People]
}

extension Movie {
    
    func characterList() -> [People] {
        characters?.map { ServiceObjPeople(name: nil, url: $0) } ?? []
    }
}

// MARK: - Comparable

extension Movie {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        guard let rhsDate = rhs.releaseDate else { return true }
        guard let lhsDate = lhs.releaseDate else { return false }
        return lhsDate.compare(rhsDate) == .orderedDescending
    }
}

// MARK: -

struct ServiceObjMovie: Movie, Decodable {
    
    // MARK: - Properties
    
    var episodeId: Int
    var title: String?
    var releaseDate: Date?
    var characters: [String]?
    var openingCrawl: String?
    var director: String?
    var producer: String?
    
    var id: Int16 { Int16(episodeId) }
    var characterListString: String? { characters?.joined(separator: ",") }
    
    private enum CodingKeys: String, CodingKey {
        case episodeId, title, releaseDate, characters, openingCrawl, director, producer
    }
}

// MARK: - Mock

extension ServiceObjMovie {
    
    static func mock() -> ServiceObjMovie {
        ServiceObjMovie(episodeId: Int.random(in: 0...100), title: "Star Wars")
    }
}
