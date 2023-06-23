import XCTest
@testable import App

final class ListMoviesTests: XCTestCase {
    func test_init_noLoads() {
        let env = makeEnviroment(movies: .empty)
        
        XCTAssertEqual(env.repository.loadCallCount, 0)
    }
    
    func test_fetch_withNoMoviesStored_returnsNoContentResult() {
        let env = makeEnviroment(movies: .empty)
        
        let moviesResult = env.sut.fetch()
        
        XCTAssertEqual(moviesResult, .noContent)
    }
    
    func test_fetch_withNoMoviesStored_loadOnce() {
        let env = makeEnviroment(movies: .empty)
        
        _ = env.sut.fetch()
        
        XCTAssertEqual(env.repository.loadCallCount, 1)
    }
    
    func test_fetch_withMoviesNullIdStored_returnsOkResult() {
        let movies: [Movie] = .withNullId
        let env = makeEnviroment(movies: movies)
        
        let moviesResult = env.sut.fetch()
        
        XCTAssertEqual(moviesResult, .ok(movies))
    }
    
    func test_fetch_withMoviesNullIdStored_loadOnce() {
        let env = makeEnviroment(movies: .withNullId)
        
        _ = env.sut.fetch()
        
        XCTAssertEqual(env.repository.loadCallCount, 1)
    }
    
    func test_fetch_withMoviesStored_returnsOkResult() {
        let movies: [Movie] = .noEmpty
        let env = makeEnviroment(movies: movies)
        
        let moviesResult = env.sut.fetch()
        
        XCTAssertEqual(moviesResult, .ok(movies))
    }
    
    func test_fetch_withMoviesStored_loadOnce() {
        let env = makeEnviroment(movies: .withNullId)
        
        _ = env.sut.fetch()
        
        XCTAssertEqual(env.repository.loadCallCount, 1)
    }
}

extension XCTestCase {
    func assertMemoryLeakFor(
        _ instance: AnyObject,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}

private extension ListMoviesTests {
    struct Enviroment {
        let repository: RepositoryStub
        let sut: ListMovies
    }
    
    func makeEnviroment(
        movies: [Movie] = .noEmpty,
        file: StaticString = #filePath, line: UInt = #line
    ) -> Enviroment {
        let repository = RepositoryStub()
        repository.loadReturns = movies
        let sut = ListMovies(repository: repository)
        
        assertMemoryLeakFor(sut, file: file, line: line)
        assertMemoryLeakFor(repository, file: file, line: line)
        
        return Enviroment(repository: repository, sut: sut)
    }
    
    final class RepositoryStub: MovieLoaderRepository {
        
        private(set) var loadCallCount = 0
        var loadReturns = [Movie]()
        
        func load() -> [Movie] {
            loadCallCount += 1
            return loadReturns
        }
    }
}
