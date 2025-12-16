// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ALPRTesseractWrapper",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ALPRTesseractWrapper",
            targets: ["ALPRTesseractWrapper"]
        )
    ],
    targets: [
        // Optional: Prebuilt dependencies as binary targets. Replace paths/URLs as needed.
        // .binaryTarget(
        //     name: "OpenCV",
        //     path: "Binaries/OpenCV.xcframework"
        // ),
        // .binaryTarget(
        //     name: "TesseractOCRiOS",
        //     path: "Binaries/TesseractOCR.xcframework"
        // ),

        .target(
            name: "ALPRTesseractWrapper",
            dependencies: [
                // "OpenCV",
                // "TesseractOCRiOS"
            ],
            path: "Sources/ALPRTesseractWrapper",
            publicHeadersPath: "include",
            sources: [
                "ObjC++/G8Tesseract.mm",
                "ObjC++/G8RecognitionOperation.m",
                "ObjC++/OAScanner.mm",
                "ObjC++/OATypes.mm",
                "ObjC++/UIImage+G8Filters.h",
                "ObjC++/G8TesseractParameters.h"
            ],
            resources: [
                .process("Resources/tessdata"),
                .process("Resources/openalpr.conf"),
                .process("Resources/runtime_data")
            ],
            cSettings: [
                // If you ship headers for Tesseract/OpenCV via xcframeworks, header paths come from the binary.
                // If you ship headers as sources, add header search paths here.
                // .headerSearchPath("relative/path/to/headers")
            ],
            cxxSettings: [
                .define("OPENCV_TRAITS_ENABLE_DEPRECATED", to: "1", .when(platforms: [.iOS])),
                .unsafeFlags(["-std=c++14"], .when(platforms: [.iOS]))
            ],
            linkerSettings: [
                // System frameworks required by your code and dependencies
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreImage"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("Accelerate"),
                // If not using TesseractOCRiOS prebuilt umbrella, you may need these system libs:
                .linkedLibrary("z")
            ]
        )
    ]
)
