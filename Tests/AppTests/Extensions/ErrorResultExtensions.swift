@testable import App

extension ErrorResult: Equatable {
    public static func == (lhs: ErrorResult,  rhs: ErrorResult) -> Bool {
        lhs.error == rhs.error && lhs.reason == rhs.reason
    }
}
