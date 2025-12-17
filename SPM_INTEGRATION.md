# Swift Package Manager Integration Guide

## Overview

OpenALPRSwift now supports Swift Package Manager (SPM) for easier integration into Swift projects. The package provides the Objective-C++ wrapper layer for OpenALPR license plate recognition.

## Package Structure

```
OpenALPRSwift/
├── Package.swift                    # SPM manifest
├── Sources/
│   ├── OpenALPRSwift/
│   │   ├── include/                 # Public headers
│   │   │   ├── OpenALPRSwift.h     # Umbrella header
│   │   │   ├── OAScanner.h         # Scanner interface
│   │   │   └── OATypes.h           # Type definitions
│   │   ├── OAScanner.mm            # Scanner implementation
│   │   ├── OATypes.mm              # Type implementations
│   │   └── Resources/              # Runtime data and config
│   │       ├── openalpr.conf
│   │       └── runtime_data/
│   └── OpenALPRDependencies/
│       └── include/
│           └── openalpr/           # Embedded OpenALPR headers
│               ├── alpr.h          # Main ALPR header
│               ├── config.h        # Configuration header
│               └── constants.h     # Constants header
└── Tests/
    └── OpenALPRSwiftTests/
        └── openalpr_swiftTests.swift
```

## Adding the Package

### Xcode

1. In Xcode, go to **File > Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/goteamswork/openalpr-swift.git`
3. Select the version (recommended: "Up to Next Major Version" from 2.0.0)
4. Click **Add Package**
5. Select your target and click **Add Package** again

### Package.swift

Add OpenALPRSwift to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/goteamswork/openalpr-swift.git", from: "2.0.0")
]
```

Then add it to your target:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "OpenALPRSwift", package: "openalpr-swift")
        ]
    )
]
```

## Important Notes

### Dependencies

⚠️ **OpenALPRSwift requires external C++ dependencies:**

- **OpenALPR C++ Library**: The core license plate recognition engine
- **OpenCV**: Computer vision library for image processing

#### Embedded Headers

This package includes **embedded OpenALPR header files** in `Sources/OpenALPRDependencies/include/openalpr/` to resolve the `openalpr/alpr.h` import issues. This allows the package to compile without requiring OpenALPR headers to be installed system-wide. However, the compiled OpenCV and OpenALPR libraries are still required for linking and runtime execution.

#### Installing System Libraries

The actual compiled libraries are **not included** in the SPM package due to their size and complexity. You need to install them separately:

**macOS (Homebrew):**
```bash
brew install openalpr opencv
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install libopenalpr-dev libopencv-dev
```

**Note:** For iOS projects, these dependencies are typically provided through CocoaPods or bundled frameworks.

### Recommended Integration Method

For production use, we recommend using **CocoaPods** instead of SPM, as it handles the complex C++ dependencies automatically. See the main [README.md](README.md) for CocoaPods integration instructions.

### SPM Limitations

- **Platform Support**: Primarily designed for iOS 12+ and macOS 10.15+. Linux support is experimental and may require additional configuration.
- **Library Dependencies**: Requires manual installation of OpenCV and OpenALPR C++ libraries on your system.
- **Build Configuration**: May require additional linker flags or library search paths depending on your system setup.
- **Best Use Case**: Development environments where OpenCV and OpenALPR are already configured, or iOS projects that can link against bundled frameworks.

### Cross-Platform Compatibility

- **iOS**: ✅ Fully supported when used with CocoaPods for dependencies or bundled frameworks
- **macOS**: ✅ Supported with system-installed OpenALPR and OpenCV libraries  
- **Linux**: ⚠️ Experimental - requires system libraries and may need additional configuration

**Known Limitations:**
- Some iOS-specific frameworks (UIKit, CoreImage, etc.) are conditionally linked and will not be available on macOS/Linux
- OpenCV installation paths may vary by system; you may need to add custom header/library search paths

## Usage

Once integrated, import the module in your Swift files:

```swift
import OpenALPRSwift

// Initialize scanner
let scanner = OAScanner(country: "us", patternRegion: "ca")

// Scan an image
scanner?.scanImage(image, onSuccess: { plates in
    plates?.forEach { plate in
        print("Detected plate: \(plate.number)")
    }
}, onFailure: { error in
    print("Error: \(error?.localizedDescription ?? "Unknown error")")
})
```

## API Reference

### OAScanner

The main scanner class for license plate recognition.

**Initialization:**
- `init(country:)` - Initialize with country code
- `init(country:patternRegion:)` - Initialize with country and region pattern

**Methods:**
- `scanImage(_:onSuccess:onFailure:)` - Scan a UIImage
- `scanImageAtPath(_:onSuccess:onFailure:)` - Scan image from file path
- `setPatternRegion(_:)` - Set the pattern region
- `setTopN(_:)` - Set maximum number of results

### OATypes

Type definitions for recognition results:

- `OAResults` - Complete recognition results
- `OAPlateResult` - Individual plate result
- `OAPlate` - Plate information with confidence
- `OACharacter` - Individual character details

## Platform Support

- **iOS 12.0+**
- **macOS 10.15+**
- Swift 5.9+

## Header Files

This package includes embedded OpenALPR header files to resolve compilation issues:
- `Sources/OpenALPRDependencies/include/openalpr/alpr.h` - Main OpenALPR API
- `Sources/OpenALPRDependencies/include/openalpr/config.h` - Configuration definitions
- `Sources/OpenALPRDependencies/include/openalpr/constants.h` - Constant definitions

These headers are automatically included in the build via the `cSettings` and `cxxSettings` configuration in `Package.swift`.

## Resources

The package includes all necessary runtime data:
- Configuration files for different countries
- OCR training data
- Pattern recognition data
- Region detection data

## Testing

Run the included tests:

```bash
swift test
```

Note: Tests may fail without proper C++ dependencies configured.

## License

This package is licensed under GPLv3. See [LICENSE](LICENSE) for details.

## Support

For issues and questions:
- GitHub Issues: https://github.com/goteamswork/openalpr-swift/issues
- OpenALPR Documentation: http://doc.openalpr.com/
