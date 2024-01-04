// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FDAAudioPlayerRecorder",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "FDAAudioPlayerRecorder", targets: ["FDAAudioPlayerRecorder"]),
    ],
    targets: [
        .target(name: "FDAAudioPlayerRecorder"),
        .testTarget(name: "FDAAudioPlayerRecorderTests", dependencies: ["FDAAudioPlayerRecorder"]),
    ]
)
