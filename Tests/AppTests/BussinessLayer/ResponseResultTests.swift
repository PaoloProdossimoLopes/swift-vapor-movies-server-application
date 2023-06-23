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
    
    func test_notFound_dataIsNill() {
        let sut = ResponseResult<String>.notFound(reason: "any reason")
        XCTAssertEqual(sut.data, nil)
    }
    
    func test_notFound_errorIsNotNil() {
        let reason = "any reason"
        let sut = ResponseResult<String>.notFound(reason: reason)
        
        XCTAssertNotNil(sut.error)
    }
    
    func test_notFound_errorIsTrue() {
        let reason = "any reason"
        let sut = ResponseResult<String>.notFound(reason: reason)
        
        XCTAssertTrue(sut.error?.error == true)
    }
    
    func test_notFound_errorReasonIsCorrect() {
        let reason = "any reason"
        let sut = ResponseResult<String>.notFound(reason: reason)
        
        XCTAssertEqual(sut.error?.reason, reason)
    }
    
    func test_notFound_statusCodeEqual404() {
        let sut = ResponseResult<String>.notFound(reason: "any reason")
        XCTAssertEqual(sut.statusCode, 404)
    }
    
    func test_ok_dataIsNill() {
        let data = "any model here"
        let sut = ResponseResult.ok(data)
        XCTAssertEqual(sut.data, data)
    }
    
    func test_ok_errorIsNill() {
        let sut = ResponseResult.ok("any model here")
        XCTAssertNil(sut.error)
    }
    
    func test_ok_statusCodeEqual200() {
        let sut = ResponseResult.ok("any model here")
        XCTAssertEqual(sut.statusCode, 200)
    }
    
    func test_created_dataIsNill() {
        let data = "any model here"
        let sut = ResponseResult.created(data)
        XCTAssertEqual(sut.data, data)
    }
    
    func test_created_errorIsNill() {
        let sut = ResponseResult.created("any model here")
        XCTAssertNil(sut.error)
    }
    
    func test_created_statusCodeEqual200() {
        let sut = ResponseResult.created("any model here")
        XCTAssertEqual(sut.statusCode, 201)
    }
}
