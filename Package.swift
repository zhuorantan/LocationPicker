// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "LocationPicker",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "LocationPicker",
            targets: ["LocationPicker"]
        )
    ],
    targets: [
        .target(
            name: "LocationPicker",
            path: "LocationPicker"
        )
    ]
)
