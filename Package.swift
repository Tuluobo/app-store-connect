// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ASCApi",
    products: [
        .library(name: "ASCApi", targets: ["ASCApi"]),
    ],
    dependencies: [
	// 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        // 🔏 JSON Web Token signing and verification (HMAC, RSA).
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "ASCApi", dependencies: ["Vapor", "JWT"]),
        .testTarget(name: "ASCApiTests", dependencies: ["ASCApi"]),
    ]
)
