//
//  CerealEncoder.swift
//  Cereal
//
//  Created by James Richard on 8/3/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Foundation

private struct TypeCapacity {
    let type: Any.Type
    let capacity: Int
}

private class CapacitiesHolder: SyncHolder<TypeCapacity> {
    func capacity(forType type: Any.Type) -> Int? {
        var result: Int? = nil
        self.sync {
            for item in self.values where item.type == type(of: type) {
                result = item.capacity
                break
            }
        }

        return result
    }

    func save(capacity: Int, forType: Any.Type) {
        self.appendData(TypeCapacity(type: type(of: forType), capacity: capacity))
    }
}

private let capacitiesHolder = CapacitiesHolder()

/**
    A CerealEncoder handles encoding items into a format that can be stored in a simple format, such as Data or String.
*/
public struct CerealEncoder {
    fileprivate var items: [CoderTreeValue] = []

    /**
    Initializes a `CerealEncoder` to store encoded data.
    */
    public init(capacity: Int = 20) {
        items.reserveCapacity(capacity)
    }

    /// Returns all of the encoded items as an `Data` object.
    public func toData() -> Data {
        return CoderTreeValue.subTree(items).toData()
    }

    // MARK: - Single items

    /**
    Encodes an object conforming to `CerealRepresentable` under `key`.
    
    - parameter     item:    The object being encoded.
    - parameter     key:     The key the object should be encoded under.
    */
    public mutating func encode<ItemType: CerealRepresentable>(_ item: ItemType?, forKey key: String) throws {
        guard let unwrapped = item else { return }
        //have to get throwing value first, due to bug in the compiler: https://bugs.swift.org/browse/SR-696
        let value = try encodeItem(unwrapped)
        items.append(.pair(.string(key), value))
    }

    /**
    Encodes an object conforming to `IdentifyingCerealType` under `key`.

    - parameter     item:    The object being encoded.
    - parameter     key:     The key the object should be encoded under.
    */
    public mutating func encode(_ item: IdentifyingCerealType?, forKey key: String) throws {
        guard let unwrapped = item else { return }
        let value = try encodeItem(unwrapped)
        items.append(.pair(.string(key), value))
    }

    // MARK: - Arrays

    /**
    Encodes an array of objects conforming to `CerealRepresentable` object under `key`.

    - parameter     items:   The objects being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemType: CerealRepresentable>(_ items: [ItemType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    /**
    Encodes an array of objects conforming to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The objects being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems(_ items: [IdentifyingCerealType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeIdentifyingItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    // MARK: Arrays of Dictionaries

    /**
    Encodes an array of dictionaries where the key and value conform to `CerealRepresentable` object under `key`.

    - parameter     items:   The dictionaries being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [[ItemKeyType: ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    /**
    Encodes an array of dictionaries where the keys conform to `CerealRepresentable` and values conform to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The dictionaries being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems<ItemKeyType: CerealRepresentable & Hashable>(_ items: [[ItemKeyType: IdentifyingCerealType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    // MARK: - Dictionaries

    /**
    Encodes a dictionary of keys and values conforming to `CerealRepresentable` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [ItemKeyType: ItemValueType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    /**
    Encodes a dictionary of keys conforming to `CerealRepresentable` and values conforming to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems<ItemKeyType: CerealRepresentable & Hashable>(_ items: [ItemKeyType: IdentifyingCerealType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    // MARK: Dictionaries of Arrays

    /**
    Encodes a dictionary of keys and arrays of values conforming to `CerealRepresentable` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [ItemKeyType: [ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    /**
    Encodes a dictionary of keys conforming to `CerealRepresentable` and arrays of values conforming to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems<ItemKeyType: CerealRepresentable & Hashable>(_ items: [ItemKeyType: [IdentifyingCerealType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeIdentifyingItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    // MARK: - Root encoding

    // These methods are convenience methods that allow users to quickly encode their object into what they will be stored as.

    // MARK: Basic items

    /**
    Encodes an object conforming to `CerealRepresentable` and returns an `Data` object representing it.

    - parameter     item:    The object being encoded.
    - returns:      The object encoded as an `Data`
    */
    public static func dataWithRootItem<ItemType: CerealRepresentable>(_ root: ItemType) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes an object conforming to `IdentifyingCerealType` and returns an `Data` object representing it.

    - parameter     item:    The object being encoded.
    - returns:      The object encoded as an `Data`
    */
    public static func dataWithRootItem(_ root: IdentifyingCerealType) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Arrays

