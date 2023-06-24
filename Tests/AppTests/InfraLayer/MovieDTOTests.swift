import XCTest
import Foundation
@testable import App

final class MovieDTOTests: XCTestCase {
    func test_init_withNilModelId_configureCorrectTheModel() {
        let id = UUID()
        let title = "any movie title"
        let model = Movie(id: nil, title: title)
        let sut = MovieDTO(id: id, model: model)
        
        XCTAssertEqual(sut.id, id)
        XCTAssertEqual(sut.title, title)
    }
    
    func test_init_withNonNilModelId_configureCorrectTheModel() {
        let id = UUID()
        let title = "any movie title"
        let model = Movie(id: id, title: title)
        let sut = MovieDTO(id: id, model: model)
        
        XCTAssertEqual(sut.id, id)
        XCTAssertEqual(sut.title, title)
    }
    
    func test_toModel_mapToModelCorrect() {
        let id = UUID()
        let title = "any movie title"
        let model = Movie(id: id, title: title)
        let sut = MovieDTO(id: id, model: model)
        
        XCTAssertEqual(sut.toModel(), model)
    }
}
