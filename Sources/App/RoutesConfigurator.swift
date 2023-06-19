import Vapor

struct RoutesConfigurator: Configurable {
    func configure(_ app: Application) throws {
        try app.register(collection: RootController())
        try app.register(collection: MoviesController())
    }
}
