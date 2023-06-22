import Foundation

protocol MovieFinderRepository {
    func find(by id: String) -> Movie?
}

final class FindMovie {
    
    private let repository: MovieFinderRepository
    
    init(repository: MovieFinderRepository) {
        self.repository = repository
    }
    
    func find(by id: String) -> ResponseResult<Movie> {
        guard let findedMovie = repository.find(by: id) else {
            return ResponseResult.notFound(reason: "Not found a movie with id: \(id)")
        }
        
        return ResponseResult.ok(findedMovie)
    }
}
