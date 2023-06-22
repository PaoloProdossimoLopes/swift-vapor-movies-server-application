import Vapor

final class RootController {
    func index(request: Request) -> [String: Int] {
        return ["statusCode": 200]
    }
}
