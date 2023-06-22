import Vapor

struct MovieRequest: Content {
    let title: String
    
    func toModel() -> Movie {
        Movie(id: nil, title: title)
    }
}
