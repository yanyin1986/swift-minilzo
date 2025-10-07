import Foundation
import Testing
@testable import swift_minilzo

enum TestError: Error {
    case decompressFailed
}

@Test
func testLZOCompress() throws {
    let d = Data([
        27, 72, 101, 108, 108, 111, 32,
        76, 90, 79, 33, 17, 0, 0
    ])
    LZO.initialize()

    let data = "Hello LZO!".data(using: .utf8)!
    let compressedData = LZO.compress(data: data)
    #expect(compressedData == d)
}

@Test
func testLZODecompress() throws {
    let d = Data([
        27, 72, 101, 108, 108, 111, 32,
        76, 90, 79, 33, 17, 0, 0
    ])
    LZO.initialize()

    guard
        let decompressedData = LZO.decompress(data: d, originalSize: 10)
    else {
        throw TestError.decompressFailed
    }
    guard
        let decompressedString = String(data: decompressedData, encoding: .utf8)
    else {
        throw TestError.decompressFailed
    }
    #expect(decompressedString == "Hello LZO!")
}
