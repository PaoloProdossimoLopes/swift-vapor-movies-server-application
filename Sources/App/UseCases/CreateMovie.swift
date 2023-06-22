//
//  File.swift
//  
//
//  Created by Paolo Prodossimo Lopes on 21/06/23.
//

import Foundation

protocol CreateMovieRepository {
    func save(_ movie: Movie) -> Movie
}

final class CreateMovie {
    
    private let repository: CreateMovieRepository
    
    init(repository: CreateMovieRepository) {
        self.repository = repository
    }
    
    func create(movie: Movie) -> Model<Movie> {
        let createdMovie = repository.save(movie)
        return Model(statusCode: 201, data: createdMovie)
    }
}
