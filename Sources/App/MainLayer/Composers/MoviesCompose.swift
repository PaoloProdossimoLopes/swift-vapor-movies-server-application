enum MoviesCompose {
    static func compose() -> MoviesController {
        let repository = InmemoryMovieRepository()
        let listUseCase = ListMovies(repository: repository)
        let createUseCase = CreateMovie(repository: repository)
        let finderUseCase = FindMovie(repository: repository)
        let controller = MoviesController(
            lister: listUseCase,
            creater: createUseCase,
            finder: finderUseCase
        )
        return controller
    }
}
