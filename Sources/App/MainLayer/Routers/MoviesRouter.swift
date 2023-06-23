import Vapor

struct MoviesRouter: RouteCollection {
    
    private let controller: MoviesController
    
    init(controller: MoviesController) {
        self.controller = controller
    }
    
    func boot(routes: RoutesBuilder) throws {
        let movies = routes.grouped(controller.path.pathComponents)
        
        configureListAllMovies(movies)
        configureCreateMovie(movies)
        configureFindMovie(movies)
    }
}

private extension MoviesRouter {
    
    func configureListAllMovies(_ movies: RoutesBuilder) {
        movies.get { request in
            let result = controller.index()
            return result.handle(request: request, map: { $0.map(MovieResponse.init(model:)) })
        }
    }
    
    func configureCreateMovie(_ movies: RoutesBuilder) {
        movies.post { request in
            let movieReceived = try request.content.decode(MovieRequest.self)
            let movieModel = movieReceived.toModel()
            let createdMovieResult = controller.create(newMovie: movieModel)
            return createdMovieResult.handle(request: request, map: MovieResponse.init(model:))
        }
    }
    
    func configureFindMovie(_ movies: RoutesBuilder) {
        let idParam = "id"
        movies.get(":\(idParam)") { request in
            guard let movieId = request.parameters.get("\(idParam)") else {
                return HTTPStatus.badRequest.encodeResponse(for: request)
            }
            
            let resultFinded = controller.find(by: movieId)
            return resultFinded.handle(request: request, map: MovieResponse.init(model:))
        }
    }
}

extension ResponseResult {
    func handle(request: Request, map: (D) -> some Content) -> EventLoopFuture<Response> {
        let code = HTTPStatus(statusCode: statusCode)
        
        if let error = error {
            let errorResponse = ErrorResponse(error: error.error, reason: error.reason)
            return errorResponse.encodeResponse(status: code, for: request)
        }
        
        let successStatusCodeRange = (200...299)
        let isSuccessStatusCode = successStatusCodeRange.contains(statusCode)
        guard let data = data, isSuccessStatusCode else {
            return code.encodeResponse(for: request)
        }
        
        return map(data).encodeResponse(status: code, for: request)
    }
    
    struct ErrorResponse: Content {
        let error: Bool
        let reason: String
    }
}
