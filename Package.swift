// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Inferno",
    products: [
        .executable(name: "inferno", targets: ["Inferno"]),
        .library(name: "InfernoKit", targets: ["InfernoKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax", from: "0.50100.0"),
        .package(url: "https://github.com/apple/indexstore-db", .branch("swift-5.1-branch"))
    ],
    targets: [
        .target(
            name: "Inferno",
            dependencies: ["InfernoKit"]),
        .target(
            name: "InfernoKit",
            dependencies: [
                "SwiftSyntax",
                "IndexStoreDB"
            ]),
        .testTarget(
            name: "InfernoTests",
            dependencies: ["Inferno"]),
    ]
)
