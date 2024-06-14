// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "PublicInit",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "PublicInit",
            targets: ["PublicInit"]
        ),
        .executable(
            name: "PublicInitClient",
            targets: ["PublicInitClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .macro(
            name: "PublicInitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "PublicInit", dependencies: ["PublicInitMacros"]),
        .executableTarget(name: "PublicInitClient", dependencies: ["PublicInit"]),
        .testTarget(
            name: "PublicInitTests",
            dependencies: [
                "PublicInitMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
