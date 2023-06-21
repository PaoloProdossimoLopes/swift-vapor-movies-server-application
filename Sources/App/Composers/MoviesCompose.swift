enum MoviesCompose {
    static func compose() -> MoviesController {
        let repository = InmemoryMovieRepository()
        let listUseCase = ListMovies(repository: repository)
        let controller = MoviesController(lister: listUseCase)
        return controller
    }
}
