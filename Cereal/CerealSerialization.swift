//
//  CerealSerialization.swift
//  Cereal
//
//  Created by Sergey Galezdinov on 27.04.16.
//  Copyright © 2016 Weebly. All rights reserved.
//

import Foundation

// MARK: Types

/// Recursive tree enum that represents data being encoded/decoded
internal indirect enum CoderTreeValue {
    case string(String)
    case int(Int)
    case int64(Int64)
    case double(Double)
    case float(Float)
    case bool(Bool)
    case date(Date)
    case url(URL)
    case data(Data)

    case pair(CoderTreeValue, CoderTreeValue)
    case array([CoderTreeValue])
    case subTree([CoderTreeValue])
    case identifyingTree(String,[CoderTreeValue])
}

/// Byte header to identify CoderTreeValue in a byte array
internal enum CerealCoderTreeValueType: UInt8 {
    case string = 1
    case int = 2
    case int64 = 3
    case double = 4
    case float = 5
    case bool = 6
    case nsDate = 7
    case nsurl = 8

    case pair = 9
    case array = 10
    case subTree = 11
    case identifyingTree = 12

    case data = 13
}

// MARK: Helpers

/// function takes a value of type `Type` and returns a byte array representation
private func toByteArray<Type>(_ value: Type) -> [UInt8] {
    var unsafeValue = value

    return withUnsafePointer(to: &unsafeValue) {
        return $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<Type>.size, { pointer in
            return [UInt8](UnsafeBufferPointer(start: pointer, count: MemoryLayout<Type>.size))
        })
    }
}

/// function takes an array of bytes and returns a value of type `Type`
private func fromByteArray<Type>(_ value: [UInt8], _: Type.Type) -> Type {
    return value.withUnsafeBufferPointer {
        $0.baseAddress!.withMemoryRebound(to: Type.self, capacity: 1) {
            $0.pointee
        }
    }
}

/// function reads an array of bytes and returns an integer value (Int, Int64 etc)
private func bytesToInteger<Type>(_ from: [UInt8]) -> Type where Type: SignedInteger {
    return from.withUnsafeBufferPointer({
        UnsafeRawPointer($0.baseAddress!).load(as: Type.self)
    })
}

/// function returns a number of .string entries inside an array of CoderTreeValue (including subtrees)
private func stringEntriesCount(_ array: [CoderTreeValue]) -> Int {
    var result = 0
    for item in array {
        result += item.numberOfStringEntries
    }
    return result
}

/// function returns a byte array in format [length_in_bytes] + [number of array items] + [bytes of CoderTreeValue array]
/// this allows a decoder to set a capacity for an array of CoderTreeValue beign decoded from bytes
private func countCapacityBytes(_ array: [CoderTreeValue]) -> [UInt8] {
    var stringMap = Dictionary<String, [UInt8]>(minimumCapacity: stringEntriesCount(array))

    return countCapacityBytes(array, stringMap: &stringMap)
}

/// function returns a byte array in format [length_in_bytes] + [number of array items] + [bytes of CoderTreeValue array]
/// this allows a decoder to set a capacity for an array of CoderTreeValue beign decoded from bytes
/// - note: stringMap dictionary is used to improve string encoding speed, see `String.writeToBuffer`
private func countCapacityBytes(_ array: [CoderTreeValue], stringMap: inout [String: [UInt8]]) -> [UInt8] {
    var result = [UInt8]()

    for item in array {
        item.writeToBuffer(&result, stringMap: &stringMap)
    }

    let count = toByteArray(result.count)
    let capacity = toByteArray(array.count)

    result.insert(contentsOf: capacity, at: 0)
    result.insert(contentsOf: count, at: 0)
    return result
}

// MARK: encoding extensions

private extension String {
    func writeToBuffer(_ buffer: inout [UInt8], stringMap: inout [String: [UInt8]]) {
        // if the string was already decoded, getting from a dictionary is a cheaper operation than getting utf8 view
        if let bytes = stringMap[self] {
            buffer.append(contentsOf: bytes)
            return
        }

        var array = Array(self.utf8)
        array.insert(contentsOf: toByteArray(array.count), at: 0)
        buffer.append(contentsOf: array)
        stringMap.updateValue(array, forKey: self)
    }
}

