// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftBok",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
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
    dependencies: [],
    targets: [
        .macro(
            name: "SwiftBokMacros",
            dependencies: [
                .target(name: "SwiftSyntaxWrapper")
            ]
        ),
        .target(name: "SwiftBok", dependencies: ["SwiftBokMacros"]),
        .executableTarget(name: "SwiftBokClient", dependencies: ["SwiftBok"]),
        .testTarget(
            name: "SwiftBokTests",
            dependencies: [
                "SwiftBokMacros",
                .target(name: "SwiftSyntaxWrapper")
            ]
        ),
        .binaryTarget(name: "SwiftSyntaxWrapper", path: "XCFramework/SwiftSyntaxWrapper.xcframework"),
    ]
)
