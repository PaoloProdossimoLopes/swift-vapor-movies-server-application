import Vapor

struct RootController: RouteCollection {
    func boot(routes root: RoutesBuilder) throws {
        root.get { _ in "It works!" }
    }
}
