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
    case Int
    case Int64
    case Double
    case Float
    case Bool
    case NSDate
    case NSURL

    case Pair
    case Array
    case SubTree
    case IdentifyingTree
}

protocol CerealByteConvertible {
    init?(bytes: [UInt8], startOffset: Int)
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

    return toByteArray(array.count) + toByteArray(result.count) + result
}

// MARK: extensions

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
                key.writeToBuffer(&buffer, stringMap: &stringMap)
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

extension CoderTreeValue: CerealByteConvertible {
    init?(bytes: [UInt8], startOffset: Int) {
        //TODO: implement
        return nil
    }
    func bytes() -> [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(20)

        var stringMap = Dictionary<String, [UInt8]>(minimumCapacity: self.numberOfStringEntries())

        self.writeToBuffer(&result, stringMap: &stringMap)
        return result
    }
}
