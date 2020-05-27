//Created on 27/5/20

import UIKit
import SwiftUI
import Combine

class MoviesViewModel<T>: ObservableObject where T: Movie {

    @Published var statusMessage: String?
    @Published var moviesList: [T] = [] {
        didSet {
            statusMessage = moviesList.isEmpty ? "No Data Available" : ""
        }
    }
    @Published var navigateToDetails: Bool = false
    @Published var selectedMovie: T?
    
    let apiService: APIService
    let cacheService: CacheService
    var disposables = Set<AnyCancellable>()
    
    
    init(apiService: APIService = SWAPIService(),
         cacheService: CacheService = CacheService.shared) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    func onAppear() {
        fetchData()
    }
    
    func fetchData() {
        statusMessage = "Loading..."
        apiService.fetchMovies()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure( let apiError):
                self.onError(apiError)
                break
            default:
                break
            }
        }, receiveValue: { response in
            self.onReponseReceived(response.results)
        }).store(in: &disposables)
    }
    
    func onReponseReceived(_ response: [ServiceObjMovie]) {
        cacheService.deleteMovies()
        cacheService.cache(movies: response)
        fetchFromCache()
    }
    
    func fetchFromCache() {
        DispatchQueue.main.async {
            self.moviesList = (self.cacheService.fetchMovies() as? [T] ?? [])
        }
    }
    
    func onError(_ error: APIError) {
        switch error {
        case .connection:
            fetchFromCache()
            break
        default:
            self.moviesList = []
            self.statusMessage = error.localizedDescription
        }
    }
}
