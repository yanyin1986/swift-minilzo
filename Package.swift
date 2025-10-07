// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-minilzo",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "swift-minilzo",
            targets: ["swift-minilzo"]
        ),
    ],
    targets: [
        .target(
            name: "minilzo",
            publicHeadersPath: "include"
        ),
        .target(
            name: "swift-minilzo",
            dependencies: [
                "minilzo"
            ]
        ),
        .testTarget(
            name: "swift-minilzoTests",
            dependencies: ["swift-minilzo"]
        ),
    ]
)

