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
    if let databaseURL = Environment.get("DATABASE_URL"),
       var postgresConfig = SQLPostgresConfiguration(url: databaseURL) {
        // Heroku provides DATABASE_URL
        var tlsConfig: TLSConfiguration = .makeClientConfiguration()
        tlsConfig.certificateVerification = .none
        postgresConfig.tls = .require(try NIOSSLContext(configuration: tlsConfig))

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
