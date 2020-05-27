//Created on 27/5/20

import Foundation
import XCTest
import Combine
@testable import SWAPI

class APIServiceTestDouble: APIService {
    
    func fetchCharacter(_ characterURL: String) -> AnyPublisher<ServiceObjPeople, APIError> {
        publisher(forResponse: ServiceObjPeople.mock(id: 2))
    }
    
    
    func fetchMovies() -> AnyPublisher<APIResponse<[ServiceObjMovie]>, APIError> {
        publisher(forResponse: APIResponse(count: 1, results: [ServiceObjMovie.mock()]))
    }
    
    private func publisher<T>(forResponse response: T) -> AnyPublisher<T,APIError> {
        Just(response)
            .receive(on: DispatchQueue.main)
            .tryMap { $0 }
            .mapError { _ in .apiError(description: "") }
            .eraseToAnyPublisher()
    }
}
