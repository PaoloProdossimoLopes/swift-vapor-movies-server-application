import Vapor

struct ConfiguratorComposite: Configurable {
    private let configurables: [Configurable] = [
        PostgreeDatabaseConfigurator(),
        MigrationsConfigurator(),
        RoutesConfigurator()
    ]
    
    func configure(_ app: Application) throws {
        for configurable in configurables {
            try configurable.configure(app)
        }
    }
}
