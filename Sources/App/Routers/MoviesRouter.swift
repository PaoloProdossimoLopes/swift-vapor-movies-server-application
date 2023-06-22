import Vapor

struct MoviesRouter: RouteCollection {
    
    private let controller: MoviesController
    
    init(controller: MoviesController) {
        self.controller = controller
    }
    
    func boot(routes: RoutesBuilder) throws {
        let movies = routes.grouped("movies")

        movies.get { request in
            let listMovieModel = controller.index()
            let statusCode = HTTPStatus(statusCode: listMovieModel.statusCode)
            let moviesResponse = listMovieModel.data.map(MovieResponse.init(model:))

            return moviesResponse.encodeResponse(status: statusCode, for: request)
        }
        
        movies.post { request in
            let movieReceived = try request.content.decode(MovieRequest.self)
            let movieModel = movieReceived.toModel()
            let createdMovieModel = controller.create(newMovie: movieModel)
            let statusCode = HTTPResponseStatus(statusCode: createdMovieModel.statusCode)
            let responseModel = MovieResponse(model: createdMovieModel.data)
            
            return responseModel.encodeResponse(status: statusCode, for: request)
        }
    }
}
