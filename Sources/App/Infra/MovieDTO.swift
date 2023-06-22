import Foundation

struct MovieDTO {
    let id: UUID
    let title: String
    
    init(id: UUID, model: Movie) {
        self.id = id
        self.title = model.title
    }
    
    func toModel() -> Movie {
        Movie(id: id, title: title)
    }
}
