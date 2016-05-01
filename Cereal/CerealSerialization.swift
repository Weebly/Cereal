//
//  CerealSerialization.swift
//  Cereal
//
//  Created by Sergey Galezdinov on 27.04.16.
//  Copyright © 2016 Weebly. All rights reserved.
//

import Foundation

// MARK: Types

indirect enum CoderTreeValue {
    case StringValue(String)
    case IntValue(Int)
    case Int64Value(Int64)
    case DoubleValue(Double)
    case FloatValue(Float)
    case BoolValue(Bool)
    case NSDateValue(NSDate)
    case NSURLValue(NSURL)

    case PairValue(CoderTreeValue, CoderTreeValue)
    case ArrayValue([CoderTreeValue])
    case SubTree([CoderTreeValue])
    case IdentifyingTree(String,[CoderTreeValue])
}

enum CerealCoderTreeValueType: UInt8 {
    case String = 1
    case Int = 2
    case Int64 = 3
    case Double = 4
    case Float = 5
    case Bool = 6
    case NSDate = 7
    case NSURL = 8

    case Pair = 9
    case Array = 10
    case SubTree = 11
    case IdentifyingTree = 12
}

protocol CerealByteConvertible {
    init?(bytes: [UInt8])
    func bytes() -> [UInt8]
}

func countCapacityBytes(array: [CoderTreeValue]) -> [UInt8] {
    var stringMap = Dictionary<String, [UInt8]>(minimumCapacity: stringEntriesCount(array))

    return countCapacityBytes(array, stringMap: &stringMap)
}

// MARK: Helpers

private func toByteArray<T>(value: T) -> [UInt8] {
    var unsafeValue = value
    return withUnsafePointer(&unsafeValue) {
        Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>($0), count: sizeof(T)))
    }
}

private func fromByteArray<T>(value: [UInt8], _: T.Type) -> T {
    return value.withUnsafeBufferPointer {
        return UnsafePointer<T>($0.baseAddress).memory
    }
}

private func countValue<T>(from: [UInt8]) -> T {
    return from.withUnsafeBufferPointer({
        UnsafePointer<T>($0.baseAddress).memory
    })
}

private func stringEntriesCount(array: [CoderTreeValue]) -> Int {
    var result = 0
    for item in array {
        result += item.numberOfStringEntries()
    }
    return result
}

private func countCapacityBytes(array: [CoderTreeValue], inout stringMap: [String: [UInt8]]) -> [UInt8] {
    var result = [UInt8]()

    for item in array {
        item.writeToBuffer(&result, stringMap: &stringMap)
    }

    return toByteArray(result.count) + toByteArray(array.count) + result
}

// MARK: encoding extensions

private extension String {
    func writeToBuffer(inout buffer: [UInt8], inout stringMap: [String: [UInt8]]) {
        if let bytes = stringMap[self] {
            buffer.appendContentsOf(bytes)
            return
        }

        var array = Array(self.utf8)
        array.insertContentsOf(toByteArray(array.count), at: 0)
        buffer.appendContentsOf(array)
        stringMap.updateValue(array, forKey: self)
    }
}

private extension CoderTreeValue {
    func numberOfStringEntries() -> Int {
        switch self {
        case .StringValue, .NSURLValue:
            return 1
        case let .ArrayValue(items):
            return stringEntriesCount(items)

        case let .SubTree(items):
            return stringEntriesCount(items)

        case let .IdentifyingTree(_,items):
            return 1 + stringEntriesCount(items)

        default:
            return 0
        }
    }

    func writeToBuffer(inout buffer: [UInt8], inout stringMap: [String: [UInt8]]) {
        switch self {
            case .StringValue, .NSURLValue:
                self.writeStringBytes(&buffer, stringMap: &stringMap)

            case .IntValue, .Int64Value, .BoolValue:
                self.writeIntBytes(&buffer)

            case .DoubleValue, .FloatValue, .NSDateValue:
                self.writeFloatBytes(&buffer)

            case let .PairValue(key, value):
                buffer.append(CerealCoderTreeValueType.Pair.rawValue)
                key.writeToBuffer(&buffer, stringMap: &stringMap)
                value.writeToBuffer(&buffer, stringMap: &stringMap)

            case let .ArrayValue(array):
                buffer.append(CerealCoderTreeValueType.Array.rawValue)
                buffer.appendContentsOf(countCapacityBytes(array, stringMap: &stringMap))

            case let .SubTree(items):
                buffer.append(CerealCoderTreeValueType.SubTree.rawValue)
                buffer.appendContentsOf(countCapacityBytes(items, stringMap: &stringMap))

            case let .IdentifyingTree(key, items):
                buffer.append(CerealCoderTreeValueType.IdentifyingTree.rawValue)
                CoderTreeValue.StringValue(key).writeToBuffer(&buffer, stringMap: &stringMap)
                buffer.appendContentsOf(countCapacityBytes(items, stringMap: &stringMap))
        }
    }

    func writeStringBytes(inout buffer: [UInt8], inout stringMap: [String: [UInt8]]) {
        switch self {
        case let .StringValue(string):
            buffer.append(CerealCoderTreeValueType.String.rawValue)
            string.writeToBuffer(&buffer, stringMap: &stringMap)
        case let .NSURLValue(url):
            buffer.append(CerealCoderTreeValueType.NSURL.rawValue)
            url.absoluteString.writeToBuffer(&buffer, stringMap: &stringMap)

        default:
            break
        }
    }

