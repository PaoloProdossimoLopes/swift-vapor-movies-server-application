import Vapor

final class MoviesController {
    
    private let lister: ListMovies
    private let creater: CreateMovie
    
    init(lister: ListMovies, creater: CreateMovie) {
        self.lister = lister
        self.creater = creater
    }
    
    func index() -> Model<[Movie]> {
        let listMovieModel = lister.fetch()
        return listMovieModel
    }
    
    func create(newMovie: Movie) -> Model<Movie> {
        let createdMovieModel = creater.create(movie: newMovie)
        return createdMovieModel
    }
}