    /**
    Encodes an array of objects conforming to `CerealRepresentable` and returns an `Data` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `Data`
    */
    public static func dataWithRootItem<ItemType: CerealRepresentable>(_ root: [ItemType]) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes an array of objects conforming to `IdentifyingCerealType` and returns an `Data` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `Data`
    */
    public static func dataWithRootItem(_ root: [IdentifyingCerealType]) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Arrays of Dictionaries

    /**
    Encodes an array of dictionaries of keys and values conforming to `CerealRepresentable` and returns an `Data` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `Data`
    */
    public static func dataWithRootItem<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ root: [[ItemKeyType: ItemValueType]]) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes an array of dictionaries of keys conforming to `CerealRepresentable` and values conforming to `IdentifyingCerealType` and returns an `Data` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `Data`
    */
    public static func dataWithRootItem<ItemKeyType: CerealRepresentable & Hashable>(_ root: [[ItemKeyType: IdentifyingCerealType]]) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Dictionaries

    /**
    Encodes a dictionary of keys and values conforming to `CerealRepresentable` and returns an `Data` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `Data`
    */
    public static func dataWithRootItem<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ root: [ItemKeyType: ItemValueType]) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes a dictionary of keys conforming to `CerealRepresentable` and values conform to `IdentifyingCerealType` and returns an `Data` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `Data`
    */
    public static func dataWithRootItem<ItemKeyType: CerealRepresentable & Hashable>(_ root: [ItemKeyType: IdentifyingCerealType]) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Dictionaries of Arrays

    /**
    Encodes a dictionary of keys and array of values conforming to `CerealRepresentable` and returns an `Data` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `Data`
    */
    public static func dataWithRootItem<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ root: [ItemKeyType: [ItemValueType]]) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes a dictionary of keys of keys conforming to `CerealRepresentable` and array values conforming to `IdentifyingCerealType` and returns an `Data` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `Data`
    */
    public static func dataWithRootItem<ItemKeyType: CerealRepresentable & Hashable>(_ root: [ItemKeyType: [IdentifyingCerealType]]) throws -> Data {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: - Encoding

    // MARK: Basic

    fileprivate func encodeItem<ItemType: CerealRepresentable>(_ item: ItemType) throws -> CoderTreeValue {
        
        switch item {
            
        case let value as Int :
            return .int(value)
            
        case let value as Int64 :
            return .int64(value)
            
        case let value as String:
            return .string(value)
            
        case let value as Double :
            return .double(value)
            
        case let value as Float :
            return .float(value)
            
        case let value as Bool :
            return .bool(value)
            
        case let value as Date :
            return .date(value)
        
        case let value as URL :
            return .url(value)

        case let value as Data :
            return .data(value)

        case let value as IdentifyingCerealType :
            return try encodeItem(value)
            
        case let value as CerealType :
            let capacity = capacitiesHolder.capacity(forType: type(of: value))
            var cereal = CerealEncoder(capacity: capacity ?? 20)
            try value.encodeWithCereal(&cereal)

            if capacity == nil {
                capacitiesHolder.save(capacity: cereal.items.count, forType: type(of: value))
            }
            return .subTree(cereal.items)
            
        default: throw CerealError.unsupportedCerealRepresentable("Item \(item) not supported)")
        }
    }

    fileprivate func encodeItem(_ item: IdentifyingCerealType) throws -> CoderTreeValue {
        let capacity = capacitiesHolder.capacity(forType: type(of: item))

        var cereal = CerealEncoder(capacity: capacity ?? 20)
        try item.encodeWithCereal(&cereal)
        let ident = type(of: item).initializationIdentifier

        if capacity == nil {
            capacitiesHolder.save(capacity: cereal.items.count, forType: type(of: item))
        }
        return .identifyingTree(ident, cereal.items)
    }

    // MARK: Arrays of Dictionaries

    fileprivate func encodeItems<ItemType: CerealRepresentable>(_ items: [ItemType]) throws -> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItem(obj)
            encodedArrayItems.append(item)
        }

        return .array(encodedArrayItems)
    }

    fileprivate func encodeIdentifyingItems(_ items: [IdentifyingCerealType]) throws -> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItem(obj)
            encodedArrayItems.append(item)
        }

        return .array(encodedArrayItems)
    }

    fileprivate func encodeItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [[ItemKeyType: ItemValueType]]) throws-> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItems(obj)
            encodedArrayItems.append(item)
        }

        return .array(encodedArrayItems)
    }

    fileprivate func encodeItems<ItemKeyType: CerealRepresentable & Hashable>(_ items: [[ItemKeyType: IdentifyingCerealType]]) throws-> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItems(obj)
            encodedArrayItems.append(item)
        }

        return .array(encodedArrayItems)
    }

    // MARK: Dictionaries

    fileprivate func encodeItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [ItemKeyType: ItemValueType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    fileprivate func encodeItems<ItemKeyType: CerealRepresentable & Hashable>(_ items: [ItemKeyType: IdentifyingCerealType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    fileprivate func encodeIdentifyingItems<ItemKeyType: CerealRepresentable & Hashable>(_ items: [ItemKeyType: IdentifyingCerealType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    // MARK: Dictionaries of Arrays

    fileprivate func encodeItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [ItemKeyType: [ItemValueType]]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItems(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    fileprivate func encodeIdentifyingItems<ItemKeyType: CerealRepresentable & Hashable>(_ items: [ItemKeyType: [IdentifyingCerealType]]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeIdentifyingItems(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }
}

// MARK: - RawRepresentable overrides -

extension CerealEncoder {

    // MARK: - Single items

    /**
     Encodes an object conforming to `RawRepresentable` and `CerealRepresentable` (enums, OptionSetType etc)
     whose RawValue conforms to `CerealRepresentable` under `key`.

     - parameter     item:    The object being encoded.
     - parameter     key:     The key the object should be encoded under.
     */
    public mutating func encode<ItemType: RawRepresentable & CerealRepresentable>(_ item: ItemType?, forKey key: String) throws where ItemType.RawValue: CerealRepresentable {
        guard let unwrapped = item else { return }
        let value = try encodeItem(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    // MARK: - Arrays

    /**
     Encodes an array of objects conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The objects being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemType: RawRepresentable & CerealRepresentable>(_ items: [ItemType]?, forKey key: String) throws where ItemType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    // MARK: Arrays of Dictionaries

    /**
     Encodes an array of dictionaries where the key and value conform to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionaries being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [[ItemKeyType: ItemValueType]]?, forKey key: String) throws where ItemKeyType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    /**
     Encodes an array of dictionaries where the key and value conform to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionaries being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(_ items: [[ItemKeyType: ItemValueType]]?, forKey key: String) throws where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    /**
     Encodes an array of dictionaries where the keys conform to `CerealRepresentable` and values conform to `IdentifyingCerealType` object under `key`.

     - parameter     items:   The dictionaries being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encodeIdentifyingItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ items: [[ItemKeyType: IdentifyingCerealType]]?, forKey key: String) throws where ItemKeyType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    // MARK: - Dictionaries

    /**
     Encodes a dictionary of keys and values conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [ItemKeyType: ItemValueType]?, forKey key: String) throws where ItemKeyType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    /**
     Encodes a dictionary of keys and values conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(_ items: [ItemKeyType: ItemValueType]?, forKey key: String) throws where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    /**
     Encodes a dictionary of keys conforming to `CerealRepresentable` and values conforming to `IdentifyingCerealType` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encodeIdentifyingItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ items: [ItemKeyType: IdentifyingCerealType]?, forKey key: String) throws where ItemKeyType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeIdentifyingItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    // MARK: Dictionaries of Arrays

    /**
     Encodes a dictionary of keys and arrays of values conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [ItemKeyType: [ItemValueType]]?, forKey key: String) throws where ItemKeyType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }
    /**
     Encodes a dictionary of keys and arrays of values conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(_ items: [ItemKeyType: [ItemValueType]]?, forKey key: String) throws where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    /**
     Encodes a dictionary of keys conforming to `CerealRepresentable` and arrays of values conforming to `IdentifyingCerealType` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key     The key the objects should be encoded under.
     */
    public mutating func encodeIdentifyingItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ items: [ItemKeyType: [IdentifyingCerealType]]?, forKey key: String) throws where ItemKeyType.RawValue: CerealRepresentable {
        guard let unwrapped = items else { return }
        let value = try encodeIdentifyingItems(unwrapped)
        self.items.append(.pair(.string(key), value))
    }

    // MARK: - Root encoding

    // These methods are convenience methods that allow users to quickly encode their object into what they will be stored as.

    // MARK: Basic items

    /**
     Encodes an object conforming to `CerealRepresentable` and returns an `Data` object representing it.

     - parameter     item:    The object being encoded.
     - returns:      The object encoded as an `Data`
     */
    public static func dataWithRootItem<ItemType: RawRepresentable & CerealRepresentable>(_ root: ItemType) throws -> Data where ItemType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Arrays

    /**
     Encodes an array of objects conforming to `CerealRepresentable` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemType: RawRepresentable & CerealRepresentable>(_ root: [ItemType]) throws -> Data where ItemType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Arrays of Dictionaries
    
    /**
     Encodes an array of dictionaries of keys and values conforming to `CerealRepresentable` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ root: [[ItemKeyType: ItemValueType]]) throws -> Data where ItemKeyType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
     Encodes an array of dictionaries of keys and values conforming to `CerealRepresentable` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(_ root: [[ItemKeyType: ItemValueType]]) throws -> Data where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }
    
    /**
     Encodes an array of dictionaries of keys conforming to `CerealRepresentable` and values conforming to `IdentifyingCerealType` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ root: [[ItemKeyType: IdentifyingCerealType]]) throws -> Data where ItemKeyType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Dictionaries

    /**
     Encodes a dictionary of keys and values conforming to `CerealRepresentable` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ root: [ItemKeyType: ItemValueType]) throws -> Data where ItemKeyType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }
    /**
     Encodes a dictionary of keys and values conforming to `CerealRepresentable` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(_ root: [ItemKeyType: ItemValueType]) throws -> Data where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
     Encodes a dictionary of keys conforming to `CerealRepresentable` and values conform to `IdentifyingCerealType` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ root: [ItemKeyType: IdentifyingCerealType]) throws -> Data where ItemKeyType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Dictionaries of Arrays

    /**
     Encodes a dictionary of keys and array of values conforming to `CerealRepresentable` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ root: [ItemKeyType: [ItemValueType]]) throws -> Data where ItemKeyType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
     Encodes a dictionary of keys and array of values conforming to `CerealRepresentable` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(_ root: [ItemKeyType: [ItemValueType]]) throws -> Data where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
     Encodes a dictionary of keys of keys conforming to `CerealRepresentable` and array values conforming to `IdentifyingCerealType` and returns an `Data` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `Data`
     */
    public static func dataWithRootItem<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ root: [ItemKeyType: [IdentifyingCerealType]]) throws -> Data where ItemKeyType.RawValue: CerealRepresentable {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: - Encoding

    // MARK: Basic

    fileprivate func encodeItem<ItemType: RawRepresentable>(_ item: ItemType) throws -> CoderTreeValue where ItemType: CerealRepresentable, ItemType.RawValue: CerealRepresentable {
        return try encodeItem(item.rawValue)
    }

    // MARK: Arrays of Dictionaries

    fileprivate func encodeItems<ItemType: RawRepresentable>(_ items: [ItemType]) throws -> CoderTreeValue where ItemType: CerealRepresentable, ItemType.RawValue: CerealRepresentable {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItem(obj)
            encodedArrayItems.append(item)
        }

        return .array(encodedArrayItems)
    }
}

// MARK: - RawRepresentable private functions overrides -

private extension CerealEncoder {

    // MARK: Arrays of Dictionaries

    func encodeItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [[ItemKeyType: ItemValueType]]) throws-> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItems(obj)
            encodedArrayItems.append(item)
        }

        return .array(encodedArrayItems)
    }

    func encodeItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(_ items: [[ItemKeyType: ItemValueType]]) throws-> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            encodedArrayItems.append(try encodeItems(obj))
        }

        return .array(encodedArrayItems)
    }

    func encodeItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ items: [[ItemKeyType: IdentifyingCerealType]]) throws-> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItems(obj)
            encodedArrayItems.append(item)
        }

        return .array(encodedArrayItems)
    }

    // MARK: Dictionaries

    func encodeItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [ItemKeyType: ItemValueType]) throws -> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    func encodeItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(_ items: [ItemKeyType: ItemValueType]) throws -> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    func encodeItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ items: [ItemKeyType: IdentifyingCerealType]) throws -> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    func encodeIdentifyingItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ items: [ItemKeyType: IdentifyingCerealType]) throws -> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    // MARK: Dictionaries of Arrays

    func encodeItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(_ items: [ItemKeyType: [ItemValueType]]) throws -> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItems(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    func encodeItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(_ items: [ItemKeyType: [ItemValueType]]) throws -> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItems(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }

    func encodeIdentifyingItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(_ items: [ItemKeyType: [IdentifyingCerealType]]) throws -> CoderTreeValue where ItemKeyType.RawValue: CerealRepresentable {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeIdentifyingItems(value)
            encodedDictionaryItems.append(.pair(encodedKey, encodedValue))
        }

        return .array(encodedDictionaryItems)
    }
}
