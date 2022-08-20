// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GlucoseApp Backend",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "GlucoseApp Backend", targets: ["GlucoseApp Backend"]),
    ],
    dependencies: [
        .package(path: "../GlucoseApp Core"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .upToNextMajor(from: "0.5.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "GlucoseApp Backend",
            dependencies: [
                "GlucoseApp Core",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
            ]),
        .testTarget(
            name: "GlucoseApp BackendTests",
            dependencies: ["GlucoseApp Backend"]),
    ]
)
