import Foundation

protocol CreateMovieRepository {
    func save(_ movie: Movie) -> Movie
}

final class CreateMovie: MovieSaver {
    
    private let repository: CreateMovieRepository
    
    init(repository: CreateMovieRepository) {
        self.repository = repository
    }
    
    func create(movie: Movie) -> ResponseResult<Movie> {
        let createdMovie = repository.save(movie)
        return .created(createdMovie)
    }
}
