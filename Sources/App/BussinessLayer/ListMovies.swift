protocol MovieLoaderRepository {
    func load() -> [Movie]
}

final class ListMovies {
    
    private let repository: MovieLoaderRepository
    
    init(repository: MovieLoaderRepository) {
        self.repository = repository
    }
    
    func fetch() -> ResponseResult<[Movie]> {
        let movies = repository.load()
        
        if movies.isEmpty {
            return .noContent
        }
        
        return .ok(movies)
    }
}
