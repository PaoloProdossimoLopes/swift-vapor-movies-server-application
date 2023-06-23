@testable import App

extension ResponseResult: Equatable where D: Equatable {
    public static func == (lhs: App.ResponseResult<D>, rhs: App.ResponseResult<D>) -> Bool {
        lhs.data == rhs.data && lhs.error == rhs.error && lhs.statusCode == rhs.statusCode
    }
}
