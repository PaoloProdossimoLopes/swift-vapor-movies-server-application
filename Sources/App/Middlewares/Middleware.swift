import Vapor

protocol Middleware {
    func configure(_ app: Application) throws
}
