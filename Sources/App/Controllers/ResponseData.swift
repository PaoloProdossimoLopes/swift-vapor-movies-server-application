import Foundation

struct ResponseData<D> {
    let statusCode: Int
    let data: D
    
    init(model: Model<D>) {
        self.statusCode = model.statusCode
        self.data = model.data
    }
}
