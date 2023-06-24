import Vapor

protocol MovieLister {
    func fetch() -> ResponseResult<[Movie]>
}

protocol MovieSaver {
    func create(movie: Movie) -> ResponseResult<Movie>
}

protocol MovieFinder {
    func find(by id: String) -> ResponseResult<Movie>
}

final class MoviesController {
    
    private let lister: MovieLister
    private let creater: MovieSaver
    private let finder: MovieFinder
    
    let path = "movies"
    
    init(lister: MovieLister, creater: MovieSaver, finder: MovieFinder) {
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
