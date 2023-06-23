
struct ResponseResult<D> {
    let data: D?
    let statusCode: Int
    let error: ErrorResult?
    
    private init(data: D?, statusCode: Int, error: ErrorResult?) {
        self.data = data
        self.statusCode = statusCode
        self.error = error
    }
    
    static var noContent: Self {
        let noContentStatusCode = 204
        return ResponseResult(data: nil, statusCode: noContentStatusCode, error: nil)
    }
    
    static func notFound(reason: String) -> Self {
        let notFoundStatusCode = 404
        let notFoundError = ErrorResult(error: true, reason: reason)
        return ResponseResult(data: nil, statusCode: notFoundStatusCode, error: notFoundError)
    }
    
    static func ok(_ data: D) -> Self {
        let okStatusCode = 200
        return ResponseResult(data: data, statusCode: okStatusCode, error: nil)
    }
    
    static func created(_ data: D) -> Self {
        let createdStatusCode = 201
        return ResponseResult(data: data, statusCode: createdStatusCode, error: nil)
    }
}

struct ErrorResult {
    let error: Bool
    let reason: String
}
