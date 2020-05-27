//Created on 27/5/20

import XCTest
import Combine
@testable import SWAPI

class MovieListTests: XCTestCase {
    
    // MARK: - Properties
    
    private var disposables = Set<AnyCancellable>()
    var moviesViewModel: MoviesViewModel<CDMovie>!
    var apiService: APIService!
    var cacheService: CacheService!
    var coreDataManager: CoreDataTestDouble!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataManager = CoreDataTestDouble()
        cacheService = CacheService(context: coreDataManager.mainContext)
        apiService = APIServiceTestDouble()
        moviesViewModel = MoviesViewModel(apiService: apiService, cacheService: cacheService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMoviesLoadedOnAppear() {
        guard let context = cacheService.context as? NSManagedObjectContextSpy else {
            XCTFail("Context not suitable for tests")
            return
        }
        XCTAssertTrue(moviesViewModel.moviesList.isEmpty)
        let exp = expectation(description: "Expectations")
        moviesViewModel.$moviesList
            .sink { items in
                if !items.isEmpty {
                    exp.fulfill()
                }
        }.store(in: &disposables)
        moviesViewModel.onAppear()
        wait(for: [exp], timeout: 5.0)
        XCTAssertFalse(moviesViewModel.moviesList.isEmpty)
        XCTAssertEqual(moviesViewModel.moviesList.count, 1 )
        XCTAssertTrue(context.saveWasCalled)
    }

}
