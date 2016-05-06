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
    func containsSubstring(substring: String) -> Bool {
        return rangeOfString(substring) != nil
    }
}

extension CerealEncoder {
    func toBytes() -> [UInt8] {
        let data = self.toData()
        return Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(data.bytes), count: data.length))
    }
}

extension CerealDecoder {
    init(encodedBytes: [UInt8]) throws {
        let data = NSData(bytes: encodedBytes, length: encodedBytes.count)
        try self.init(data: data)
    }
}

extension ArraySlice where Element: Comparable {
    func hasArrayPrefix(array: ArraySlice<Element>) -> Bool {
        guard self.count >= array.count else { return false }

        return self[0..<array.count] == array
    }

    func containsSubArray(array: ArraySlice<Element>) -> Bool {
        guard array.count > 0 else { return false }
        guard self.count >= array.count else { return false }

        for (index,item) in self.enumerate() {
            if item == array.first {
                if array.count == 1 {
                    return true
                }

                return self[self.indices.startIndex.advancedBy(index)..<self.indices.endIndex].containsSubArray(array[array.indices.startIndex.successor()..<array.indices.endIndex])
            }
        }

        return false
    }
}

extension Array where Element: Comparable {
    func hasArrayPrefix(array: [Element]) -> Bool {
        guard self.count >= array.count else { return false }

        return self[0..<array.count] == array[0..<array.count]
    }
    func containsSubArray(array: [Element]) -> Bool {
        guard array.count > 0 else { return false }

        return self[self.indices].containsSubArray(array[array.indices])
    }
}