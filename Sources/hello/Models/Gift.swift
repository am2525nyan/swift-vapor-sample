import Vapor
import Fluent

final class Gift: Model, Content, @unchecked Sendable {
    static let schema = "gifts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "present")
    var present: String

    init() { }

    init(id: UUID? = nil, name: String, present: String) {
        self.id = id
        self.name = name
        self.present = present
    }
}

struct CreateGiftRequest: Content {
    let name: String
    let present: String
}
