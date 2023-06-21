final class InmemoryMovieRepository: MovieLoaderRepository {
    private var movies = [MovieDTO]()
    
    func load() -> [Movie] {
        movies.map { $0.toModel() }
    }
}
