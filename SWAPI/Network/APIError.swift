//Created on 27/5/20

import Foundation

enum APIError: Error {
    
    // MARK : - Cases
    
    case connection
    case invalidURL
    case parsing(description: String)
    case apiError(description: String)
}

// MARK: -

extension APIError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("URL is invalid", comment: "")
        case .connection:
            return NSLocalizedString("You are not connected to the internet.", comment: "")
        case .parsing(let description), .apiError(let description):
            return NSLocalizedString(description, comment: "")
        }
    }
}
