// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenALPRSwift",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_15)
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
            cSettings: [
                // Header search path for embedded OpenALPR headers
                // This allows the package to find openalpr/alpr.h includes
                .headerSearchPath("../OpenALPRDependencies/include")
            ],
            cxxSettings: [
                // Header search paths for OpenALPR headers
                // Priority order: embedded headers, then fallback to system framework
                .headerSearchPath("../OpenALPRDependencies/include"),
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
