import XCTest
import XCTVapor
@testable import App

final class MoviesRouterTests: XCTestCase {
    private var app: Application!
    
    override func setUp() async throws {
        app = Application(.testing)
        try await configure(app)
    }
    
    func test_listMovies_withNoRegistersBefore_returnsNoContent() throws {
        try app.test(.GET, Constant.path) { res in
            XCTAssertEqual(res.status, .noContent)
        }
    }
    
    func test_listMovies_withRegisteredMoviePreviously_returnsOKWithMovies() throws {
        let movie = Factory.makeModel()
        try createMovie(movie)
        
        try app.test(.GET, Constant.path) { res in
            XCTAssertEqual(res.status, .ok)
            
            let movies = try decodeMoviesResponse(response: res)
            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies.first?.title, movie.title)
        }
    }
    
    func test_createMovies_returnsCreatedStatusCodeWithMovieCreatedAndID() throws {
        let movie = Factory.makeModel()
        
        try app.test(.POST, Constant.path, beforeRequest: configureRequestWithMovie(movie), afterResponse: { response in
            XCTAssertEqual(response.status, .created)
            
            let model = try decodeMovieResponse(response: response)
            XCTAssertEqual(model.title, movie.title)
            XCTAssertNotNil(model.id)
        })
    }
    
    func test_createMoviesTwice_returnsCreatedStatusCodeWithMovieCreatedAndID() throws {
        let movie = Factory.makeModel()
        try createMovie(movie)
        
        try app.test(.POST, Constant.path, beforeRequest: configureRequestWithMovie(movie), afterResponse: { response in
            XCTAssertEqual(response.status, .created)
            
            let model = try decodeMovieResponse(response: response)
            XCTAssertEqual(model.title, movie.title)
        })
    }
    
    func test_createWithEmptyRequest_returnsBadRequest() throws {
        try app.test(.POST, Constant.path, beforeRequest: { request in
            try request.content.encode([String: String]())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    func test_findMovie_withInvalidID_returnsNotFoundException() throws {
        let path = Constant.moviePathWith(id: "any_invalid_id_for_movie")
        try app.test(.GET, path, beforeRequest: { request in
            try request.content.encode([String: String]())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .notFound)
        })
    }
    
    func test_findMovie_withValidID_returnsNotFoundException() throws {
        let movie = Factory.makeModel()
        try createMovie(movie)
        
        var movieId: UUID?
        try app.test(.GET, Constant.path) { res in
            XCTAssertEqual(res.status, .ok)
            
            let movies = try decodeMoviesResponse(response: res)
            movieId = movies.first?.id
        }
        
        let id = try XCTUnwrap(movieId?.uuidString)
        try app.test(.GET, Constant.moviePathWith(id: id), afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
        })
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func createMovie(_ movie: Movie) throws {
        try app.test(.POST, Constant.path, beforeRequest: configureRequestWithMovie(movie))
    }
}

private extension MoviesRouterTests {
    
    func decodeMoviesResponse(response: XCTHTTPResponse) throws -> [MovieResponse] {
        try response.content.decode([MovieResponse].self)
    }
    
    func decodeMovieResponse(response: XCTHTTPResponse) throws -> MovieResponse {
        try response.content.decode(MovieResponse.self)
    }
    
    func configureRequestWithMovie(_ movie: Movie) -> ((inout XCTHTTPRequest) throws -> Void) {
        { request in
            let movieRequest = Factory.makeMovieRequest(from: movie)
            return try request.content.encode(movieRequest)
        }
    }
    
    enum Constant {
        static let path = "movies"
        
        static func moviePathWith(id: String) -> String {
            Constant.path + "/" + id
        }
    }
    
    enum Factory {
        static func makeModel() -> Movie {
            Movie(id: nil, title: "any movie title")
        }
        
        static func makeMovieRequest(from movie: Movie) -> [String: String] {
            ["title": movie.title]
        }
    }
}
