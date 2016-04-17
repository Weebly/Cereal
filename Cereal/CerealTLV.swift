//
//  CerealTLV.swift
//  Cereal
//
//  Created by Сергей Галездинов on 16.04.16.
//

import Foundation

//MARK: Common types

enum CerealEncodeValueType: UInt8 {
    case String = 1
    case Int32
    case Int64
    case Double
    case Float
    case Bool
    case NSDate
    case NSURL
    case CerealContainer
}

public enum CerealTLVContainerType: UInt8 {
    case Value = 1
    case Array
    case Dictionary
    case ArrayOfDictionaries
    case DictionaryOfArrays
}

// MARK: helper functions

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

func bytesCountForUInt32() -> Int {
    return sizeof(UInt32)
}

func bytesCountForUInt64() -> Int {
    return sizeof(UInt64)
}

func countValue<T>(from: [UInt8]) -> T {
    return from.withUnsafeBufferPointer({
        UnsafePointer<T>($0.baseAddress).memory
    })
}

//MARK: CerealByteConvertible
public protocol CerealByteConvertible {
    init?(bytes: [UInt8], startOffset: Int)
    func rawBytes() -> [UInt8]
    func bytesNeeded() -> Int
}

// MARK: - CerealTLVValueRecord
public struct CerealTLVValueRecord {
    let type: CerealEncodeValueType
    private let count: UInt32
    let bytes: [UInt8]

    init() {
        type = .Int32
        count = 0
        bytes = []
    }
}

// MARK: init helper methods

extension CerealTLVValueRecord {
    init(string: String) {
        type = .String
        bytes = Array(string.utf8)
        count = UInt32(bytes.count)
    }
    init(int32: Int32) {
        type = .Int32
        bytes = toByteArray(int32)
        count = UInt32(bytes.count)
    }
    init(int64: Int64) {
        type = .Int64
        bytes = toByteArray(int64)
        count = UInt32(bytes.count)
    }
    init(int: Int) {
        if sizeof(Int32.self) == sizeof(Int.self) {
            type = .Int32
        } else {
            type = .Int64
        }
        bytes = toByteArray(int)
        count = UInt32(bytes.count)
    }
    init(double: Double) {
        type = .Double
        bytes = toByteArray(double)
        count = UInt32(bytes.count)
    }
    init(float: Float) {
        type = .Float
        bytes = toByteArray(float)
        count = UInt32(bytes.count)
    }
    init(bool: Bool) {
        type = .Bool
        bytes = toByteArray(bool)
        count = UInt32(bytes.count)
    }
    init(date: NSDate) {
        let interval = date.timeIntervalSinceReferenceDate
        type = .NSDate
        bytes = toByteArray(interval)
        count = UInt32(bytes.count)
    }
    init(url: NSURL) {
        type = .NSURL
        bytes = Array(url.absoluteString.utf8)
        count = UInt32(bytes.count)
    }
    init(container: CerealTLVContainer) {
        let rawBytes = container.rawBytes()

        type  = .CerealContainer
        bytes = rawBytes
        count = UInt32(rawBytes.count)
    }
}

// MARK: bytes conversions

extension CerealTLVValueRecord: CerealByteConvertible {
    public init?(bytes: [UInt8], startOffset: Int = 0) {
        let offset = startOffset
        guard bytes.count > offset + bytesCountForUInt32() + 1 else { return nil }
        guard let valueType = CerealEncodeValueType(rawValue: bytes[offset]) else { return nil }

        let bytesForCount: [UInt8] = Array(bytes[offset + 1...offset + bytesCountForUInt32()])
        let valueByteCount: UInt32 = countValue(bytesForCount)

        guard bytes.count >= offset + 1 + bytesCountForUInt32() + Int(valueByteCount) else { return nil }

        type = valueType
        count = valueByteCount

        let startIndex = offset + 1 + bytesCountForUInt32()
        let endIndex = startIndex + Int(valueByteCount)
        self.bytes = Array(bytes[startIndex..<endIndex])
    }

