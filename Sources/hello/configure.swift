import Vapor
import Fluent
import FluentPostgresDriver
import NIOSSL
import PostgresNIO

// configures your application
public func configure(_ app: Application) async throws {
    // Configure port from environment variable (for Heroku)
    if let portString = Environment.get("PORT"), let port = Int(portString) {
        app.http.server.configuration.port = port
    }

    // Configure database
    if let databaseURL = Environment.get("DATABASE_URL") {
        // Heroku provides DATABASE_URL
        var tlsConfig: TLSConfiguration = .makeClientConfiguration()
        tlsConfig.certificateVerification = .none

        let nioSSLContext = try NIOSSLContext(configuration: tlsConfig)
        var postgresConfig = try PostgresConfiguration(url: databaseURL)
        postgresConfig.coreConfiguration.tls = .require(nioSSLContext)

        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        // Local development fallback
        app.databases.use(
            .postgres(
                hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
                username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
                password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
                database: Environment.get("DATABASE_NAME") ?? "vapor_database"
            ),
            as: .psql
        )
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
