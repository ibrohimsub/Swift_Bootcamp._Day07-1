// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Day07",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "Day07",
            dependencies: []),
        .executableTarget(
            name: "ex01",
            dependencies: []),
        .executableTarget(
            name: "ex02",
            dependencies: []),
        .executableTarget(
            name: "ex03",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
            ]),
        .testTarget(
            name: "Day07Tests",
            dependencies: ["Day07"]),
    ]
)