    public func rawBytes() -> [UInt8] {
        return [type.rawValue] + toByteArray(count) + bytes
    }

    public func bytesNeeded() -> Int {
        return 1 + bytesCountForUInt32() + bytes.count
    }
}

// MARK: value getters

extension CerealTLVValueRecord {
    var string: String? {
        guard self.type == .String else { return nil }

        return String(bytes: self.bytes, encoding: NSUTF8StringEncoding)
    }

    var int32: Int32? {
        guard self.type == .Int32 else { return nil }

        return fromByteArray(self.bytes, Int32.self)
    }

    var int64: Int64? {
        guard self.type == .Int64 else { return nil }

        return fromByteArray(self.bytes, Int64.self)
    }

    var int: Int? {
        guard self.type == .Int32 || self.type == .Int64 else { return nil }

        return fromByteArray(self.bytes, Int.self)
    }

    var double: Double? {
        guard self.type == .Double else { return nil }

        return fromByteArray(self.bytes, Double.self)
    }

    var float: Float? {
        guard self.type == .Float else { return nil }

        return fromByteArray(self.bytes, Float.self)
    }

    var bool: Bool? {
        guard self.type == .Bool else { return nil }

        return fromByteArray(self.bytes, Bool.self)
    }

    var date: NSDate? {
        guard self.type == .NSDate else { return nil }

        let interval = fromByteArray(self.bytes, NSTimeInterval.self)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }

    var url: NSURL? {
        guard self.type == .NSURL else { return nil }

        let absoluteURL = String(bytes: self.bytes, encoding: NSUTF8StringEncoding) ?? ""
        return NSURL(string: absoluteURL)
    }

    var container: CerealTLVContainer? {
        guard self.type == .CerealContainer else { return nil }

        return CerealTLVContainer(bytes: self.bytes)
    }
}

//MARK: Generic Containers

public protocol CerealContainerTypeRequestable {
    static func containerType() -> CerealTLVContainerType
}

public struct CerealTLVArray<T, C where T: CerealByteConvertible, C: CerealContainerTypeRequestable> {
    private let numberOfRecords: UInt32
    private let sizeInBytes: UInt64
    let records: [T]

    init(records: [T]) {
        self.records = records

        numberOfRecords = UInt32(records.count)
        sizeInBytes = records.reduce(0) { $0.0 + UInt64($0.1.bytesNeeded()) }
    }
}

extension CerealTLVArray: CerealByteConvertible {
    public init?(bytes: [UInt8], startOffset: Int = 0) {
        var bytesOffset = startOffset
        guard bytes.count > startOffset + 1 else { return nil }
        guard let containerType = CerealTLVContainerType(rawValue: bytes[startOffset]) where containerType == C.containerType() else { return nil }

        guard bytes.count > startOffset + 1 + bytesCountForUInt32() else { return nil }

        bytesOffset += bytesCountForUInt32()
        let bytesForNumberOfRecords: [UInt8] = Array(bytes[startOffset + 1...bytesOffset])
        let numberOfRecordsValue: UInt32 = countValue(bytesForNumberOfRecords)

        bytesOffset += 1

        let bytesCountForSizeInBytes = sizeof(UInt64)
        guard bytes.count > bytesOffset + bytesCountForSizeInBytes else { return nil }

        let bytesForSizeInBytes: [UInt8] = Array(bytes[bytesOffset ..< bytesOffset + bytesCountForSizeInBytes])
        let sizeInBytesValue: UInt64 = countValue(bytesForSizeInBytes)

        bytesOffset += bytesCountForSizeInBytes

        guard UInt64(bytes.count - bytesOffset) >= sizeInBytesValue else { return nil }

        var tlvs = [T]()
        tlvs.reserveCapacity(Int(numberOfRecordsValue))

        let finalOffset = bytesOffset + Int(sizeInBytesValue)
        repeat {
            guard let tlv = T(bytes: bytes, startOffset: bytesOffset) else { return nil }

            bytesOffset += tlv.bytesNeeded()
            tlvs.append(tlv)
        } while bytesOffset < finalOffset

        numberOfRecords = numberOfRecordsValue
        sizeInBytes = sizeInBytesValue
        records = tlvs
    }

