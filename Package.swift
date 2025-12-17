// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenALPRSwift",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "OpenALPRSwift",
            targets: ["OpenALPRSwift"]
        )
    ],
    targets: [
        // Swift wrapper target for OpenALPR
        // Note: This package requires OpenCV and OpenALPR C++ libraries to be available
        // For iOS projects, these dependencies are typically provided via CocoaPods
        // See README.md and SPM_INTEGRATION.md for integration instructions
        .target(
            name: "OpenALPRSwift",
            path: "Sources/OpenALPRSwift",
            sources: [
                "OAScanner.mm",
                "OATypes.mm"
            ],
            resources: [
                .process("Resources/openalpr.conf"),
                .process("Resources/runtime_data")
            ],
            publicHeadersPath: "include",
            cxxSettings: [
                // Note: This header search path points to the bundled openalpr.framework
                // Consumer projects will need to provide OpenCV and OpenALPR dependencies
                .headerSearchPath("../../lib/openalpr.framework/Headers"),
                .define("OPENCV_TRAITS_ENABLE_DEPRECATED", to: "1", .when(platforms: [.iOS]))
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
                .linkedFramework("Foundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreImage"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("Accelerate"),
                .linkedLibrary("z"),
                .linkedLibrary("c++")
            ]
        ),
        .testTarget(
            name: "OpenALPRSwiftTests",
            dependencies: ["OpenALPRSwift"],
            path: "Tests/OpenALPRSwiftTests"
        )
    ]
)
