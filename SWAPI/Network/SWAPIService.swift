//Created on 27/5/20

import Foundation
import Combine

protocol APIService {
    
    func fetchMovies() -> AnyPublisher<APIResponse<[ServiceObjMovie]>, APIError>
    func fetchCharacter(_ characterURL: String) -> AnyPublisher<ServiceObjPeople, APIError>
}

// MARK: - 

struct SWAPIService {
    
    // MARK: - Properties
    
    let session: URLSession
    
    // MARK: - Initializer
    
    init(withSession session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Methods
    
    func url(_ path: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "swapi.dev"
        components.path = "/api/\(path)"
        return components.url
    }
    
    private func errorPublisher<T>() -> AnyPublisher<T, APIError> {
        Fail(error: .invalidURL)
            .eraseToAnyPublisher()
    }
    
    func publisher<T: Decodable>(forRequest request: URLRequest,
                                   dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
        = .formatted(DateFormatter.yearMonthDay)) -> AnyPublisher<T, APIError> {
        
        session
            .dataTaskPublisher(for: request)
            .mapError { self.apiError($0) }
            .flatMap(maxPublishers: .max(1)) { self.verifySuccess($0) }
            .flatMap(maxPublishers: .max(1)) {
                self.decode($0, dateDecodingStrategy: dateDecodingStrategy)
        }
        .eraseToAnyPublisher()
    }
    
    func verifySuccess(_ output: URLSession.DataTaskPublisher.Output) -> AnyPublisher<Data, APIError> {
        
        Just(output)
            .tryMap { output in
                if let error = apiError(fromResponse: output.response) {
                    throw error
                }
                return output.data
        }
        .mapError { error -> APIError in
            error as? APIError ?? .apiError(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    func decode<T: Decodable>(_ data: Data,
                              dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) -> AnyPublisher<T, APIError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    func apiError(fromResponse urlResponse: URLResponse?) -> APIError? {
        
        if let httpResponse = urlResponse as? HTTPURLResponse,
            (httpResponse.statusCode == 200
                || httpResponse.statusCode == 201) {
            return nil
        }
        
        return .apiError(description: "")
    }
    
    func apiError(_ error: Error) -> APIError {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            return .connection
        }
        
        return .apiError(description: error.localizedDescription)
    }
}

// MARK: -

extension SWAPIService: APIService {
    
    func fetchMovies() -> AnyPublisher<APIResponse<[ServiceObjMovie]>, APIError> {
        guard let url = url("films") else {
            return errorPublisher()
        }
        
        return publisher(forRequest: URLRequest(url: url))
    }
    
    func fetchCharacter(_ characterURL: String) -> AnyPublisher<ServiceObjPeople, APIError> {
        guard let url = URL(string: characterURL) else {
            return errorPublisher()
        }
        
        return publisher(forRequest: URLRequest(url: url))
    }
    
}

// MARK: -

extension DateFormatter {
    
    static let yearMonthDay: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
}