    public func rawBytes() -> [UInt8] {
        return [C.containerType().rawValue] + toByteArray(numberOfRecords) + toByteArray(sizeInBytes) + records.flatMap { $0.rawBytes() }
    }

    public func bytesNeeded() -> Int {
        return 1 + bytesCountForUInt32() + bytesCountForUInt64() + records.reduce(0) { $0.0 + $0.1.bytesNeeded() }
    }
}

public struct CerealTLVKeyValue<T, U where T: CerealByteConvertible, U: CerealByteConvertible> {
    private let keySizeInBytes: UInt64
    private let valueSizeInBytes: UInt64
    let key: T
    let value: U

    init(key: T, value: U) {
        self.key = key
        self.value = value
        self.keySizeInBytes = UInt64(key.bytesNeeded())
        self.valueSizeInBytes = UInt64(value.bytesNeeded())
    }
}

extension CerealTLVKeyValue: CerealByteConvertible {
    public init?(bytes: [UInt8], startOffset: Int = 0) {
        var bytesOffset = startOffset

        guard bytes.count > startOffset + bytesCountForUInt64() * 2 else { return nil }

        var startIndex = startOffset
        var endIndex = startIndex + bytesCountForUInt64()
        let bytesForKeySize: [UInt8] = Array(bytes[startIndex...endIndex])
        let keySizeInBytesValue: UInt64 = countValue(bytesForKeySize)

        bytesOffset += bytesCountForUInt64()

        startIndex = bytesOffset
        endIndex = startIndex + bytesCountForUInt64()
        let bytesForValueSize: [UInt8] = Array(bytes[startIndex...endIndex])
        let valueSizeInBytesValue: UInt64 = countValue(bytesForValueSize)

        bytesOffset += bytesCountForUInt64()

        guard bytes.count >= bytesOffset + Int(keySizeInBytesValue + valueSizeInBytesValue) else { return nil }

        guard let keyTLV = T(bytes: bytes, startOffset: bytesOffset) else { return nil }

        bytesOffset += keyTLV.bytesNeeded()

        guard let valueTLV = U(bytes: bytes, startOffset: bytesOffset) else { return nil }

        keySizeInBytes = keySizeInBytesValue
        valueSizeInBytes = valueSizeInBytesValue
        key = keyTLV
        value = valueTLV
    }

    public func rawBytes() -> [UInt8] {
        return toByteArray(self.keySizeInBytes) + toByteArray(self.valueSizeInBytes) + self.key.rawBytes() + self.value.rawBytes()
    }
    public func bytesNeeded() -> Int {
        return bytesCountForUInt64() + bytesCountForUInt64() + self.key.bytesNeeded() + self.value.bytesNeeded()
    }
}

// MARK: Arrays

public struct CerealTLVArrayTypeRequestable: CerealContainerTypeRequestable {
    public static func containerType() -> CerealTLVContainerType {
        return .Array
    }
}

public typealias CerealTLVArrayRecord = CerealTLVArray<CerealTLVValueRecord, CerealTLVArrayTypeRequestable>

// MARK: Dictionaries

public typealias CerealTLVKeyValueRecord = CerealTLVKeyValue<CerealTLVValueRecord, CerealTLVValueRecord>
public struct CerealTLVDictionaryTypeRequestable: CerealContainerTypeRequestable {
    public static func containerType() -> CerealTLVContainerType {
        return .Dictionary
    }
}

public typealias CerealTLVDictionaryRecord = CerealTLVArray<CerealTLVKeyValueRecord, CerealTLVDictionaryTypeRequestable>

