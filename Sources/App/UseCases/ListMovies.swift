protocol MovieLoaderRepository {
    func load() -> [Movie]
}

final class ListMovies {
    
    private let repository: MovieLoaderRepository
    
    init(repository: MovieLoaderRepository) {
        self.repository = repository
    }
    
    func fetch() -> Model<[Movie]> {
        let movies = repository.load()
        
        if movies.isEmpty {
            return Model(statusCode: 204, data: [Movie]())
        }
        
        return Model(statusCode: 200, data: movies)
    }
}
