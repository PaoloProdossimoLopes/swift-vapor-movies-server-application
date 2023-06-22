import Vapor

struct MoviesRouter: RouteCollection {
    private let controller: MoviesController
    
    init(controller: MoviesController) {
        self.controller = controller
    }
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let movies = routes.grouped("movies")

        movies.get(use: controller.index)
        movies.post(use: controller.create)
    }
}
