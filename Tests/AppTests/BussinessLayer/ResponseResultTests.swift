import XCTest
@testable import App

final class ResponseResultTests: XCTestCase {
    func test_noContent_dataIsNill() {
        let sut = ResponseResult<String>.noContent
        XCTAssertEqual(sut.data, nil)
    }
    
    func test_noContent_errorIsNill() {
        let sut = ResponseResult<String>.noContent
        XCTAssertNil(sut.error)
    }
    
    func test_noContent_statusCodeEqual204() {
        let sut = ResponseResult<String>.noContent
        XCTAssertEqual(sut.statusCode, 204)
    }
}
