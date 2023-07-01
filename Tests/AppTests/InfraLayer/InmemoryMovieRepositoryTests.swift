import XCTest
import Foundation
@testable import App

final class InmemoryMovieRepositoryTests: XCTestCase {
    func test_load_withEmptyDefaultInit_returnsNoMovies() {
        let sut = makeSUT()
        
        let result = sut.load()
        
        XCTAssertEqual(result, [])
    }
    
    func test_save_withEmptyDefaultInit_returnsOneMovieEqualSaved() {
        let sut = makeSUT()
        
        let movie = Movie.withoutId
        let result = sut.save(movie)
        
        XCTAssertNotNil(result.id)
        XCTAssertEqual(result.title,  movie.title)
    }
    
    func test_load_withEmptyDefaultInit_afterSaveOneMovieWithoutId_returnsOneMovieEqualSavedWithId() {
        let sut = makeSUT()
        let movie = Movie.withoutId
        _ = sut.save(movie)
        
        let loaded = sut.load()
        
        XCTAssertEqual(loaded.count, 1)
        XCTAssertNotNil(loaded.first?.id)
        XCTAssertEqual(loaded.first?.title, movie.title)
    }
    
    func test_findById_afterSaveThreeMovies_findAllOfThoseSavedWhenLookingUsingIds() throws {
        let sut = makeSUT()
        sut.save(.withoutId)
        sut.save(.withoutId)
        sut.save(.withoutId)
        let savedMovies = sut.load()
        
        XCTAssertEqual(savedMovies.count, 3)
        
        try assertFindIndex(0, in: savedMovies, on: sut)
        try assertFindIndex(1, in: savedMovies, on: sut)
        try assertFindIndex(2, in: savedMovies, on: sut)
    }
}

extension MovieDTO {
    static var sample: Self {
        let id = UUID()
        let model = Movie(id: id, title: "any movie title")
        return MovieDTO(id: id, model: model)
    }
}

private extension InmemoryMovieRepositoryTests {
    func assertFindIndex(
        _ index: Int, in savedMovies: [Movie], on sut: InmemoryMovieRepository,
        file: StaticString = #filePath, line: UInt = #line
    ) throws {
        let id = try XCTUnwrap(savedMovies[index].id?.uuidString)
        let findedMovie = sut.find(by: id)
        let expectedMovie = savedMovies[index]
        
        XCTAssertEqual(findedMovie, expectedMovie, file: file, line: line)
    }
    
    func makeSUT() -> InmemoryMovieRepository {
        let sut = InmemoryMovieRepository()
        
        assertMemoryLeakFor(sut)
        
        return sut
    }
}
