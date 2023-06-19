import Fluent

struct CreateMovies: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(MovieDTO.schema)
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(MovieDTO.schema)
            .delete()
    }
}
