// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SocialKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "SocialKit",
            targets: ["SocialKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/marmelroy/PhoneNumberKit.git", .upToNextMajor(from: "4.0.0")),
    ],
    targets: [
        .target(
            name: "SocialKit", dependencies: ["PhoneNumberKit"], exclude: ["../../Example"]),

    ]
)