private extension CoderTreeValue {
    var numberOfStringEntries: Int {
        switch self {
        case .string, .url:
            return 1
        case let .array(items):
            return stringEntriesCount(items)

        case let .subTree(items):
            return stringEntriesCount(items)

        case let .identifyingTree(_,items):
            return 1 + stringEntriesCount(items)

        default:
            return 0
        }
    }

    func writeToBuffer(_ buffer: inout [UInt8], stringMap: inout [String: [UInt8]]) {
        switch self {
            case .string, .url:
                self.writeStringBytes(&buffer, stringMap: &stringMap)

            case .int, .int64, .bool:
                self.writeIntBytes(&buffer)

            case .double, .float, .date:
                self.writeFloatBytes(&buffer)

            case let .pair(key, value):
                buffer.append(CerealCoderTreeValueType.pair.rawValue)
                key.writeToBuffer(&buffer, stringMap: &stringMap)
                value.writeToBuffer(&buffer, stringMap: &stringMap)

            case let .array(array):
                buffer.append(CerealCoderTreeValueType.array.rawValue)
                buffer.append(contentsOf: countCapacityBytes(array, stringMap: &stringMap))

            case let .subTree(items):
                buffer.append(CerealCoderTreeValueType.subTree.rawValue)
                buffer.append(contentsOf: countCapacityBytes(items, stringMap: &stringMap))

            case let .identifyingTree(key, items):
                buffer.append(CerealCoderTreeValueType.identifyingTree.rawValue)
                CoderTreeValue.string(key).writeToBuffer(&buffer, stringMap: &stringMap)
                buffer.append(contentsOf: countCapacityBytes(items, stringMap: &stringMap))

            case let .data(value):
                var bytes = [UInt8](value)
                buffer.append(CerealCoderTreeValueType.data.rawValue)
                bytes.insert(contentsOf: toByteArray(bytes.count), at: 0)
                buffer.append(contentsOf: bytes)
        }
    }

    func writeStringBytes(_ buffer: inout [UInt8], stringMap: inout [String: [UInt8]]) {
        switch self {
        case let .string(string):
            buffer.append(CerealCoderTreeValueType.string.rawValue)
            string.writeToBuffer(&buffer, stringMap: &stringMap)
        case let .url(url):
            buffer.append(CerealCoderTreeValueType.nsurl.rawValue)
            url.absoluteString.writeToBuffer(&buffer, stringMap: &stringMap)

        default:
            break
        }
    }

    func writeIntBytes(_ buffer: inout [UInt8]) {
        switch self {
        case let .int(int):
            buffer.append(CerealCoderTreeValueType.int.rawValue)
            var array = toByteArray(int)
            array.insert(contentsOf: toByteArray(array.count), at: 0)
            buffer.append(contentsOf: array)

        case let .int64(int64):
            buffer.append(CerealCoderTreeValueType.int64.rawValue)
            var array = toByteArray(int64)
            array.insert(contentsOf: toByteArray(array.count), at: 0)
            buffer.append(contentsOf: array)

        case let .bool(bool):
            buffer.append(CerealCoderTreeValueType.bool.rawValue)
            buffer.append(contentsOf: toByteArray(1))
            buffer.append(bool ? 1 : 0)

        default:
            break
        }
    }

    func writeFloatBytes(_ buffer: inout [UInt8]) {
        switch self {
        case let .double(double):
            buffer.append(CerealCoderTreeValueType.double.rawValue)
            var array = toByteArray(double)
            array.insert(contentsOf: toByteArray(array.count), at: 0)
            buffer.append(contentsOf: array)

        case let .float(float):
            buffer.append(CerealCoderTreeValueType.float.rawValue)
            var array = toByteArray(float)
            array.insert(contentsOf: toByteArray(array.count), at: 0)
            buffer.append(contentsOf: array)

        case let .date(date):
            let interval = date.timeIntervalSinceReferenceDate
            buffer.append(CerealCoderTreeValueType.nsDate.rawValue)
            var array = toByteArray(interval)
            array.insert(contentsOf: toByteArray(array.count), at: 0)
            buffer.append(contentsOf: array)

        default:
            break
        }
    }
}

extension CoderTreeValue {
    func toData() -> Data {
        let bytes = self.bytes()

        return Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
    }
    func bytes() -> [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(20)

        var stringMap = Dictionary<String, [UInt8]>(minimumCapacity: self.numberOfStringEntries)

        self.writeToBuffer(&result, stringMap: &stringMap)
        return result
    }
}

