// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Alpine-test1",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "Alpine-test1", targets: ["Alpine-test1"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/kyouko-taiga/AlpineLang.git", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Alpine-test1",
            dependencies: ["alpine"]),
        .testTarget(
            name: "Alpine-test1Tests",
            dependencies: ["Alpine-test1"]),
    ]
)
