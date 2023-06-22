import Vapor

struct RootRouter: RouteCollection {
    func boot(routes root: RoutesBuilder) throws {
        let controller = RootController()
        
        root.get(use: controller.index)
    }
}
