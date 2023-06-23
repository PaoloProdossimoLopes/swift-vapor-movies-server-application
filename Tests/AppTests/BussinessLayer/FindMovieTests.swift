import XCTest
@testable import App

final class FindMovieTests: XCTestCase {
    func test_init_noLoads() {
        let env = makeEnviroment()
        
        XCTAssertEqual(env.repository.findByIdCallCount, 0)
    }
    
    func test_finById_withNoMovieWithId_resultNotFoundWithReason() {
        let id = "any id"
        let env = makeEnviroment(movie: nil)
        
        let result = env.sut.find(by: "any id")
        
        XCTAssertEqual(result, .notFound(reason: "Not found a movie with id: \(id)"))
    }
    
    func test_findById_receiveMovieWithoutId_resultOKWithMovie() {
        let movie = Movie.withoutId
        let env = makeEnviroment(movie: movie)
        
        let result = env.sut.find(by: "any other movie id")
        
        XCTAssertEqual(result, .ok(movie))
    }
    
    func test_findById_receiveMovieWithId_resultOKWithMovie() {
        let movie = Movie.withId
        let env = makeEnviroment(movie: movie)
        
        let result = env.sut.find(by: movie.id!.uuidString)
        
        XCTAssertEqual(result, .ok(movie))
    }
}

private extension FindMovieTests {
    struct Enviroment {
        let repository: RepositoryStub
        let sut: FindMovie
    }
    
    func makeEnviroment(
        movie: Movie? = nil,
        file: StaticString = #filePath, line: UInt = #line
    ) -> Enviroment {
        let repository = RepositoryStub()
        repository.findReturns = movie
        let sut = FindMovie(repository: repository)
        
        assertMemoryLeakFor(sut, file: file, line: line)
        assertMemoryLeakFor(repository, file: file, line: line)
        
        return Enviroment(repository: repository, sut: sut)
    }
    
    final class RepositoryStub: MovieFinderRepository {
        
        private(set) var findByIdCallCount = 0
        var findReturns: Movie?
        
        func find(by id: String) -> Movie? {
            findByIdCallCount += 1
            return findReturns
        }
    }
}
