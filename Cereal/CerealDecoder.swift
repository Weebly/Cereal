//
//  CerealDecoder.swift
//  Cereal
//
//  Created by James Richard on 8/3/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Foundation

private struct TypeIndexMap {
    let type: Any.Type
    let map: [String: Int]
}
private var indexMaps = [TypeIndexMap]()

/**
    A CerealDecoder handles decoding items that were encoded by a `CerealEncoder`.
*/
public struct CerealDecoder {

    private var items: [CoderTreeValue]
    private let reverseRange: StrideThrough<Int>
    private let indexMap: [String: Int]?

    private func itemForKey(key: String) -> CoderTreeValue? {
        if items.count > 100 { // it appears that on small amount of items, a simmple array enumeration is faster than a dictionary lookup
            if let index = indexMap?[key], case let .PairValue(_, value) = items[index] {
                return value
            }
        }
        for index in reverseRange {
            guard case let .PairValue(keyValue, value) = items[index], case let .StringValue(itemKey) = keyValue else { continue }
            if itemKey == key {
                return value
            }
        }
        return nil
    }
    /**
    Initializes a `CerealDecoder` with the data contained in data.
    
    - parameter    data:   The encoded data to decode from.
    */
    public init(data: NSData) throws {
        let bytes = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(data.bytes), count: data.length))
        guard let tree = CoderTreeValue(bytes: bytes) else { throw CerealError.RootItemNotFound }
        self.init(tree: tree)
    }
    
    private init(tree: CoderTreeValue) {
        switch tree {
        case let .SubTree(array):
            items = array
            let count = array.count - 1
            reverseRange = count.stride(through: 0, by: -1)
        case let .IdentifyingTree(_, array):
            items = array
            let count = array.count - 1
            reverseRange = count.stride(through: 0, by: -1)
        default:
            items = []
            reverseRange = 0.stride(through: 0, by: -1)
            break
        }

        indexMap = nil
    }
    private init(items: [CoderTreeValue], map: [String: Int]) {
        self.items = items
        let count = items.count - 1
        reverseRange = count.stride(through: 0, by: -1)
        indexMap = map
    }

    // MARK: - Decoding

    /**
    Decodes the object contained in key.
    
    This method can decode any of the structs conforming to `CerealRepresentable` or
    any type that conforms to `IdentifyingCerealType`. If the type conforms to
    `IdentifyingCerealType` it must be registered with Cereal before calling
    this method.
    
    - parameter    key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decode<DecodedType: CerealRepresentable>(key: String) throws -> DecodedType? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.instantiate(data) as? DecodedType
    }

    /**
    Decodes the object contained in key.

    This method can decode any type that conforms to `CerealType`.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedType: CerealType>(key: String) throws -> DecodedType? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.instantiateCereal(data) as DecodedType
    }

    /**
    Decodes the object contained in key.

    This method can decode any type that conforms to `IdentifyingCerealType`.
    Use this method if you want to decode an object into a protocol.
    
    You must register the type with Cereal before it can be decoded properly.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeIdentifyingCereal(key: String) throws -> IdentifyingCerealType? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.instantiateIdentifyingCereal(data)
    }

    // MARK: Arrays

    /**
    Decodes homogeneous arrays of type `DecodedType`, where `DecodedType`
    conforms to `CerealRepresentable`.
    
    This method does not support decoding `CerealType` objects, but
    can decode `IndentifyingCerealType` objects. 
    
    If you are decoding a `IdentifyingCerealType` it must be registered 
    before calling this method.
    
    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decode<DecodedType: CerealRepresentable>(key: String) throws -> [DecodedType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseArrayValue(data)
    }

    /**
    Decodes heterogeneous arrays conforming to `CerealRepresentable`.
    
    This method does not support decoding `CerealType` objects, but
    can decode `IdentifyingCerealType` objects.
    
    If you are decoding a `IdentifyingCerealType` it must be registered
    before calling this method.

    - parameter     key     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decode(key: String) throws -> [CerealRepresentable]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseArrayValue(data)
    }

    /**
    Decodes homogenous arrays of type `DecodedType`, where `DecodedType`
    conforms to `CerealType`.
    
    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedType: CerealType>(key: String) throws -> [DecodedType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseCerealArrayValue(data)
    }

    /**
    Decodes heterogeneous arrays conforming to `IdentifyingCerealType`.

    You must register the type with Cereal before it can be decoded properly.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeIdentifyingCerealArray(key: String) throws -> [IdentifyingCerealType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseIdentifyingCerealArrayValue(data)
    }

    // MARK: Arrays of Dictionaries

    /**
    Decodes homogenous arrays containing dictionaries that have a key conforming to `CerealRepresentable`
    and a value conforming to `CerealRepresentable`.
    
    This method does not support decoding `CerealType` objects, but
    can decode `IdentifyingCerealType` objects.

    If you are decoding a `IdentifyingCerealType` it must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decode<DecodedKeyType: protocol<CerealRepresentable, Hashable>, DecodedValueType: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseDictionaryValue(item))
        }

        return decodedItems
    }

    /**
    Decodes homogenous arrays containing dictionaries that have a key conforming to `CerealRepresentable`
    and a value conforming to `CerealType`.

    This method does not support decoding `CerealType` objects for its key, but
    can decode `IdentifyingCerealType` objects.

    If you are decoding a `IdentifyingCerealType` for the key it must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedKeyType: protocol<CerealRepresentable, Hashable>, DecodedValueType: CerealType>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseDictionaryValue(item))
        }

        return decodedItems
    }

    /**
    Decodes homogenous arrays containing dictionaries that have a key conforming to `CerealType`
    and a value conforming to `CerealRepresentable`.

    This method does not support decoding `CerealType` objects for its value, but
    can decode `IdentifyingCerealType` objects.

    If you are decoding a `IdentifyingCerealType` it must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedKeyType: protocol<CerealType, Hashable>, DecodedValueType: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCerealDictionaryValue(item))
        }
        
        return decodedItems
    }

    /**
    Decodes homogenous arrays containing dictionaries that have a key conforming to `CerealType`
    and a value conforming to `CerealType`.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCerealPair<DecodedKeyType: protocol<CerealType, Hashable>, DecodedValueType: CerealType>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCerealPairDictionaryValue(item))
        }
        
        return decodedItems
    }

    /**
    Decodes heterogenous arrays containing dictionaries that have a key conforming to `CerealRepresentable`
    and a value conforming to `IdentifyingCerealType`.

    This method does not support decoding `CerealType` objects for its key, but
    can decode `IdentifyingCerealType` objects.

    If you are decoding a `IdentifyingCerealType` for the key it must be registered
    before calling this method. The `IdentifyingCerealType` must be registered
    for the value before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeIdentifyingCerealArray<DecodedKeyType: protocol<CerealRepresentable, Hashable>>(key: String) throws -> [[DecodedKeyType: IdentifyingCerealType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseIdentifyingCerealDictionaryValue(item))
        }

        return decodedItems
    }

    /**
    Decodes heterogenous arrays containing dictionaries that have a key conforming to `CerealType`
    and a value conforming to `IdentifyingCerealType`.

    The `IdentifyingCerealType` for the value must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCerealToIdentifyingCerealArray<DecodedKeyType: protocol<CerealType, Hashable>>(key: String) throws -> [[DecodedKeyType: IdentifyingCerealType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCerealToIdentifyingCerealDictionaryValue(item))
        }

        return decodedItems
    }

    // MARK: Dictionaries

    /**
    Decodes homogeneous dictoinaries conforming to `CerealRepresentable` for both the key
    and value.

    This method does not support decoding `CerealType` objects, but
    can decode `IdentifyingCerealType` objects.
    
    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decode<DecodedKeyType: protocol<CerealRepresentable, Hashable>, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseDictionaryValue(data)
    }

    /**
    Decodes heterogeneous values conforming to `CerealRepresentable`. 
    They key must be homogeneous.
    
    This method does not support decoding `CerealType` objects, but
    can decode `IdentifyingCerealType` objects.
    
    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decode<DecodedKeyType: protocol<CerealRepresentable, Hashable>>(key: String) throws -> [DecodedKeyType: CerealRepresentable]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseDictionaryValue(data)
    }

    /**
    Decodes homogenous values conforming to `CerealType` and keys conforming to
    `CerealRepresentable`.

    This method does not support decoding `CerealType` objects, but
    can decode `IdentifyingCerealType` objects.
    
    The `IdentifyingCerealType` for the value must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedKeyType: protocol<CerealRepresentable, Hashable>, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseCerealDictionaryValue(data)
    }

    /**
    Decodes homogenous values conforming to `CerealRepresentable` and keys conforming to
    `CerealType`.

    This method does not support decoding `CerealType` for its value objects, but
    can decode `IdentifyingCerealType` objects.

    The `IdentifyingCerealType` for the value must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedKeyType: protocol<CerealType, Hashable>, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseCerealDictionaryValue(data)
    }

    /**
    Decodes homogenous values conforming to `CerealRepresentable` and keys conforming to
    `IdentifyingCerealType`.

    The `IdentifyingCerealType` for the value must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeIdentifyingCerealDictionary<DecodedKeyType: protocol<CerealRepresentable, Hashable>>(key: String) throws -> [DecodedKeyType: IdentifyingCerealType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseIdentifyingCerealDictionaryValue(data)
    }

    /**
    Decodes homogenous keys and values conforming to `CerealType`.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCerealPair<DecodedKeyType: protocol<CerealType, Hashable>, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseCerealPairDictionaryValue(data)
    }

    /**
    Decodes homogenous values conforming to `IdentifyingCerealType` and keys conforming to
    `CerealType`.
    
    The `IdentifyingCerealType` for the value must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCerealToIdentifyingCerealDictionary<DecodedKeyType: protocol<CerealType, Hashable>>(key: String) throws -> [DecodedKeyType: IdentifyingCerealType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseCerealToIdentifyingCerealDictionaryValue(data)
    }

    // MARK: Dictionaries of Arrays

    /**
    Decodes a homogenous dictionary of arrays conforming to `CerealRepresentable`. The key
    must be a `CerealRepresentable`.

    This method does not support decoding `CerealType` objects, but
    can decode `IdentifyingCerealType` objects.

    The `IdentifyingCerealType` for the value must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decode<DecodedKeyType: protocol<CerealRepresentable, Hashable>, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.parseArrayValue(value)
        }

        return decodedItems
    }

    /**
    Decodes a homogenous dictionary of arrays conforming to `CerealType`. The key
    must be a `CerealRepresentable`.

    This method does not support decoding `CerealType` keys, but
    can decode `IdentifyingCerealType` keys.

    The `IdentifyingCerealType` for the key must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedKeyType: protocol<CerealRepresentable, Hashable>, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.parseCerealArrayValue(value)
        }
        
        return decodedItems
    }

    /**
    Decodes a homogenous dictionary of arrays conforming to `CerealRepresentable`. The key
    must be a `CerealType`.

    This method does not support decoding `CerealType` values, but
    can decode `IdentifyingCerealType` values.

    The `IdentifyingCerealType` for the value must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedKeyType: protocol<CerealType, Hashable>, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(key)
            decodedItems[decodedKey] = try CerealDecoder.parseArrayValue(value)
        }
        
        return decodedItems
    }

    /**
    Decodes a homogenous dictionary of arrays conforming to `CerealType`. The key
    must be a `CerealType`.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCerealPair<DecodedKeyType: protocol<CerealType, Hashable>, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(key)
            decodedItems[decodedKey] = try CerealDecoder.parseCerealArrayValue(value)
        }
        
        return decodedItems
    }

    /**
    Decodes a heterogenous dictionary of arrays conforming to `IdentifyingCerealType`. The key
    must be a `CerealRepresentable`.

    This method does not support decoding `CerealType` keys, but
    can decode `IdentifyingCerealType` keys.

    The `IdentifyingCerealType` for the value must be registered
    before calling this method. If using an `IdentifyingCerealType` for the
    key it must also be registered before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeIdentifyingCerealDictionary<DecodedKeyType: protocol<CerealRepresentable, Hashable>>(key: String) throws -> [DecodedKeyType: [IdentifyingCerealType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [IdentifyingCerealType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.parseIdentifyingCerealArrayValue(value)
        }

        return decodedItems
    }

    /**
    Decodes a heterogeneous dictionary of arrays conforming to `IdentifyingCerealType`. The key
    must be a `CerealType`.

    The `IdentifyingCerealType` for the value must be registered
    before calling this method.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCerealToIdentifyingCerealDictionary<DecodedKeyType: protocol<CerealType, Hashable>>(key: String) throws -> [DecodedKeyType: [IdentifyingCerealType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [IdentifyingCerealType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(key)
            decodedItems[decodedKey] = try CerealDecoder.parseIdentifyingCerealArrayValue(value)
        }

        return decodedItems
    }

    // MARK: - Root Decoding

    // These methods are convenience methods that allow users to quickly decode their object.

    // MARK: Basic items

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: ItemType)`.
    
    If you encoded custom objects conforming to `CerealType`, use `CerealDecoder.rootCerealItemWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem(_: ItemType)`.
    - returns:      The instantiated object.
    */
    public static func rootItemWithData<ItemType: CerealRepresentable>(data: NSData) throws -> ItemType {
        let decoder = try CerealDecoder(data: data)
        guard let item: ItemType =  try decoder.decode(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: ItemType)`.
    
    This method will instantiate your custom `CerealType` objects.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: ItemType)`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItemWithData<ItemType: CerealType>(data: NSData) throws -> ItemType {
        let decoder = try CerealDecoder(data: data)
        guard let item: ItemType =  try decoder.decodeCereal(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem(_: IdentifyingCerealType)`.
    
    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem(_: IdentifyingCerealType)`.
    - returns:      The instantiated object.
    */
    public static func rootIdentifyingCerealItemWithData(data: NSData) throws -> IdentifyingCerealType {
        let decoder = try CerealDecoder(data: data)
        guard let item: IdentifyingCerealType = try decoder.decodeIdentifyingCereal(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    // MARK: Arrays

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: [ItemType])`.
    
    If you encoded custom objects conforming to `CerealType`, use `CerealDecoder.rootCerealItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: [ItemType])`.
    - returns:      The instantiated object.
    */
    public static func rootItemsWithData<ItemType: CerealRepresentable>(data: NSData) throws -> [ItemType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemType] = try decoder.decode(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: [ItemType])`.
    
    This method will instantiate your custom `CerealType` objects.

    - param         data:    The data returned by `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: [ItemType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItemsWithData<ItemType: CerealType>(data: NSData) throws -> [ItemType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemType] = try decoder.decodeCereal(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem(_: [IdentifyingCerealType])`.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem(_: [IdentifyingCerealType])`.
    - returns:      The instantiated object.
    */
    public static func rootIdentifyingCerealItemsWithData(data: NSData) throws -> [IdentifyingCerealType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [IdentifyingCerealType] = try decoder.decodeIdentifyingCerealArray(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    // MARK: Arrays of Dictionaries

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    
    If you encoded custom objects conforming to `CerealType`, use `CerealDecoder.rootCerealItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    - returns:      The instantiated object.
    */
    public static func rootItemsWithData<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(data: NSData) throws -> [[ItemKeyType: ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: ItemValueType]] = try decoder.decode(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    
    This method will instantiate your custom `CerealType` objects.
    
    If you encoded custom objects for the ItemKeyType conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItemsWithData<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealType>(data: NSData) throws -> [[ItemKeyType: ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: ItemValueType]] = try decoder.decodeCereal(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.

    This method will instantiate your custom `CerealType` objects.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    - returns:      The instantiated object.
    */

    public static func rootCerealPairItemsWithData<ItemKeyType: protocol<CerealType, Hashable>, ItemValueType: CerealType>(data: NSData) throws -> [[ItemKeyType: ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: ItemValueType]] = try decoder.decodeCerealPair(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(_: [[ItemKeyType: IdentifyingCerealType]])`.

    If you encoded custom objects for the ItemKeyType conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItemsWithData` instead.
    
    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(_: [[ItemKeyType: IdentifyingCerealType]])`.
    - returns:      The instantiated object.
    */

    public static func rootIdentifyingCerealItemsWithData<ItemKeyType: protocol<CerealRepresentable, Hashable>>(data: NSData) throws -> [[ItemKeyType: IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: IdentifyingCerealType]] = try decoder.decodeIdentifyingCerealArray(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(_: [[ItemKeyType: IdentifyingCerealType]])`.

    If you encoded custom objects for the ItemKeyType conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItemsWithData` instead.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(_: [[ItemKeyType: IdentifyingCerealType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealToIdentifyingCerealItemsWithData<ItemKeyType: protocol<CerealType, Hashable>>(data: NSData) throws -> [[ItemKeyType: IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: IdentifyingCerealType]] = try decoder.decodeCerealToIdentifyingCerealArray(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    // MARK: Dictionaries

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.

    If you encoded custom objects for your values or keys conforming to `CerealType`, use `CerealDecoder.rootCerealItemsWithData` instead.
    
    If you encoded custom objects for your values and keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootItemsWithData<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(data: NSData) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decode(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.

    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItemsWithData<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealType>(data: NSData) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decodeCereal(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.

    If you encoded custom objects for your values conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItemsWithData<ItemKeyType: protocol<CerealType, Hashable>, ItemValueType: CerealRepresentable>(data: NSData) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decodeCereal(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealPairItemsWithData<ItemKeyType: protocol<CerealType, Hashable>, ItemValueType: CerealType>(data: NSData) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decodeCerealPair(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: IdentifyingCerealType])`.
    
    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItemsWithData` instead.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: IdentifyingCerealType])`.
    - returns:      The instantiated object.
    */
    public static func rootIdentifyingCerealItemsWithData<ItemKeyType: protocol<CerealRepresentable, Hashable>>(data: NSData) throws -> [ItemKeyType: IdentifyingCerealType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: IdentifyingCerealType] = try decoder.decodeIdentifyingCerealDictionary(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: IdentifyingCerealType])`.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: IdentifyingCerealType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealToIdentifyingCerealItemsWithData<ItemKeyType: protocol<CerealType, Hashable>>(data: NSData) throws -> [ItemKeyType: IdentifyingCerealType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: IdentifyingCerealType] = try decoder.decodeCerealToIdentifyingCerealDictionary(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    // MARK: Dictionaries of Arrays

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

    If you encoded custom objects for your values or keys conforming to `CerealType`, use `CerealDecoder.rootCerealItemsWithData` instead.

    If you encoded custom objects for your values and keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
    - returns:       The instantiated object.
    */
    public static func rootItemsWithData<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(data: NSData) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decode(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItemsWithData<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealType>(data: NSData) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCereal(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

    If you encoded custom objects for your values conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
    - returns:       The instantiated object.
    */
    public static func rootCerealItemsWithData<ItemKeyType: protocol<CerealType, Hashable>, ItemValueType: CerealRepresentable>(data: NSData) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCereal(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
    - returns:       The instantiated object.
    */
    public static func rootCerealPairItemsWithData<ItemKeyType: protocol<CerealType, Hashable>, ItemValueType: CerealType>(data: NSData) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCerealPair(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: [IdentifyingCerealType]])`.

    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItemsWithData` instead.
    
    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: [IdentifyingCerealType]])`.
    - returns:       The instantiated object.
    */
    public static func rootIdentifyingCerealItemsWithData<ItemKeyType: protocol<CerealRepresentable, Hashable>>(data: NSData) throws -> [ItemKeyType: [IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [IdentifyingCerealType]] = try decoder.decodeIdentifyingCerealDictionary(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: [IdentifyingCerealType]])`.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: [IdentifyingCerealType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealToIdentifyingCerealItemsWithData<ItemKeyType: protocol<CerealType, Hashable>>(data: NSData) throws -> [ItemKeyType: [IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [IdentifyingCerealType]] = try decoder.decodeCerealToIdentifyingCerealDictionary(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    // MARK: - Instantiators
    // Instantiators take a String and type information, either through a CerealTypeIdentifier or a Generic, and instantiate the object
    // being asked for

    /// Used for primitive or identifying cereal values
    private static func instantiate(value: CoderTreeValue) throws -> CerealRepresentable {
        switch value {
            case let .StringValue(val): return val
            case let .IntValue(val):    return val
            case let .Int64Value(val):  return val
            case let .DoubleValue(val): return val
            case let .FloatValue(val):  return val
            case let .BoolValue(val):   return val
            case let .NSDateValue(val): return val
            case let .NSURLValue(val):  return val

            case .PairValue, .ArrayValue, .SubTree:
                throw CerealError.InvalidEncoding(".Array / .Cereal / .Dictionary not expected")

            case .IdentifyingTree:
                return try instantiateIdentifyingCereal(value)
        }
    }
    private static func instantiate<T: CerealRepresentable>(value: CoderTreeValue) throws -> T {
        guard let decodedResult: T = try CerealDecoder.instantiate(value) as? T else {
            throw CerealError.InvalidEncoding("Failed to decode value \(value)")
        }

        return decodedResult
    }

    /// Helper method to improve decoding speed for large objects:
    /// method returns index map to read value for key without enumerating through all the items
    private static func propertiesIndexMapForType(type: Any.Type, value: CoderTreeValue) -> [String: Int] {
        for mapInfo in indexMaps {
            if mapInfo.type == type {
                return mapInfo.map
            }
        }

        func buildIndexMap(items: [CoderTreeValue]) -> [String: Int] {
            // assuming the array of decoded values always contains constant number of entries
            var indexMap = [String: Int]()
            for (index,item) in items.enumerate() {
                guard case let .PairValue(keyValue, _) = item, case let .StringValue(itemKey) = keyValue else { continue }
                indexMap[itemKey] = index
            }

            return indexMap
        }

        switch value {
        case let .IdentifyingTree(_, items):
            let map = buildIndexMap(items)
            indexMaps.append(TypeIndexMap(type: type, map: map))
            return map

        case let .SubTree(items):
            let map = buildIndexMap(items)
            indexMaps.append(TypeIndexMap(type: type, map: map))
            return map
        default:
            return [:]
        }
    }

    /// Used for CerealType where we have type data from the compiler
    private static func instantiateCereal<DecodedType: CerealType>(value: CoderTreeValue) throws -> DecodedType {
        let map = CerealDecoder.propertiesIndexMapForType(DecodedType.self, value: value)

        let cereal: CerealDecoder
        switch value {
        case let .IdentifyingTree(_, items):
            cereal = CerealDecoder(items: items, map: map)
        case let .SubTree(items):
            cereal = CerealDecoder(items: items, map: map)
        default:
            throw CerealError.InvalidEncoding("Invalid type found: \(value)")
        }

        return try DecodedType.init(decoder: cereal)
    }

    private static func instantiateIdentifyingCereal(value: CoderTreeValue) throws -> IdentifyingCerealType {
        guard case let .IdentifyingTree(identifier, items) = value else {
            throw CerealError.RootItemNotFound
        }

        let type = try identifyingCerealTypeWithIdentifier(identifier)

        let map = CerealDecoder.propertiesIndexMapForType(type.self, value: value)

        let cereal = CerealDecoder(items: items, map: map)
        return try type.init(decoder: cereal)
    }

    // MARK: - Parsers
    // Parsers are to DRY up some of the decoding code. For example, [CerealType] and [CerealRepresentable: [CerealType]] can reuse a parser for decoding
    // the array of CerealType.

    private static func parseArrayValue(value: CoderTreeValue) throws -> [CerealRepresentable] {
        guard case let .ArrayValue(items) = value else { throw CerealError.RootItemNotFound }

        var decodedItems = [CerealRepresentable]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.instantiate(item))
        }

        return decodedItems
    }

    private static func parseArrayValue<DecodedType: CerealRepresentable>(value: CoderTreeValue) throws -> [DecodedType] {
        guard case let .ArrayValue(items) = value else { throw CerealError.RootItemNotFound }

        var decodedItems = [DecodedType]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            let decodedValue: DecodedType = try CerealDecoder.instantiate(item)
            decodedItems.append(decodedValue)
        }

        return decodedItems
    }

    private static func parseCerealArrayValue<DecodedType: CerealType>(value: CoderTreeValue) throws -> [DecodedType] {
        guard case let .ArrayValue(items) = value else { throw CerealError.RootItemNotFound }

        var decodedItems = [DecodedType]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.instantiateCereal(item))
        }

        return decodedItems
    }

    private static func parseIdentifyingCerealArrayValue(value: CoderTreeValue) throws -> [IdentifyingCerealType] {
        guard case let .ArrayValue(items) = value else { throw CerealError.RootItemNotFound }

        var decodedItems = [IdentifyingCerealType]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.instantiateIdentifyingCereal(item))
        }

        return decodedItems
    }

    private static func parseDictionaryValue<DecodedKeyType: protocol<Hashable, CerealRepresentable>>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: CerealRepresentable] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, CerealRepresentable>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.instantiate(value)
        }

        return decodedItems
    }

    private static func parseDictionaryValue<DecodedKeyType: protocol<Hashable, CerealRepresentable>, DecodedValueType: CerealRepresentable>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseCerealDictionaryValue<DecodedKeyType: protocol<Hashable, CerealRepresentable>, DecodedValueType: CerealType>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateCereal(value) as DecodedValueType
        }

        return decodedItems
    }

    private static func parseCerealDictionaryValue<DecodedKeyType: protocol<Hashable, CerealType>, DecodedValueType: CerealRepresentable>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseCerealPairDictionaryValue<DecodedKeyType: protocol<Hashable, CerealType>, DecodedValueType: CerealType>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiateCereal(value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseIdentifyingCerealDictionaryValue<DecodedKeyType: protocol<Hashable, CerealRepresentable>>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: IdentifyingCerealType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, IdentifyingCerealType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value)
        }

        return decodedItems
    }

    private static func parseCerealToIdentifyingCerealDictionaryValue<DecodedKeyType: protocol<Hashable, CerealType>>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: IdentifyingCerealType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, IdentifyingCerealType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value)
        }

        return decodedItems
    }
}

// MARK: - RawRepresentable overrides -

extension CerealDecoder {
    // MARK: - Decoding

    /**
     Decodes the object contained in key.

     This method can decode any of the structs conforming to `CerealRepresentable` or
     any type that conforms to `IdentifyingCerealType`. If the type conforms to
     `IdentifyingCerealType` it must be registered with Cereal before calling
     this method.

     - parameter    key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedType: protocol<RawRepresentable, CerealRepresentable> where DecodedType.RawValue: CerealRepresentable>(key: String) throws -> DecodedType? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        let decodedResult: DecodedType = try CerealDecoder.instantiate(data)
        return decodedResult
    }

    // MARK: Arrays

    /**
     Decodes homogeneous arrays of type `DecodedType`, where `DecodedType`
     conforms to `CerealRepresentable`.

     This method does not support decoding `CerealType` objects, but
     can decode `IndentifyingCerealType` objects.

     If you are decoding a `IdentifyingCerealType` it must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedType: protocol<RawRepresentable, CerealRepresentable> where DecodedType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseArrayValue(data)
    }

    // MARK: Arrays of Dictionaries

    /**
     Decodes homogenous arrays containing dictionaries that have a key conforming to `CerealRepresentable`
     and a value conforming to `CerealRepresentable`.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     If you are decoding a `IdentifyingCerealType` it must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, DecodedValueType: CerealRepresentable where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseDictionaryValue(item))
        }

        return decodedItems
    }

    /**
     Decodes homogenous arrays containing dictionaries that have a key conforming to `CerealRepresentable`
     and a value conforming to `CerealRepresentable`.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     If you are decoding a `IdentifyingCerealType` it must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, DecodedValueType: protocol<RawRepresentable, CerealRepresentable> where DecodedKeyType.RawValue: CerealRepresentable, DecodedValueType.RawValue: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseDictionaryValue(item))
        }

        return decodedItems
    }

    /**
     Decodes homogenous arrays containing dictionaries that have a key conforming to `CerealRepresentable`
     and a value conforming to `CerealType`.

     This method does not support decoding `CerealType` objects for its key, but
     can decode `IdentifyingCerealType` objects.

     If you are decoding a `IdentifyingCerealType` for the key it must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decodeCereal<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, DecodedValueType: CerealType where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCerealDictionaryValue(item))
        }

        return decodedItems
    }

    /**
     Decodes homogenous arrays containing dictionaries that have a key conforming to `CerealType`
     and a value conforming to `CerealRepresentable`.

     This method does not support decoding `CerealType` objects for its value, but
     can decode `IdentifyingCerealType` objects.

     If you are decoding a `IdentifyingCerealType` it must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decodeCereal<DecodedKeyType: protocol<CerealType, Hashable>, DecodedValueType: protocol<RawRepresentable, CerealRepresentable> where DecodedValueType.RawValue: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCerealDictionaryValue(item))
        }

        return decodedItems
    }

    // MARK: Dictionaries

    /**
     Decodes homogeneous dictoinaries conforming to `CerealRepresentable` for both the key
     and value.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, DecodedValueType: CerealRepresentable where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseDictionaryValue(data)
    }
    /**
     Decodes homogeneous dictoinaries conforming to `CerealRepresentable` for both the key
     and value.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, DecodedValueType: protocol<RawRepresentable, CerealRepresentable> where DecodedKeyType.RawValue: CerealRepresentable, DecodedValueType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseDictionaryValue(data)
    }

    /**
     Decodes heterogeneous values conforming to `CerealRepresentable`.
     They key must be homogeneous.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedKeyType: CerealRepresentable]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseDictionaryValue(data)
    }

    /**
     Decodes homogenous values conforming to `CerealType` and keys conforming to
     `CerealRepresentable`.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     The `IdentifyingCerealType` for the value must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decodeCereal<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, DecodedValueType: CerealType where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseCerealDictionaryValue(data)
    }

    /**
     Decodes homogenous values conforming to `CerealRepresentable` and keys conforming to
     `IdentifyingCerealType`.

     The `IdentifyingCerealType` for the value must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decodeIdentifyingCerealDictionary<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedKeyType: IdentifyingCerealType]? {
        guard let data = self.itemForKey(key) else {
            return nil
        }

        return try CerealDecoder.parseIdentifyingCerealDictionaryValue(data)
    }

    // MARK: Dictionaries of Arrays

    /**
     Decodes a homogenous dictionary of arrays conforming to `CerealRepresentable`. The key
     must be a `CerealRepresentable`.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     The `IdentifyingCerealType` for the value must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, DecodedValueType: CerealRepresentable where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.parseArrayValue(value)
        }

        return decodedItems
    }

    /**
     Decodes a homogenous dictionary of arrays conforming to `CerealRepresentable`. The key
     must be a `CerealRepresentable`.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     The `IdentifyingCerealType` for the value must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, DecodedValueType: protocol<RawRepresentable, CerealRepresentable> where DecodedKeyType.RawValue: CerealRepresentable, DecodedValueType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.parseArrayValue(value)
        }

        return decodedItems
    }

    /**
     Decodes a homogenous dictionary of arrays conforming to `CerealType`. The key
     must be a `CerealRepresentable`.

     This method does not support decoding `CerealType` keys, but
     can decode `IdentifyingCerealType` keys.

     The `IdentifyingCerealType` for the key must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decodeCereal<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, DecodedValueType: CerealType where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.parseCerealArrayValue(value)
        }

        return decodedItems
    }

    /**
     Decodes a heterogenous dictionary of arrays conforming to `IdentifyingCerealType`. The key
     must be a `CerealRepresentable`.

     This method does not support decoding `CerealType` keys, but
     can decode `IdentifyingCerealType` keys.

     The `IdentifyingCerealType` for the value must be registered
     before calling this method. If using an `IdentifyingCerealType` for the
     key it must also be registered before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decodeIdentifyingCerealDictionary<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [DecodedKeyType: [IdentifyingCerealType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = Dictionary<DecodedKeyType, [IdentifyingCerealType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.parseIdentifyingCerealArrayValue(value)
        }

        return decodedItems
    }

    // MARK: - Root Decoding

    // These methods are convenience methods that allow users to quickly decode their object.

    // MARK: Arrays of Dictionaries

    /**
     Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

     If you encoded custom objects for your values or keys conforming to `CerealType`, use `CerealDecoder.rootCerealItemsWithData` instead.

     If you encoded custom objects for your values and keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

     - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
     - returns:       The instantiated object.
     */
    public static func rootItemsWithData<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable where ItemKeyType.RawValue: CerealRepresentable>(data: NSData) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decode(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
     Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

     If you encoded custom objects for your values or keys conforming to `CerealType`, use `CerealDecoder.rootCerealItemsWithData` instead.

     If you encoded custom objects for your values and keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

     - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
     - returns:       The instantiated object.
     */
    public static func rootItemsWithData<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: protocol<RawRepresentable, CerealRepresentable> where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable>(data: NSData) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decode(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    /**
     Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

     If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

     - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
     - returns:      The instantiated object.
     */
    public static func rootCerealItemsWithData<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable>, ItemValueType: CerealType where ItemKeyType.RawValue: CerealRepresentable>(data: NSData) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCereal(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    // MARK: Dictionaries of Arrays

    /**
     Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: [IdentifyingCerealType]])`.

     If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItemsWithData` instead.

     The `IdentifyingCerealType` for the returned object must be registered
     before calling this method.

     - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: [IdentifyingCerealType]])`.
     - returns:       The instantiated object.
     */
    public static func rootIdentifyingCerealItemsWithData<ItemKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where ItemKeyType.RawValue: CerealRepresentable>(data: NSData) throws -> [ItemKeyType: [IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [IdentifyingCerealType]] = try decoder.decodeIdentifyingCerealDictionary(rootKey) else { throw CerealError.RootItemNotFound }
        return item
    }

    // MARK: Arrays of Dictionaries

    /**
     Decodes heterogenous arrays containing dictionaries that have a key conforming to `CerealRepresentable`
     and a value conforming to `IdentifyingCerealType`.

     This method does not support decoding `CerealType` objects for its key, but
     can decode `IdentifyingCerealType` objects.

     If you are decoding a `IdentifyingCerealType` for the key it must be registered
     before calling this method. The `IdentifyingCerealType` must be registered
     for the value before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decodeIdentifyingCerealArray<DecodedKeyType: protocol<RawRepresentable, CerealRepresentable, Hashable> where DecodedKeyType.RawValue: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: IdentifyingCerealType]]? {
        guard let data = self.itemForKey(key), case let .ArrayValue(items) = data else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseIdentifyingCerealDictionaryValue(item))
        }

        return decodedItems
    }
}

// MARK: - RawRepresentable private functions overrides -

private extension CerealDecoder {
    // MARK: - Instantiators
    // Instantiators take a String and type information, either through a CerealTypeIdentifier or a Generic, and instantiate the object
    // being asked for

    /// Used for primitive or identifying cereal values

    private static func instantiate<T: RawRepresentable where T: CerealRepresentable, T.RawValue: CerealRepresentable>(value: CoderTreeValue) throws -> T {
        guard let rawValue = try CerealDecoder.instantiate(value) as? T.RawValue, let decodedResult = T(rawValue: rawValue) else {
            throw CerealError.InvalidEncoding("Failed to decode value \(value)")
        }

        return decodedResult
    }

    // MARK: - Parsers
    
    private static func parseArrayValue<DecodedType: RawRepresentable where DecodedType: CerealRepresentable, DecodedType.RawValue: CerealRepresentable>(value: CoderTreeValue) throws -> [DecodedType] {
        guard case let .ArrayValue(items) = value else { throw CerealError.RootItemNotFound }

        var decodedItems = [DecodedType]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            let decodedValue: DecodedType = try CerealDecoder.instantiate(item)
            decodedItems.append(decodedValue)
        }

        return decodedItems
    }

    private static func parseDictionaryValue<DecodedKeyType: protocol<RawRepresentable, Hashable, CerealRepresentable> where DecodedKeyType.RawValue: CerealRepresentable>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: CerealRepresentable] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, CerealRepresentable>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.instantiate(value)
        }

        return decodedItems
    }

    private static func parseDictionaryValue<DecodedKeyType: protocol<RawRepresentable, Hashable, CerealRepresentable>, DecodedValueType: CerealRepresentable where DecodedKeyType.RawValue: CerealRepresentable>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseDictionaryValue<DecodedKeyType: protocol<RawRepresentable, Hashable, CerealRepresentable>, DecodedValueType: protocol<RawRepresentable, CerealRepresentable> where DecodedKeyType.RawValue: CerealRepresentable, DecodedValueType.RawValue: CerealRepresentable>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseCerealDictionaryValue<DecodedKeyType: protocol<RawRepresentable, Hashable, CerealRepresentable>, DecodedValueType: CerealType where DecodedKeyType.RawValue: CerealRepresentable>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateCereal(value) as DecodedValueType
        }

        return decodedItems
    }

    private static func parseCerealDictionaryValue<DecodedKeyType: protocol<Hashable, CerealType>, DecodedValueType: protocol<RawRepresentable, CerealRepresentable> where DecodedValueType.RawValue: CerealRepresentable>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseIdentifyingCerealDictionaryValue<DecodedKeyType: protocol<RawRepresentable, Hashable, CerealRepresentable> where DecodedKeyType.RawValue: CerealRepresentable>(dictionaryValue: CoderTreeValue) throws -> [DecodedKeyType: IdentifyingCerealType] {
        guard case let .ArrayValue(items) = dictionaryValue else { throw CerealError.RootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, IdentifyingCerealType>(minimumCapacity: items.count)

        for item in items {
            guard case let .PairValue(key, value) = item else { throw CerealError.RootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value)
        }

        return decodedItems
    }

}
