import Foundation
@testable import App

extension Movie: Equatable {
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}

extension Movie {
    static var withoutId: Self {
        Movie(id: nil, title: "any title with id null")
    }
    
    static var withId: Self {
        let id = UUID()
        return Movie(id: id, title: "any title with id: \(id.uuidString)")
    }
}

extension [Movie] {
    static var empty: Self {
        []
    }
    
    static var withNullId: Self {
        [.withoutId]
    }
    
    static var noEmpty: Self {
        [.withId]
    }
}
