import XCTest
@testable import App

final class CreateMovieTests: XCTestCase {
    func test_init_noSaves() {
        let env = makeEnviroment()
        
        XCTAssertEqual(env.repository.receivedMovies.count, 0)
    }
    
    func test_create_withRquestsOnce_retunsCreated() {
        let env = makeEnviroment()
        let movie = Movie.withId
        
        let result = env.sut.create(movie: movie)
        
        XCTAssertEqual(env.repository.receivedMovies.count, 1)
        XCTAssertEqual(env.repository.receivedMovies.first, movie)
        XCTAssertEqual(result, .created(movie))
    }
    
    func test_create_movieWithId_returnsMovieWithId() {
        let movie = Movie.withId
        let env = makeEnviroment(movie: movie)
        
        let result = env.sut.create(movie: movie)
        
        XCTAssertEqual(env.repository.receivedMovies.count, 1)
        XCTAssertEqual(env.repository.receivedMovies.first, movie)
        XCTAssertEqual(result, .created(movie))
    }
    
    func test_create_movieWithoutId_returnsMovieWithId() {
        let movie = Movie.withId
        let env = makeEnviroment(movie: movie)
        
        let result = env.sut.create(movie: .withoutId)
        
        XCTAssertEqual(env.repository.receivedMovies.count, 1)
        XCTAssertEqual(env.repository.receivedMovies.first, .withoutId)
        XCTAssertEqual(result, .created(movie))
    }
}

private extension CreateMovieTests {
    struct Enviroment {
        let repository: RepositoryStub
        let sut: CreateMovie
    }
    
    func makeEnviroment(
        movie: Movie? = nil,
        file: StaticString = #filePath, line: UInt = #line
    ) -> Enviroment {
        let repository = RepositoryStub()
        repository.movieReturns = movie
        let sut = CreateMovie(repository: repository)
        
        assertMemoryLeakFor(sut, file: file, line: line)
        assertMemoryLeakFor(repository, file: file, line: line)
        
        return Enviroment(repository: repository, sut: sut)
    }
    
    final class RepositoryStub: CreateMovieRepository {
        
        var movieReturns: Movie?
        private(set) var receivedMovies = [Movie]()
        
        func save(_ movie: Movie) -> Movie {
            receivedMovies.append(movie)
            
            if let m = movieReturns {
                return m
            }
            
            return movie
        }
    }
}
