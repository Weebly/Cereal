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
            for item in self.values where item.type == type.dynamicType {
                result = item.capacity
                break
            }
        }

        return result
    }

    func save(capacity capacity: Int, forType: Any.Type) {
        self.appendData(TypeCapacity(type: forType.dynamicType, capacity: capacity))
    }
}

private let capacitiesHolder = CapacitiesHolder()

/**
    A CerealEncoder handles encoding items into a format that can be stored in a simple format, such as NSData or String.
*/
public struct CerealEncoder {
    private var items: [CoderTreeValue] = []

    /**
    Initializes a `CerealEncoder` to store encoded data.
    */
    public init(capacity: Int = 20) {
        items.reserveCapacity(capacity)
    }

    /// Returns all of the encoded items as an `NSData` object.
    public func toData() -> NSData {
        return CoderTreeValue.SubTree(items).toData()
    }

    // MARK: - Single items

    /**
    Encodes an object conforming to `CerealRepresentable` under `key`.
    
    - parameter     item:    The object being encoded.
    - parameter     key:     The key the object should be encoded under.
    */
    public mutating func encode<ItemType: CerealRepresentable>(item: ItemType?, forKey key: String) throws {
        guard let unwrapped = item else { return }
        //have to get throwing value first, due to bug in the compiler: https://bugs.swift.org/browse/SR-696
        let value = try encodeItem(unwrapped)
        items.append(.PairValue(.StringValue(key), value))
    }

