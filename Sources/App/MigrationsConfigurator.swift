import Vapor

struct MigrationsConfigurator: Configurable {
    func configure(_ app: Vapor.Application) throws {
        app.migrations.add(CreateMovies())
    }
}
