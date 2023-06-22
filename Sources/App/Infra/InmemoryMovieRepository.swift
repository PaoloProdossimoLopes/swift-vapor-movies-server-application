import Foundation

final class InmemoryMovieRepository {
    private var storedMovies = [MovieDTO]()
}

extension InmemoryMovieRepository: MovieLoaderRepository {
    
    func load() -> [Movie] {
        storedMovies.map { $0.toModel() }
    }
}

extension InmemoryMovieRepository: CreateMovieRepository {
    
    func save(_ movie: Movie) -> Movie {
        let dto = MovieDTO(id: UUID(), model: movie)
        
        storedMovies.append(dto)
        
        return dto.toModel()
    }
}
