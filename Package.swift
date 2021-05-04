// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VCDependencyContainer",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "VCDependencyContainer",
            targets: ["VCDependencyContainer"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/avreolko/VCWeakContainer.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "VCDependencyContainer",
            dependencies: ["VCWeakContainer"],
            path: "Sources"
        ),
        .testTarget(
            name: "VCDependencyContainerTests",
            dependencies: ["VCDependencyContainer"],
            path: "Tests"
        ),
    ]
)
