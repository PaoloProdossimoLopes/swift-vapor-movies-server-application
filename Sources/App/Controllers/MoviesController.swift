import Vapor

final class MoviesController {
    
    private let lister: ListMovies
    private let creater: CreateMovie
    
    init(lister: ListMovies, creater: CreateMovie) {
        self.lister = lister
        self.creater = creater
    }
    
    func index() -> ResponseData<[Movie]> {
        let listMovieModel = lister.fetch()
        return ResponseData(model: listMovieModel)
    }
    
    func create(newMovie: Movie) -> ResponseData<Movie> {
        let createdMovieModel = creater.create(movie: newMovie)
        return ResponseData(model: createdMovieModel)
    }
}
