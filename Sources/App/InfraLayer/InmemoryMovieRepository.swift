import Foundation

final class InmemoryMovieRepository {
    private var storedMovies: [MovieDTO]
    
    init(storedMovies: [MovieDTO] = [MovieDTO]()) {
        self.storedMovies = storedMovies
    }
}

extension InmemoryMovieRepository: MovieLoaderRepository {
    @discardableResult
    func load() -> [Movie] {
        storedMovies.map { $0.toModel() }
    }
}

extension InmemoryMovieRepository: CreateMovieRepository {
    @discardableResult
    func save(_ movie: Movie) -> Movie {
        let dto = MovieDTO(id: UUID(), model: movie)
        
        storedMovies.append(dto)
        
        return dto.toModel()
    }
}

extension InmemoryMovieRepository: MovieFinderRepository {
    @discardableResult
    func find(by id: String) -> Movie? {
        storedMovies
            .first { $0.id.uuidString == id }
            .map { $0.toModel() }
    }
}