    func writeIntBytes(inout buffer: [UInt8]) {
        switch self {
        case let .IntValue(int):
            buffer.append(CerealCoderTreeValueType.Int.rawValue)
            buffer.appendContentsOf(toByteArray(int))

        case let .Int64Value(int64):
            buffer.append(CerealCoderTreeValueType.Int64.rawValue)
            buffer.appendContentsOf(toByteArray(int64))

        case let .BoolValue(bool):
            buffer.append(CerealCoderTreeValueType.Bool.rawValue)
            buffer.append(bool ? 1 : 0)

        default:
            break
        }
    }

    func writeFloatBytes(inout buffer: [UInt8]) {
        switch self {
        case let .DoubleValue(double):
            buffer.append(CerealCoderTreeValueType.Double.rawValue)
            buffer.appendContentsOf(toByteArray(double))

        case let .FloatValue(float):
            buffer.append(CerealCoderTreeValueType.Float.rawValue)
            buffer.appendContentsOf(toByteArray(float))

        case let .NSDateValue(date):
            let interval = date.timeIntervalSinceReferenceDate
            buffer.append(CerealCoderTreeValueType.NSDate.rawValue)
            buffer.appendContentsOf(toByteArray(interval))

        default:
            break
        }
    }
}

// MARK: decoding extensions

private extension CoderTreeValue {
    static func readInt(inout bytes: [UInt8], inout offset: Int) -> Int? {
        guard bytes.count > offset + sizeof(Int) else { return nil }

        let bytesForCount: [UInt8] = Array(bytes[offset..<offset + sizeof(Int)])
        let value: Int = countValue(bytesForCount)

        offset += sizeof(Int)

        return value
    }

    static func readArray(inout bytes: [UInt8], inout offset: Int, capacity: Int, endOffset: Int) -> [CoderTreeValue]? {
        var array = [CoderTreeValue]()
        array.reserveCapacity(capacity)
        while offset < endOffset {
            guard let value = CoderTreeValue(bytes: &bytes, offset: &offset) else { return nil }
            array.append(value)
        }

        return array
    }

    init?(inout bytes: [UInt8], inout offset: Int) {
        guard bytes.count > offset + 1 else { return nil }
        guard let type = CerealCoderTreeValueType(rawValue: bytes[offset]) else { return nil }

        offset += 1

        if type == .Pair {
            guard let key = CoderTreeValue(bytes: &bytes, offset: &offset),
                let value = CoderTreeValue(bytes: &bytes, offset: &offset) else { return nil }
            self = .PairValue(key, value)

            return
        }

        var identifier: CoderTreeValue? = nil
        if type == .IdentifyingTree {
            identifier = CoderTreeValue(bytes: &bytes, offset: &offset)
        }

        guard let count = CoderTreeValue.readInt(&bytes, offset: &offset) else { return nil }

        guard bytes.count >= offset + count else { return nil }

        let capacity: Int

        if [CerealCoderTreeValueType.Array, CerealCoderTreeValueType.SubTree, CerealCoderTreeValueType.IdentifyingTree].contains(type) {
            guard let capacityValue = CoderTreeValue.readInt(&bytes, offset: &offset) else { return nil }
            capacity = capacityValue
        } else {
            capacity = 0
        }

        let startIndex = offset
        let endIndex = offset + count

        guard bytes.count >= endIndex else { return nil }

        switch type {
            case .String, .NSURL:
                let valueBytes = Array(bytes[startIndex..<endIndex])

                guard let string = String(bytes: valueBytes, encoding:  NSUTF8StringEncoding) else { return nil }
                if type == .String {
                    self = .StringValue(string)
                } else {
                    guard let url = NSURL(string: string) else { return nil }
                    self = .NSURLValue(url)
                }

            case .Int:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = fromByteArray(valueBytes, Int.self)
                self = .IntValue(value)

            case .Int64:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = fromByteArray(valueBytes, Int64.self)
                self = .Int64Value(value)

            case .Bool:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = valueBytes[0]
                self = .BoolValue(value == 1)

            case .Float:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = fromByteArray(valueBytes, Float.self)
                self = .FloatValue(value)

            case .Double, .NSDate:
                let valueBytes = Array(bytes[startIndex..<endIndex])
                let value = fromByteArray(valueBytes, Double.self)
                if type == .Double {
                    self = .DoubleValue(value)
                } else {
                    let date = NSDate(timeIntervalSinceReferenceDate: value)
                    self = .NSDateValue(date)
                }

            case .Array, .SubTree:
                guard let array = CoderTreeValue.readArray(&bytes, offset: &offset, capacity: capacity, endOffset: endIndex) else { return nil }

                if type == .Array {
                    self = .ArrayValue(array)
                } else {
                    self = .SubTree(array)
                }

            case .IdentifyingTree:
                guard let id = identifier, case let .StringValue(string) = id else { return nil }
                guard let array = CoderTreeValue.readArray(&bytes, offset: &offset, capacity: capacity, endOffset: endIndex) else { return nil }

                self = .IdentifyingTree(string, array)
                return

            default:
                return nil
        }

        offset = endIndex
    }
}

extension CoderTreeValue: CerealByteConvertible {
    init?(bytes: [UInt8]) {
        var bytes = bytes
        var offset = 0
        self.init(bytes: &bytes, offset: &offset)
    }
    func bytes() -> [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(20)

        var stringMap = Dictionary<String, [UInt8]>(minimumCapacity: self.numberOfStringEntries())

        self.writeToBuffer(&result, stringMap: &stringMap)
        return result
    }
}
