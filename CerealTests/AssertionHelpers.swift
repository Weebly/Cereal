//
//  AssertionHelpers.swift
//  Cereal
//
//  Created by James Richard on 8/12/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Foundation
import Cereal

extension String {
    func containsSubstring(_ substring: String) -> Bool {
        return range(of: substring) != nil
    }
}

extension CerealEncoder {
    func toBytes() -> [UInt8] {
        let data = self.toData()
        return [UInt8](data)
    }
}

extension CerealDecoder {
    init(encodedBytes: [UInt8]) throws {
        let data = Data(encodedBytes)// (bytes: encodedBytes, length: encodedBytes.count)
        try self.init(data: data)
    }
}

extension ArraySlice where Element: Comparable {
    func hasArrayPrefix(_ array: ArraySlice<Element>) -> Bool {
        guard self.count >= array.count else { return false }

        return self[0..<array.count] == array
    }

    func containsSubArray(_ array: ArraySlice<Element>) -> Bool {
        guard array.count > 0 else { return false }
        guard self.count >= array.count else { return false }

        for (index,item) in self.enumerated() {
            if item == array.first {
                if array.count == 1 {
                    return true
                }

                return self[self.indices.lowerBound.advanced(by: index)..<self.indices.upperBound].containsSubArray(array[(array.indices.lowerBound + 1)..<array.indices.upperBound])
            }
        }

        return false
    }
}

extension Array where Element: Comparable {
    func hasArrayPrefix(_ array: [Element]) -> Bool {
        guard self.count >= array.count else { return false }

        return self[0..<array.count] == array[0..<array.count]
    }
    func containsSubArray(_ array: [Element]) -> Bool {
        guard array.count > 0 else { return false }

        return self[self.indices].containsSubArray(array[array.indices])
    }
}

func toByteArray<Type>(_ value: Type) -> [UInt8] {
    var unsafeValue = value

    return withUnsafePointer(to: &unsafeValue) {
        return $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<Type>.size, { pointer in
            return [UInt8](UnsafeBufferPointer(start: pointer, count: MemoryLayout<Type>.size))
        })
    }
}

