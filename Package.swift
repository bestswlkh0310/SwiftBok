// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftBok",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "SwiftBok",
            targets: ["SwiftBok"]
        ),
        .executable(
            name: "SwiftBokClient",
            targets: ["SwiftBokClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .macro(
            name: "SwiftBokMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "SwiftBok", dependencies: ["SwiftBokMacros"]),
        .executableTarget(name: "SwiftBokClient", dependencies: ["SwiftBok"]),
        .testTarget(
            name: "SwiftBokTests",
            dependencies: [
                "SwiftBokMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
