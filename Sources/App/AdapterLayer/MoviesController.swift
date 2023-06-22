import Vapor

final class MoviesController {
    
    private let lister: ListMovies
    private let creater: CreateMovie
    private let finder: FindMovie
    
    let path = "movies"
    
    init(lister: ListMovies, creater: CreateMovie, finder: FindMovie) {
        self.lister = lister
        self.creater = creater
        self.finder = finder
    }
    
    func index() -> ResponseResult<[Movie]> {
        let listMovieModel = lister.fetch()
        return listMovieModel
    }
    
    func create(newMovie: Movie) -> ResponseResult<Movie> {
        let createdMovieModel = creater.create(movie: newMovie)
        return createdMovieModel
    }
    
    func find(by id: String) -> ResponseResult<Movie> {
        let findedMovie = finder.find(by: id)
        return findedMovie
    }
}
