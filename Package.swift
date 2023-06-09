// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Chroma",
    products: [
        .library(name: "Chroma", targets: ["Chroma"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SolarDesignSystem/Matrix-Swift.git", from: "1.0.6"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Chroma", dependencies: [
            .product(name: "Matrix", package: "Matrix-Swift")
        ]),
        .testTarget(name: "ChromaTests", dependencies: [
            "Chroma",
            .product(name: "Matrix", package: "Matrix-Swift")
        ]),
    ]
)
