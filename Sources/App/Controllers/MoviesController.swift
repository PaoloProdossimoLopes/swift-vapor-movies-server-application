import Vapor

struct MoviesController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let movies = routes.grouped("movies")

        movies.get { _ in "Movies ..." }
    }
}
