// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "hello",
    platforms: [
       .macOS(.v14)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.118.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.88.0"),
        // 🗄️ ORM framework for Vapor
        .package(url: "https://github.com/vapor/fluent.git", from: "4.12.0"),
        // 🐘 Fluent driver for PostgreSQL
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.10.0"),
    ],
    targets: [
        .executableTarget(
            name: "hello",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "helloTests",
            dependencies: [
                .target(name: "hello"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
