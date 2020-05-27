//Created on 27/5/20

import Foundation
import Combine


class CharactersViewModel: ObservableObject {
    
    @Published var charactersList: [People] {
        didSet {
            statusMessage = charactersList.isEmpty ? "No characters in this movie" : ""
        }
    }
    @Published var statusMessage: String?
    
    let apiService: APIService
    let cacheService: CacheService
    var disposables = Set<AnyCancellable>()
    
    init(characterList: [People],
         apiService: APIService = SWAPIService(),
         cacheService: CacheService = CacheService.shared) {
        self.charactersList = characterList
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    func onAppear() {
        for index in 0 ..< charactersList.count {
            
            guard let url = charactersList[index].url else { continue }
            
            var people = charactersList[index]
            people.name = "..."
            charactersList[index] = people
            
            apiService.fetchCharacter(url)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure( let apiError):
                        self.onError(apiError, forIndex: index)
                        break
                    default:
                        break
                    }
                    
                }, receiveValue: { response in
                    self.onReponseReceived(response, index: index)
                }).store(in: &disposables)
        }
    }
    
    func onError(_ error: APIError, forIndex index: Int) {
        switch error {
        case .connection:
            fetchFromCache(forIndex: index)
            break
        default:
            DispatchQueue.main.async {
                var people = self.charactersList[index]
                people.name = "-"
                self.charactersList[index] = people
            }
        }
        
    }
    
    func onReponseReceived(_ response: ServiceObjPeople, index: Int) {
        let id = charactersList[index].id
        guard id > 0 else { return }
        
        cacheService.deletePeople(id: id)
        cacheService.cache(people: response)
        fetchFromCache(forIndex: index)
    }
    
    func fetchFromCache(forIndex index: Int) {
        let id = charactersList[index].id
        guard id > 0,
            let people = self.cacheService.fetchPeople(id: id)
            else { return }
        
        DispatchQueue.main.async {
            self.charactersList[index] = people
        }
    }
}
