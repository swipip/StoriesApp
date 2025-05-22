// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "StoriesLibrary",
    defaultLocalization: "fr",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Stories",
            targets: ["Stories"]),
    ],
    targets: [
        .target(
            name: "Stories",
            dependencies: [
                "StoriesUI",
                "StoriesCore"
            ]
        ),
        .target(
            name: "StoriesUI"
        ),
        .target(
            name: "StoriesCore"
        ),
        .testTarget(
            name: "StoriesTests",
            dependencies: ["Stories"]
        ),
    ]
)
