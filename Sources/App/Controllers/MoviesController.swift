import Vapor

final class MoviesController {
    
    private let lister: ListMovies
    private let creater: CreateMovie
    
    init(lister: ListMovies, creater: CreateMovie) {
        self.lister = lister
        self.creater = creater
    }
    
    func index(request: Request) -> EventLoopFuture<Response> {
        let model = lister.fetch()
        
        let statusCode = HTTPStatus(statusCode: model.statusCode)
        let content = model.data.map(MovieResponse.init(model:))
        
        return content.encodeResponse(status: statusCode, for: request)
    }
    
    func create(request: Request) throws -> EventLoopFuture<Response> {
        let movieReceived = try request.content.decode(MovieRequest.self)
        let createdModel = creater.create(movie: movieReceived.toModel())
        
        let statusCode = HTTPResponseStatus(statusCode: createdModel.statusCode)
        let content = MovieResponse(model: createdModel.data)
        
        return content.encodeResponse(status: statusCode, for: request)
    }
    
    private struct MovieResponse: Content {
        let id: UUID
        let title: String
        
        init(model: Movie) {
            id = model.id!
            title = model.title
        }
    }
    
    private struct MovieRequest: Content {
        let title: String
        
        func toModel() -> Movie {
            Movie(id: nil, title: title)
        }
    }
}
