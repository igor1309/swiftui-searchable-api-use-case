// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swiftui-searchable-api-use-case",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SwiftUISearchableAPIUseCase",
            targets: ["SwiftUISearchableAPIUseCase"]),
    ],
    targets: [
        .target(name: "SwiftUISearchableAPIUseCase"),
    ]
)
