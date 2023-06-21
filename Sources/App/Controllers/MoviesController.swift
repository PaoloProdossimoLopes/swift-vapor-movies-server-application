import Vapor

final class MoviesController {
    
    private let lister: ListMovies
    
    init(lister: ListMovies) {
        self.lister = lister
    }
    
    func index(request: Request) -> EventLoopFuture<Response> {
        let model = lister.fetch()
        
        let statusCode = HTTPStatus(statusCode: model.statusCode)
        let content = model.data.map(MovieResponse.init(model:))
        
        return content.encodeResponse(status: statusCode, for: request)
    }
    
    struct MovieResponse: Content {
        init(model: Movie) { }
    }
}
