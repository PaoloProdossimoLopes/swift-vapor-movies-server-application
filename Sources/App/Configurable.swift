import Vapor

protocol Configurable {
    func configure(_ app: Application) throws
}