// MARK: decoding extensions

private extension CoderTreeValue {
    static func readInt(_ bytes: inout [UInt8], offset: inout Int) -> Int? {
        guard bytes.count >= offset + MemoryLayout<Int>.size else { return nil }

        let bytesForInt: [UInt8] = Array(bytes[offset..<offset + MemoryLayout<Int>.size])
        let value: Int = bytesToInteger(bytesForInt)

        offset += MemoryLayout<Int>.size

        return value
    }

    static func readArray(_ bytes: inout [UInt8], offset: inout Int, capacity: Int, endOffset: Int) -> [CoderTreeValue]? {
        var array = [CoderTreeValue]()
        array.reserveCapacity(capacity)
        while offset < endOffset {
            guard let value = CoderTreeValue(bytes: &bytes, offset: &offset) else { return nil }
            array.append(value)
        }

        return array
    }

    init?(bytes: inout [UInt8], offset: inout Int) {
        guard bytes.count > offset + 1 else { return nil }
        guard let type = CerealCoderTreeValueType(rawValue: bytes[offset]) else { return nil }

        offset += 1

        if type == .pair {
            guard let key = CoderTreeValue(bytes: &bytes, offset: &offset),
                let value = CoderTreeValue(bytes: &bytes, offset: &offset) else { return nil }
            self = .pair(key, value)

            return
        }

        var identifier: CoderTreeValue? = nil
        if type == .identifyingTree {
            identifier = CoderTreeValue(bytes: &bytes, offset: &offset)
        }

        guard let count = CoderTreeValue.readInt(&bytes, offset: &offset) else { return nil }

        guard bytes.count >= offset + count else { return nil }

        let capacity: Int

        if [CerealCoderTreeValueType.array, CerealCoderTreeValueType.subTree, CerealCoderTreeValueType.identifyingTree].contains(type) {
            guard let capacityValue = CoderTreeValue.readInt(&bytes, offset: &offset) else { return nil }
            capacity = capacityValue
        } else {
            capacity = 0
        }

        let startIndex = offset
        let endIndex = offset + count

        guard bytes.count >= endIndex else { return nil }

        switch type {
            case .string, .nsurl:
                let valueBytes = bytes[startIndex..<endIndex]
                guard let string = String(bytes: valueBytes, encoding: String.Encoding.utf8) else { return nil }

                if type == .string {
                    self = .string(string)
                } else {
                    guard let url = URL(string: string) else { return nil }
                    self = .url(url)
                }

            case .int:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = fromByteArray(valueBytes, Int.self)
                self = .int(value)

            case .int64:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = fromByteArray(valueBytes, Int64.self)
                self = .int64(value)

            case .bool:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = valueBytes[0]
                self = .bool(value == 1)

            case .float:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = fromByteArray(valueBytes, Float.self)
                self = .float(value)

            case .double, .nsDate:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = fromByteArray(valueBytes, Double.self)
                if type == .double {
                    self = .double(value)
                } else {
                    let date = Date(timeIntervalSinceReferenceDate: value)
                    self = .date(date)
                }

            case .array, .subTree:
                guard let array = CoderTreeValue.readArray(&bytes, offset: &offset, capacity: capacity, endOffset: endIndex) else { return nil }

                if type == .array {
                    self = .array(array)
                } else {
                    self = .subTree(array)
                }

            case .identifyingTree:
                guard let id = identifier, case let .string(string) = id else { return nil }
                guard let array = CoderTreeValue.readArray(&bytes, offset: &offset, capacity: capacity, endOffset: endIndex) else { return nil }

                self = .identifyingTree(string, array)
                return


            case .data:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let data = Data(bytes: UnsafePointer<UInt8>(valueBytes), count: valueBytes.count)
                self = .data(data)

            default:
                return nil
        }

        offset = endIndex
    }
}

extension CoderTreeValue {
    init?(bytes: [UInt8]) {
        var bytes = bytes
        var offset = 0
        self.init(bytes: &bytes, offset: &offset)
    }
    init?(data: Data) {
        let bytes = [UInt8](data)
        guard let result = CoderTreeValue(bytes: bytes) else {
            return nil
        }

        self = result
    }
}
