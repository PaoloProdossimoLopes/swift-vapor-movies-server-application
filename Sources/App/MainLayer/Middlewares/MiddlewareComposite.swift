import Vapor

struct MiddlewareComposite: Middleware {
    private let configurables: [Middleware] = [
        RoutesMiddleware()
    ]
    
    func configure(_ app: Application) throws {
        for configurable in configurables {
            try configurable.configure(app)
        }
    }
}