    /**
    Encodes an object conforming to `IdentifyingCerealType` under `key`.

    - parameter     item:    The object being encoded.
    - parameter     key:     The key the object should be encoded under.
    */
    public mutating func encode(item: IdentifyingCerealType?, forKey key: String) throws {
        guard let unwrapped = item else { return }
        let value = try encodeItem(unwrapped)
        items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: - Arrays

    /**
    Encodes an array of objects conforming to `CerealRepresentable` object under `key`.

    - parameter     items:   The objects being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemType: CerealRepresentable>(items: [ItemType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    /**
    Encodes an array of objects conforming to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The objects being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems(items: [IdentifyingCerealType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeIdentifyingItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: Arrays of Dictionaries

    /**
    Encodes an array of dictionaries where the key and value conform to `CerealRepresentable` object under `key`.

    - parameter     items:   The dictionaries being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [[ItemKeyType: ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    /**
    Encodes an array of dictionaries where the keys conform to `CerealRepresentable` and values conform to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The dictionaries being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [[ItemKeyType: IdentifyingCerealType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: - Dictionaries

    /**
    Encodes a dictionary of keys and values conforming to `CerealRepresentable` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [ItemKeyType: ItemValueType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    /**
    Encodes a dictionary of keys conforming to `CerealRepresentable` and values conforming to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: IdentifyingCerealType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: Dictionaries of Arrays

    /**
    Encodes a dictionary of keys and arrays of values conforming to `CerealRepresentable` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [ItemKeyType: [ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    /**
    Encodes a dictionary of keys conforming to `CerealRepresentable` and arrays of values conforming to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: [IdentifyingCerealType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeIdentifyingItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: - Root encoding

    // These methods are convenience methods that allow users to quickly encode their object into what they will be stored as.

    // MARK: Basic items

    /**
    Encodes an object conforming to `CerealRepresentable` and returns an `NSData` object representing it.

    - parameter     item:    The object being encoded.
    - returns:      The object encoded as an `NSData`
    */
    public static func dataWithRootItem<ItemType: CerealRepresentable>(root: ItemType) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes an object conforming to `IdentifyingCerealType` and returns an `NSData` object representing it.

    - parameter     item:    The object being encoded.
    - returns:      The object encoded as an `NSData`
    */
    public static func dataWithRootItem(root: IdentifyingCerealType) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Arrays

    /**
    Encodes an array of objects conforming to `CerealRepresentable` and returns an `NSData` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `NSData`
    */
    public static func dataWithRootItem<ItemType: CerealRepresentable>(root: [ItemType]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes an array of objects conforming to `IdentifyingCerealType` and returns an `NSData` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `NSData`
    */
    public static func dataWithRootItem(root: [IdentifyingCerealType]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Arrays of Dictionaries

    /**
    Encodes an array of dictionaries of keys and values conforming to `CerealRepresentable` and returns an `NSData` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `NSData`
    */
    public static func dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [[ItemKeyType: ItemValueType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes an array of dictionaries of keys conforming to `CerealRepresentable` and values conforming to `IdentifyingCerealType` and returns an `NSData` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `NSData`
    */
    public static func dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [[ItemKeyType: IdentifyingCerealType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Dictionaries

    /**
    Encodes a dictionary of keys and values conforming to `CerealRepresentable` and returns an `NSData` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `NSData`
    */
    public static func dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes a dictionary of keys conforming to `CerealRepresentable` and values conform to `IdentifyingCerealType` and returns an `NSData` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `NSData`
    */
    public static func dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: IdentifyingCerealType]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Dictionaries of Arrays

    /**
    Encodes a dictionary of keys and array of values conforming to `CerealRepresentable` and returns an `NSData` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `NSData`
    */
    public static func dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
    Encodes a dictionary of keys of keys conforming to `CerealRepresentable` and array values conforming to `IdentifyingCerealType` and returns an `NSData` object representing it.

    - parameter     item:    The objects being encoded.
    - returns:      The objects encoded as an `NSData`
    */
    public static func dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: [IdentifyingCerealType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: - Encoding

    // MARK: Basic

    private func encodeItem<ItemType: CerealRepresentable>(item: ItemType) throws -> CoderTreeValue {
        
        switch item {
            
        case let value as Int :
            return .IntValue(value)
            
        case let value as Int64 :
            return .Int64Value(value)
            
        case let value as String:
            return .StringValue(value)
            
        case let value as Double :
            return .DoubleValue(value)
            
        case let value as Float :
            return .FloatValue(value)
            
        case let value as Bool :
            return .BoolValue(value)
            
        case let value as NSDate :
            return .NSDateValue(value)
        
        case let value as NSURL :
            return .NSURLValue(value)

        case let value as NSData :
            return .NSDataValue(value)

        case let value as IdentifyingCerealType :
            return try encodeItem(value)
            
        case let value as CerealType :
            let capacity = capacitiesHolder.capacity(forType: value.dynamicType)
            var cereal = CerealEncoder(capacity: capacity ?? 20)
            try value.encodeWithCereal(&cereal)

            if capacity == nil {
                capacitiesHolder.save(capacity: cereal.items.count, forType: value.dynamicType)
            }
            return .SubTree(cereal.items)
            
        default: throw CerealError.UnsupportedCerealRepresentable("Item \(item) not supported)")
        }
    }

    private func encodeItem(item: IdentifyingCerealType) throws -> CoderTreeValue {
        let capacity = capacitiesHolder.capacity(forType: item.dynamicType)

        var cereal = CerealEncoder(capacity: capacity ?? 20)
        try item.encodeWithCereal(&cereal)
        let ident = item.dynamicType.initializationIdentifier

        if capacity == nil {
            capacitiesHolder.save(capacity: cereal.items.count, forType: item.dynamicType)
        }
        return .IdentifyingTree(ident, cereal.items)
    }

    // MARK: Arrays of Dictionaries

    private func encodeItems<ItemType: CerealRepresentable>(items: [ItemType]) throws -> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItem(obj)
            encodedArrayItems.append(item)
        }

        return .ArrayValue(encodedArrayItems)
    }

    private func encodeIdentifyingItems(items: [IdentifyingCerealType]) throws -> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItem(obj)
            encodedArrayItems.append(item)
        }

        return .ArrayValue(encodedArrayItems)
    }

    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [[ItemKeyType: ItemValueType]]) throws-> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItems(obj)
            encodedArrayItems.append(item)
        }

        return .ArrayValue(encodedArrayItems)
    }

    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [[ItemKeyType: IdentifyingCerealType]]) throws-> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItems(obj)
            encodedArrayItems.append(item)
        }

        return .ArrayValue(encodedArrayItems)
    }

    // MARK: Dictionaries

    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [ItemKeyType: ItemValueType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: IdentifyingCerealType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    private func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: IdentifyingCerealType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    // MARK: Dictionaries of Arrays

    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [ItemKeyType: [ItemValueType]]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItems(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    private func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: [IdentifyingCerealType]]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeIdentifyingItems(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
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
    public mutating func encode<ItemType: protocol<RawRepresentable, CerealRepresentable> where ItemType.RawValue: CerealRepresentable>(item: ItemType?, forKey key: String) throws {
        guard let unwrapped = item else { return }
        let value = try encodeItem(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: - Arrays

    /**
     Encodes an array of objects conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The objects being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemType: protocol<RawRepresentable, CerealRepresentable> where ItemType.RawValue: CerealRepresentable>(items: [ItemType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: Arrays of Dictionaries

    /**
     Encodes an array of dictionaries where the key and value conform to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionaries being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(items: [[ItemKeyType: ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    /**
     Encodes an array of dictionaries where the key and value conform to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionaries being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(items: [[ItemKeyType: ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    /**
     Encodes an array of dictionaries where the keys conform to `CerealRepresentable` and values conform to `IdentifyingCerealType` object under `key`.

     - parameter     items:   The dictionaries being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encodeIdentifyingItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(items: [[ItemKeyType: IdentifyingCerealType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: - Dictionaries

    /**
     Encodes a dictionary of keys and values conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(items: [ItemKeyType: ItemValueType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    /**
     Encodes a dictionary of keys and values conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(items: [ItemKeyType: ItemValueType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    /**
     Encodes a dictionary of keys conforming to `CerealRepresentable` and values conforming to `IdentifyingCerealType` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encodeIdentifyingItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(items: [ItemKeyType: IdentifyingCerealType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeIdentifyingItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: Dictionaries of Arrays

    /**
     Encodes a dictionary of keys and arrays of values conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(items: [ItemKeyType: [ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }
    /**
     Encodes a dictionary of keys and arrays of values conforming to `CerealRepresentable` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key:     The key the objects should be encoded under.
     */
    public mutating func encode<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(items: [ItemKeyType: [ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    /**
     Encodes a dictionary of keys conforming to `CerealRepresentable` and arrays of values conforming to `IdentifyingCerealType` object under `key`.

     - parameter     items:   The dictionary being encoded.
     - parameter     key     The key the objects should be encoded under.
     */
    public mutating func encodeIdentifyingItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(items: [ItemKeyType: [IdentifyingCerealType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        let value = try encodeIdentifyingItems(unwrapped)
        self.items.append(.PairValue(.StringValue(key), value))
    }

    // MARK: - Root encoding

    // These methods are convenience methods that allow users to quickly encode their object into what they will be stored as.

    // MARK: Basic items

    /**
     Encodes an object conforming to `CerealRepresentable` and returns an `NSData` object representing it.

     - parameter     item:    The object being encoded.
     - returns:      The object encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemType: protocol<RawRepresentable, CerealRepresentable> where ItemType.RawValue: CerealRepresentable>(root: ItemType) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Arrays

    /**
     Encodes an array of objects conforming to `CerealRepresentable` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemType: protocol<RawRepresentable, CerealRepresentable> where ItemType.RawValue: CerealRepresentable>(root: [ItemType]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Arrays of Dictionaries
    
    /**
     Encodes an array of dictionaries of keys and values conforming to `CerealRepresentable` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(root: [[ItemKeyType: ItemValueType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
     Encodes an array of dictionaries of keys and values conforming to `CerealRepresentable` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(root: [[ItemKeyType: ItemValueType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }
    
    /**
     Encodes an array of dictionaries of keys conforming to `CerealRepresentable` and values conforming to `IdentifyingCerealType` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(root: [[ItemKeyType: IdentifyingCerealType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Dictionaries

    /**
     Encodes a dictionary of keys and values conforming to `CerealRepresentable` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(root: [ItemKeyType: ItemValueType]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }
    /**
     Encodes a dictionary of keys and values conforming to `CerealRepresentable` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(root: [ItemKeyType: ItemValueType]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
     Encodes a dictionary of keys conforming to `CerealRepresentable` and values conform to `IdentifyingCerealType` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(root: [ItemKeyType: IdentifyingCerealType]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: Dictionaries of Arrays

    /**
     Encodes a dictionary of keys and array of values conforming to `CerealRepresentable` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
     Encodes a dictionary of keys and array of values conforming to `CerealRepresentable` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encode(root, forKey: rootKey)
        return encoder.toData()
    }

    /**
     Encodes a dictionary of keys of keys conforming to `CerealRepresentable` and array values conforming to `IdentifyingCerealType` and returns an `NSData` object representing it.

     - parameter     item:    The objects being encoded.
     - returns:      The objects encoded as an `NSData`
     */
    public static func dataWithRootItem<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(root: [ItemKeyType: [IdentifyingCerealType]]) throws -> NSData {
        var encoder = CerealEncoder()
        try encoder.encodeIdentifyingItems(root, forKey: rootKey)
        return encoder.toData()
    }

    // MARK: - Encoding

    // MARK: Basic

    private func encodeItem<ItemType: RawRepresentable where ItemType: CerealRepresentable, ItemType.RawValue: CerealRepresentable>(item: ItemType) throws -> CoderTreeValue {
        return try encodeItem(item.rawValue)
    }

    // MARK: Arrays of Dictionaries

    private func encodeItems<ItemType: RawRepresentable where ItemType: CerealRepresentable, ItemType.RawValue: CerealRepresentable>(items: [ItemType]) throws -> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItem(obj)
            encodedArrayItems.append(item)
        }

        return .ArrayValue(encodedArrayItems)
    }
}

// MARK: - RawRepresentable private functions overrides -

private extension CerealEncoder {

    // MARK: Arrays of Dictionaries

    private func encodeItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(items: [[ItemKeyType: ItemValueType]]) throws-> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItems(obj)
            encodedArrayItems.append(item)
        }

        return .ArrayValue(encodedArrayItems)
    }

    private func encodeItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(items: [[ItemKeyType: ItemValueType]]) throws-> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            encodedArrayItems.append(try encodeItems(obj))
        }

        return .ArrayValue(encodedArrayItems)
    }

    private func encodeItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(items: [[ItemKeyType: IdentifyingCerealType]]) throws-> CoderTreeValue {
        var encodedArrayItems = [CoderTreeValue]()
        encodedArrayItems.reserveCapacity(items.count)

        for obj in items {
            let item = try encodeItems(obj)
            encodedArrayItems.append(item)
        }

        return .ArrayValue(encodedArrayItems)
    }

    // MARK: Dictionaries

    private func encodeItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(items: [ItemKeyType: ItemValueType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    private func encodeItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(items: [ItemKeyType: ItemValueType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    private func encodeItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(items: [ItemKeyType: IdentifyingCerealType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    private func encodeIdentifyingItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(items: [ItemKeyType: IdentifyingCerealType]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    // MARK: Dictionaries of Arrays

    private func encodeItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(items: [ItemKeyType: [ItemValueType]]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItems(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    private func encodeItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(items: [ItemKeyType: [ItemValueType]]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItems(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }

    private func encodeIdentifyingItems<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(items: [ItemKeyType: [IdentifyingCerealType]]) throws -> CoderTreeValue {
        var encodedDictionaryItems = [CoderTreeValue]()
        encodedDictionaryItems.reserveCapacity(items.count)

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeIdentifyingItems(value)
            encodedDictionaryItems.append(.PairValue(encodedKey, encodedValue))
        }

        return .ArrayValue(encodedDictionaryItems)
    }
}