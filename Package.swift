// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Hog",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "Hog", targets: ["Hog"])
    ],
    targets: [
        .executableTarget(
            name: "Hog",
            path: "Sources/Hog"
        ),
        .testTarget(
            name: "HogTests",
            dependencies: ["Hog"],
            path: "Tests/HogTests"
        )
    ]
)
