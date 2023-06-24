import XCTest
import Foundation
@testable import App

final class MoviesControllerTests: XCTestCase {
    func test_init_pathsIsEqualsMovies() {
        let env = makeEnviroment()
        
        XCTAssertEqual(env.sut.path, "movies")
    }
    
    func test_init_noFetchs() {
        let env = makeEnviroment()
        
        XCTAssertEqual(env.lister.fetchCallCount, 0)
        XCTAssertEqual(env.creater.createMovieReceiveds.count, 0)
        XCTAssertEqual(env.finder.findByIdReceiveds.count, 0)
    }
    
    func test_index_withNoContent_returnsEmptyOK() {
        let env = makeEnviroment()
        
        XCTAssertEqual(env.sut.index(), .ok([]))
    }
    
    func test_indexs_withDiferrentsStubbing_returnsDifferentResults() throws {
        let env = makeEnviroment()
        
        env.lister.shouldReturnMovie = .ok([.withId, .withId, .withoutId])
        XCTAssertEqual(env.sut.index(), try XCTUnwrap(env.lister.shouldReturnMovie))
        
        env.lister.shouldReturnMovie = .ok([.withId, .withId])
        XCTAssertEqual(env.sut.index(), try XCTUnwrap(env.lister.shouldReturnMovie))
        
        env.lister.shouldReturnMovie = .ok(Array(repeating: Movie.withId, count: 10))
        XCTAssertEqual(env.sut.index(), try XCTUnwrap(env.lister.shouldReturnMovie))
        
        env.lister.shouldReturnMovie = .notFound(reason: "any value")
        XCTAssertEqual(env.sut.index(), try XCTUnwrap(env.lister.shouldReturnMovie))
        
        env.lister.shouldReturnMovie = .created([])
        XCTAssertEqual(env.sut.index(), try XCTUnwrap(env.lister.shouldReturnMovie))
    }
    
    func test_findById_withNoContent_returnsEmptyOK() {
        let id = "any movie id"
        let env = makeEnviroment()
        
        XCTAssertEqual(env.sut.find(by: id), .ok(.withoutId))
        XCTAssertEqual(env.finder.findByIdReceiveds.count, 1)
        XCTAssertEqual(env.finder.findByIdReceiveds.first, id)
    }
    
    func test_findById_withDiferrentsStubbing_returnsDifferentResults() throws {
        let env = makeEnviroment()
        
        var id = "any movie id 1"
        env.finder.shouldReturnMovie = .ok(.withId)
        XCTAssertEqual(env.sut.find(by: id), try XCTUnwrap(env.finder.shouldReturnMovie))
        XCTAssertEqual(env.finder.findByIdReceiveds.count, 1)
        XCTAssertEqual(env.finder.findByIdReceiveds.first, id)
        
        id = "any movie id 2"
        env.finder.shouldReturnMovie = .ok(.withoutId)
        XCTAssertEqual(env.sut.find(by: id), try XCTUnwrap(env.finder.shouldReturnMovie))
        XCTAssertEqual(env.finder.findByIdReceiveds.count, 2)
        XCTAssertEqual(env.finder.findByIdReceiveds[1], id)
        
        id = "any movie id 3"
        env.finder.shouldReturnMovie = .notFound(reason: "any value")
        XCTAssertEqual(env.sut.find(by: id), try XCTUnwrap(env.finder.shouldReturnMovie))
        XCTAssertEqual(env.finder.findByIdReceiveds.count, 3)
        XCTAssertEqual(env.finder.findByIdReceiveds[2], id)
        
        id = "any movie id 4"
        env.finder.shouldReturnMovie = .created(.withId)
        XCTAssertEqual(env.sut.find(by: id), try XCTUnwrap(env.finder.shouldReturnMovie))
        XCTAssertEqual(env.finder.findByIdReceiveds.count, 4)
        XCTAssertEqual(env.finder.findByIdReceiveds[3], id)
    }
    
    func test_createNewMovie_withDiferrentsStubbing_returnsDifferentResults() throws {
        let env = makeEnviroment()
        
        var movie = Movie.withId
        env.creater.shouldReturnMovie = .ok(movie)
        XCTAssertEqual(env.sut.create(newMovie: movie), try XCTUnwrap(env.creater.shouldReturnMovie))
        XCTAssertEqual(env.creater.createMovieReceiveds.count, 1)
        XCTAssertEqual(env.creater.createMovieReceiveds.first, movie)
        
        movie = .withoutId
        env.creater.shouldReturnMovie = .ok(movie)
        XCTAssertEqual(env.sut.create(newMovie: movie), try XCTUnwrap(env.creater.shouldReturnMovie))
        XCTAssertEqual(env.creater.createMovieReceiveds.count, 2)
        XCTAssertEqual(env.creater.createMovieReceiveds[1], movie)
        
        movie = .withoutId
        env.creater.shouldReturnMovie = .notFound(reason: "any value")
        XCTAssertEqual(env.sut.create(newMovie: movie), try XCTUnwrap(env.creater.shouldReturnMovie))
        XCTAssertEqual(env.creater.createMovieReceiveds.count, 3)
        XCTAssertEqual(env.creater.createMovieReceiveds[2], movie)
        
        movie = .withoutId
        env.creater.shouldReturnMovie = .created(movie)
        XCTAssertEqual(env.sut.create(newMovie: movie), try XCTUnwrap(env.creater.shouldReturnMovie))
        XCTAssertEqual(env.creater.createMovieReceiveds.count, 4)
        XCTAssertEqual(env.creater.createMovieReceiveds[3], movie)
    }
}

private extension MoviesControllerTests {
    
    struct Enviroment {
        let lister: MovieListerStub
        let creater: MovieSaverStub
        let finder: MovieFinderStub
        let sut: MoviesController
    }
    
    func makeEnviroment(file: StaticString = #filePath, line: UInt = #line) -> Enviroment {
        let lister = MovieListerStub()
        let creater = MovieSaverStub()
        let finder = MovieFinderStub()
        
        let sut = MoviesController(lister: lister, creater: creater, finder: finder)
        
        assertMemoryLeakFor(lister, file: file, line: line)
        assertMemoryLeakFor(creater, file: file, line: line)
        assertMemoryLeakFor(finder, file: file, line: line)
        assertMemoryLeakFor(finder, file: file, line: line)
        
        return Enviroment(lister: lister, creater: creater, finder: finder, sut: sut)
    }
    
    final class MovieListerStub: MovieLister {
        private(set) var fetchCallCount = 0
        var shouldReturnMovie: ResponseResult<[Movie]>?
        
        func fetch() -> ResponseResult<[Movie]> {
            fetchCallCount += 1
            
            guard let result = shouldReturnMovie else {
                return ResponseResult.ok([])
            }
            
            return result
        }
    }
    
    final class MovieSaverStub: MovieSaver {
        private(set) var createMovieReceiveds = [Movie]()
        var shouldReturnMovie: ResponseResult<Movie>?
        
        func create(movie: Movie) -> ResponseResult<Movie> {
            createMovieReceiveds.append(movie)
            
            guard let result = shouldReturnMovie else {
                return ResponseResult.created(.withoutId)
            }
            
            return result
        }
    }
    
    final class MovieFinderStub: MovieFinder {
        private(set) var findByIdReceiveds = [String]()
        
        var shouldReturnMovie: ResponseResult<Movie>?
        
        func find(by id: String) -> ResponseResult<Movie> {
            findByIdReceiveds.append(id)
            
            guard let result = shouldReturnMovie else {
                return ResponseResult.ok(.withoutId)
            }
            
            return result
        }
    }
}
