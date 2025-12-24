import Vapor
import Fluent
import FluentPostgresDriver
import NIOSSL
import PostgresNIO
import Foundation

// configures your application
public func configure(_ app: Application) async throws {
    // Configure port from environment variable (for Heroku)
    if let portString = Environment.get("PORT"), let port = Int(portString) {
        app.http.server.configuration.port = port
    }

    // Configure database
    if let databaseURL = Environment.get("DATABASE_URL") {
        // Heroku provides DATABASE_URL
        // Parse URL and configure with TLS
        guard let url = URL(string: databaseURL),
              let host = url.host,
              let user = url.user,
              let password = url.password else {
            fatalError("Invalid DATABASE_URL")
        }

        let dbName = String(url.path.dropFirst())
        let port = url.port ?? SQLPostgresConfiguration.ianaPortNumber

        var tlsConfig: TLSConfiguration = .makeClientConfiguration()
        tlsConfig.certificateVerification = .none

        let postgresConfig = SQLPostgresConfiguration(
            hostname: host,
            port: port,
            username: user,
            password: password,
            database: dbName,
            tls: .require(try NIOSSLContext(configuration: tlsConfig))
        )

        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        // Local development fallback
        let postgresConfig = SQLPostgresConfiguration(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database",
            tls: .disable
        )
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    }

    // Add migrations
    app.migrations.add(CreateGift())

    // Run migrations automatically (optional - use with caution in production)
    if app.environment != .production {
        try await app.autoMigrate()
    }

    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
}
