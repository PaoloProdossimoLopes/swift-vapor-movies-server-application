import Foundation
import Vapor

struct MovieResponse: Content {
    let id: UUID
    let title: String
    
    init(model: Movie) {
        id = model.id!
        title = model.title
    }
}
