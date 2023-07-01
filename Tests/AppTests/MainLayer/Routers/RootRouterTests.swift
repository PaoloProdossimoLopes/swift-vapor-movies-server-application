import XCTest
import XCTVapor
@testable import App

final class RootRouterTests: XCTestCase {
    
    private var app: Application!
    
    override func setUp() async throws {
        app = Application(.testing)
        try await configure(app)
    }

    func test_get_root_respondsWith200StatusCode() async throws {
        try app.test(.GET, String()) { res in
            let response = try res.content.decode([String: Double].self)
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(response, ["statusCode": 200])
        }
    }
    
    override func tearDown() {
        app.shutdown()
    }
}
