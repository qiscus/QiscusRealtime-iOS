// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QiscusRealtime-iOS",
    platforms: [
            .macOS(.v10_12),
            .iOS(.v10),
    ],
    products: [
        .library(
            name: "QiscusRealtime",
            targets: ["QiscusRealtime"]),
    ],
    dependencies: [
        .package(url: "https://github.com/emqx/CocoaMQTT.git", .upToNextMajor(from: "1.3.0-rc.2"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "QiscusRealtime",
            dependencies: ["CocoaMQTT"],
            path: "Source"),
    ]
)
