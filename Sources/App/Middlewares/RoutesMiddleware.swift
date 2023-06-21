import Vapor

struct RoutesMiddleware: Middleware {
    
    func configure(_ app: Application) throws {
        try app.register(collection: RootRouter())
        try app.register(collection: MoviesRouter(controller: MoviesCompose.compose()))
    }
}
