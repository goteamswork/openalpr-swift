# Swift Package Manager Integration Guide

## Overview

OpenALPRSwift now supports Swift Package Manager (SPM) for easier integration into Swift projects. The package provides the Objective-C++ wrapper layer for OpenALPR license plate recognition.

## Package Structure

```
OpenALPRSwift/
├── Package.swift                    # SPM manifest
├── Sources/
│   └── OpenALPRSwift/
│       ├── include/                 # Public headers
│       │   ├── OpenALPRSwift.h     # Umbrella header
│       │   ├── OAScanner.h         # Scanner interface
│       │   └── OATypes.h           # Type definitions
│       ├── OAScanner.mm            # Scanner implementation
│       ├── OATypes.mm              # Type implementations
│       └── Resources/              # Runtime data and config
│           ├── openalpr.conf
│           └── runtime_data/
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

These dependencies are **not included** in the SPM package due to their complexity and size. The package includes the wrapper layer and configuration files only.

### Recommended Integration Method

For production use, we recommend using **CocoaPods** instead of SPM, as it handles the complex C++ dependencies automatically. See the main [README.md](README.md) for CocoaPods integration instructions.

### SPM Limitations

- Cannot build on Linux or macOS (iOS-specific framework dependencies)
- Requires manual setup of OpenCV and OpenALPR C++ libraries
- Best suited for development environments where these dependencies are already configured

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
- Swift 5.9+

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