// MARK: Array of dictionaries

public struct CerealTLVArrayOfDictionariesTypeRequestable: CerealContainerTypeRequestable {
    public static func containerType() -> CerealTLVContainerType {
        return .ArrayOfDictionaries
    }
}

public typealias CerealTLVArrayOfDictionariesRecord = CerealTLVArray<CerealTLVDictionaryRecord, CerealTLVArrayOfDictionariesTypeRequestable>

// MARK: Dictionary of arrays

public typealias CerealTLVArrayKeyValueRecord = CerealTLVKeyValue<CerealTLVValueRecord, CerealTLVArrayRecord>

public struct CerealTLVDictionaryOfArraysTypeRequestable: CerealContainerTypeRequestable {
    public static func containerType() -> CerealTLVContainerType {
        return .DictionaryOfArrays
    }
}

public typealias CerealTLVDictionaryOfArraysRecord = CerealTLVArray<CerealTLVArrayKeyValueRecord, CerealTLVDictionaryOfArraysTypeRequestable>

// MARK: Variable Value

public enum CerealTLVContainer {
    case Value(CerealTLVValueRecord)
    case Array(CerealTLVArrayRecord)
    case Dictionary(CerealTLVDictionaryRecord)
    case ArrayOfDictionaries(CerealTLVArrayOfDictionariesRecord)
    case DictionaryOfArrays(CerealTLVDictionaryOfArraysRecord)
}

extension CerealTLVContainer: CerealByteConvertible {
    public init?(bytes: [UInt8], startOffset: Int = 0) {
        guard bytes.count > startOffset + 1 else { return nil }

        guard let containerType = CerealTLVContainerType(rawValue: bytes[startOffset]) else { return nil }

        switch containerType {
        case .Value:
            guard let value = CerealTLVValueRecord(bytes: bytes, startOffset: startOffset + 1) else { return nil }
            self = .Value(value)

        case .Array:
            guard let array = CerealTLVArrayRecord(bytes: bytes, startOffset: startOffset + 1) else { return nil }
            self = .Array(array)

        case .Dictionary:
            guard let dictionary = CerealTLVDictionaryRecord(bytes: bytes, startOffset: startOffset + 1) else { return nil }
            self = .Dictionary(dictionary)

        case .ArrayOfDictionaries:
            guard let array = CerealTLVArrayOfDictionariesRecord(bytes: bytes, startOffset: startOffset + 1) else { return nil }
            self = .ArrayOfDictionaries(array)

        case .DictionaryOfArrays:
            guard let dictionary = CerealTLVDictionaryOfArraysRecord(bytes: bytes, startOffset: startOffset + 1) else { return nil }
            self = .DictionaryOfArrays(dictionary)
        }
    }

    public func rawBytes() -> [UInt8] {
        switch self {
            case let .Value(value):
                return [CerealTLVContainerType.Value.rawValue] + value.bytes
            case let .Array(array):
                return [CerealTLVContainerType.Array.rawValue] + array.rawBytes()
            case let .Dictionary(dictionary):
                return [CerealTLVContainerType.Dictionary.rawValue] + dictionary.rawBytes()
            case let .ArrayOfDictionaries(array):
                return [CerealTLVContainerType.ArrayOfDictionaries.rawValue] + array.rawBytes()
            case let .DictionaryOfArrays(dictionary):
                return [CerealTLVContainerType.DictionaryOfArrays.rawValue] + dictionary.rawBytes()
        }
    }

    public func bytesNeeded() -> Int {
        switch self {
            case let Value(value):
                return value.bytesNeeded() + 1
            case let Array(array):
                return array.bytesNeeded() + 1
            case let Dictionary(dictionary):
                return dictionary.bytesNeeded() + 1
            case let ArrayOfDictionaries(array):
                return array.bytesNeeded() + 1
            case let DictionaryOfArrays(dictionary):
                return dictionary.bytesNeeded() + 1
        }
    }
}