// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import minilzo

open class LZO {

    public static func initialize () {
        let r = lzo_init_wrapper()
        if r != LZO_E_OK {
            print("init lzo failed")
        }
    }

    public static func compress(data: Data) -> Data? {
        let capacity = data.count + data.count / 16 + 64 + 3
        var outData: Data = Data(count: capacity)
        var outLen: lzo_uint = 0
        var wrkMem = [UInt8](repeating: 0, count: Int(kLZO1X_MEM_COMPRESS))

        let r = data.withUnsafeBytes { srcPtr in
            outData.withUnsafeMutableBytes { dstPtr in
                wrkMem.withUnsafeMutableBytes { wrkPtr in
                    return lzo1x_1_compress(
                        srcPtr.baseAddress?.assumingMemoryBound(to: UInt8.self),
                        lzo_uint(data.count),
                        dstPtr.baseAddress?.assumingMemoryBound(to: UInt8.self),
                        &outLen,
                        wrkPtr.baseAddress
                    )
                }
            }
        }

        if r != LZO_E_OK {
            return nil
        }
        outData.count = Int(outLen)
        return outData
    }

    public static func decompress(data: Data, originalSize: Int) -> Data? {
        var output = Data(count: originalSize)
        var newLen: lzo_uint = 0

        let r = data.withUnsafeBytes { srcPtr in
            return output.withUnsafeMutableBytes { dstPtr in
                return lzo1x_decompress(
                    srcPtr.baseAddress?.assumingMemoryBound(to: UInt8.self),
                    lzo_uint(data.count),
                    dstPtr.baseAddress?.assumingMemoryBound(to: UInt8.self),
                    &newLen,
                    nil)
            }
        }
        if r != LZO_E_OK {
            return nil
        }
        output.count = Int(newLen)
        return output
    }
}
