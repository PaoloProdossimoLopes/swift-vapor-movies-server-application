import XCTest
@testable import App

final class MovieTests: XCTestCase {
    func test_init_createModel_passingCorrectValues() {
        let id = UUID()
        let title = "any title"
        
        let sut = Movie(id: id, title: title)
        
        XCTAssertEqual(sut.id, id)
        XCTAssertEqual(sut.title, title)
    }
}
