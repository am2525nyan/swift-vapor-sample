import Vapor
import Fluent

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("hello", ":name") { req -> String in
        let name = req.parameters.get("name")!
        return "Hello, \(name)!"
    }

    // Create a new gift
    app.post("gifts") { req async throws -> Gift in
        let createRequest = try req.content.decode(CreateGiftRequest.self)
        let gift = Gift(name: createRequest.name, present: createRequest.present)
        try await gift.save(on: req.db)
        return gift
    }

    // Get all gifts
    app.get("gifts") { req async throws -> [Gift] in
        try await Gift.query(on: req.db).all()
    }

    // Get a specific gift by ID
    app.get("gifts", ":id") { req async throws -> Gift in
        guard let gift = try await Gift.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return gift
    }

    // Update a gift
    app.put("gifts", ":id") { req async throws -> Gift in
        guard let gift = try await Gift.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updateRequest = try req.content.decode(CreateGiftRequest.self)
        gift.name = updateRequest.name
        gift.present = updateRequest.present
        try await gift.save(on: req.db)
        return gift
    }

    // Delete a gift
    app.delete("gifts", ":id") { req async throws -> HTTPStatus in
        guard let gift = try await Gift.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await gift.delete(on: req.db)
        return .noContent
    }
}
