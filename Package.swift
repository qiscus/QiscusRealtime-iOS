// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QiscusRealtime",
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
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "QiscusRealtime",
            dependencies: [],
	    path: "Source"),
        .testTarget(
            name: "QiscusRealtimeTests",
            path: "Sources/Test"),
            dependencies: ["QiscusRealtime"]),
    ]
)
