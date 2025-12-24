import Fluent

struct CreateGift: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("gifts")
            .id()
            .field("name", .string, .required)
            .field("present", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("gifts").delete()
    }
}
