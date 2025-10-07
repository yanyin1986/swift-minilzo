# swift-minilzo

A Swift wrapper for the miniLZO library, providing fast real-time data compression and decompression capabilities.

## Features

- 🚀 Fast real-time data compression using the LZO algorithm
- 📦 Simple and intuitive Swift API
- 🔄 Compress and decompress `Data` objects
- 🎯 Compatible with iOS 14+ and macOS 12+
- ✅ Thread-safe operations

## Requirements

- iOS 14.0+ / macOS 12.0+
- Swift 6.2+
- Xcode 15.0+

## Installation

### Swift Package Manager

You can add swift-minilzo to your project using Swift Package Manager.

#### Using Xcode

1. In Xcode, go to **File** → **Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/yanyin1986/swift-minilzo.git
   ```
3. Select the version you want to use
4. Click **Add Package**

#### Using Package.swift

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yanyin1986/swift-minilzo.git", from: "1.0.0")
]
```

Then add `swift-minilzo` to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "swift-minilzo", package: "swift-minilzo")
    ]
)
```

## Usage

### Basic Example

```swift
import Foundation
import swift_minilzo

// Initialize the LZO library (call once at app startup)
LZO.initialize()

// Compress data
let originalString = "Hello, LZO!"
let originalData = originalString.data(using: .utf8)!

if let compressedData = LZO.compress(data: originalData) {
    print("Original size: \(originalData.count) bytes")
    print("Compressed size: \(compressedData.count) bytes")
    
    // Decompress data
    if let decompressedData = LZO.decompress(data: compressedData, originalSize: originalData.count),
       let decompressedString = String(data: decompressedData, encoding: .utf8) {
        print("Decompressed: \(decompressedString)")
    }
}
```

### Compressing Large Data

```swift
import Foundation
import swift_minilzo

// Initialize LZO
LZO.initialize()

// Load large data (e.g., from a file)
let largeData = try! Data(contentsOf: URL(fileURLWithPath: "/path/to/large/file.dat"))

// Compress
if let compressedData = LZO.compress(data: largeData) {
    let compressionRatio = Double(compressedData.count) / Double(largeData.count) * 100
    print("Compression ratio: \(String(format: "%.2f", compressionRatio))%")
    
    // Save compressed data
    try? compressedData.write(to: URL(fileURLWithPath: "/path/to/compressed.lzo"))
}
```

### Working with Network Data

```swift
import Foundation
import swift_minilzo

// Initialize LZO
LZO.initialize()

// Compress data before sending over network
func sendCompressedData(data: Data) {
    guard let compressedData = LZO.compress(data: data) else {
        print("Compression failed")
        return
    }
    
    // Send compressedData over network
    print("Sending \(compressedData.count) bytes (original: \(data.count) bytes)")
}

// Decompress received data
func receiveCompressedData(compressedData: Data, originalSize: Int) {
    guard let decompressedData = LZO.decompress(data: compressedData, originalSize: originalSize) else {
        print("Decompression failed")
        return
    }
    
    // Process decompressedData
    print("Received \(decompressedData.count) bytes")
}
```

### Error Handling

```swift
import Foundation
import swift_minilzo

LZO.initialize()

let data = "Test data".data(using: .utf8)!

// Compression can return nil on failure
if let compressedData = LZO.compress(data: data) {
    print("Compression successful")
    
    // Decompression can also return nil on failure
    if let decompressedData = LZO.decompress(data: compressedData, originalSize: data.count) {
        print("Decompression successful")
    } else {
        print("Decompression failed")
    }
} else {
    print("Compression failed")
}
```

### Batch Processing

```swift
import Foundation
import swift_minilzo

LZO.initialize()

let dataItems = [
    "First item".data(using: .utf8)!,
    "Second item".data(using: .utf8)!,
    "Third item".data(using: .utf8)!
]

// Compress multiple items
let compressedItems = dataItems.compactMap { LZO.compress(data: $0) }
print("Compressed \(compressedItems.count) items")

// Decompress multiple items
let decompressedItems = zip(compressedItems, dataItems).compactMap { compressed, original in
    LZO.decompress(data: compressed, originalSize: original.count)
}
print("Decompressed \(decompressedItems.count) items")
```

## API Reference

### `LZO`

The main class providing compression and decompression functionality.

#### Methods

##### `initialize()`

```swift
public static func initialize()
```

Initializes the LZO library. **Must be called once before using any compression or decompression methods.**

---

##### `compress(data:)`

```swift
public static func compress(data: Data) -> Data?
```

Compresses the provided data using the LZO1X-1 algorithm.

**Parameters:**
- `data`: The `Data` object to compress

**Returns:**
- The compressed `Data` object, or `nil` if compression fails

---

##### `decompress(data:originalSize:)`

```swift
public static func decompress(data: Data, originalSize: Int) -> Data?
```

Decompresses LZO-compressed data.

**Parameters:**
- `data`: The compressed `Data` object
- `originalSize`: The size of the original uncompressed data (in bytes)

**Returns:**
- The decompressed `Data` object, or `nil` if decompression fails

**Note:** You must provide the correct `originalSize` for successful decompression. Consider storing this value alongside the compressed data.

## Performance Tips

- **Initialize once**: Call `LZO.initialize()` once at application startup
- **Thread safety**: LZO operations are thread-safe and can be called from multiple threads
- **Buffer size**: The LZO algorithm is optimized for speed over compression ratio
- **Store original size**: Always store the original data size when saving compressed data

## About LZO

LZO is a portable lossless data compression library written in ANSI C. It offers very fast compression and decompression with reasonable compression ratios. The LZO library is designed to be extremely fast, making it ideal for:

- Real-time data compression
- Network data transmission
- Game asset compression
- Mobile applications where speed matters

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

The miniLZO library is licensed under the GNU General Public License (GPL).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Leon.yan

## Acknowledgments

- [LZO library](http://www.oberhumer.com/opensource/lzo/) by Markus F.X.J. Oberhumer
