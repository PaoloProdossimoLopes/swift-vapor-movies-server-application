import XCTest
@testable import App

final class RootControllerTests: XCTestCase {

    func test_index_returnsOkStatusCode() {
        let sut = RootController()
        let result = sut.index()
        XCTAssertEqual(result, ["statusCode": 200])
    }
}
