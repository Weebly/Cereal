//
//  CerealDecoder.swift
//  Cereal
//
//  Created by James Richard on 8/3/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Foundation

/**
    A CerealDecoder handles decoding items that were encoded by a `CerealEncoder`.
*/
public struct CerealDecoder {
    private struct DeferredItem {
        let type: CerealTypeIdentifier
        let value: String
    }

    private var items = [String: DeferredItem]()

    /**
    Initializes a `CerealDecoder` with the data contained in data.
    
    - parameter    data:   The encoded data to decode from.
    */
    public init(data: NSData) throws {
        let encodedString = try CerealDecoder.decodeData(data)
        try self.init(encodedString: encodedString)
    }

    /**
    Initializes a `CerealDecoder` with the data contained in encodedString.
    
    - parameter    encodedString:   The encoded string to decode from.
    */
    public init(encodedString: String) throws {
        items = try CerealDecoder.decodeString(encodedString)
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.instantiate(data.value, ofType: data.type) as? DecodedType
    }

    /**
    Decodes the object contained in key.

    This method can decode any type that conforms to `CerealType`.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedType: CerealType>(key: String) throws -> DecodedType? {
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.instantiateCereal(data.value, ofType: data.type) as DecodedType
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.instantiateIdentifyingCereal(data.value)
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedArrayString(data.value)
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedArrayString(data.value)
    }

    /**
    Decodes homogenous arrays of type `DecodedType`, where `DecodedType`
    conforms to `CerealType`.
    
    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedType: CerealType>(key: String) throws -> [DecodedType]? {
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedCerealArrayString(data.value)
    }

    /**
    Decodes heterogeneous arrays conforming to `IdentifyingCerealType`.

    You must register the type with Cereal before it can be decoded properly.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeIdentifyingCerealArray(key: String) throws -> [IdentifyingCerealType]? {
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedIdentifyingCerealArrayString(data.value)
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { type, value in
            decodedItems.append(try CerealDecoder.parseEncodedDictionaryString(value))
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { type, value in
            decodedItems.append(try CerealDecoder.parseEncodedCerealDictionaryString(value))
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { type, value in
            decodedItems.append(try CerealDecoder.parseEncodedCerealDictionaryString(value))
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { type, value in
            decodedItems.append(try CerealDecoder.parseEncodedCerealPairDictionaryString(value))
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        try data.value.iterateEncodedValuesWithInstantationHandler { type, value in
            decodedItems.append(try CerealDecoder.parseEncodedIdentifyingCerealDictionaryString(value))
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        try data.value.iterateEncodedValuesWithInstantationHandler { type, value in
            decodedItems.append(try CerealDecoder.parseEncodedCerealToIdentifyingCerealDictionaryString(value))
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedDictionaryString(data.value)
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedDictionaryString(data.value)
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedCerealDictionaryString(data.value)
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedCerealDictionaryString(data.value)
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedIdentifyingCerealDictionaryString(data.value)
    }

    /**
    Decodes homogenous keys and values conforming to `CerealType`.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCerealPair<DecodedKeyType: protocol<CerealType, Hashable>, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedCerealPairDictionaryString(data.value)
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
        guard let data = items[key] else {
            return nil
        }

        return try CerealDecoder.parseEncodedCerealToIdentifyingCerealDictionaryString(data.value)
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [DecodedValueType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, _, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.InvalidEncoding("Failed to instantiate keyValue \(keyValue) of type \(keyType)")
            }

            decodedItems[decodedKey] = try CerealDecoder.parseEncodedArrayString(value)
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [DecodedValueType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, _, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.InvalidEncoding("Failed to instantiate keyValue \(keyValue) of type \(keyType)")
            }

            decodedItems[decodedKey] = try CerealDecoder.parseEncodedCerealArrayString(value)
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [DecodedValueType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, _, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(keyValue, ofType: keyType)
            decodedItems[decodedKey] = try CerealDecoder.parseEncodedArrayString(value)
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [DecodedValueType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, _, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(keyValue, ofType: keyType)
            decodedItems[decodedKey] = try CerealDecoder.parseEncodedCerealArrayString(value)
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [IdentifyingCerealType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, _, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.InvalidEncoding("Failed to instantiate keyValue \(keyValue) of type \(keyType)")
            }

            decodedItems[decodedKey] = try CerealDecoder.parseEncodedIdentifyingCerealArrayString(value)
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
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [IdentifyingCerealType]]()

        try data.value.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, _, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(keyValue, ofType: keyType)
            decodedItems[decodedKey] = try CerealDecoder.parseEncodedIdentifyingCerealArrayString(value)
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

    // MARK: Initial Decoding
    private static func decodeData(data: NSData) throws -> String {
        guard let string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String else {
            throw CerealError.InvalidEncoding("Failed to instantiate string")
        }

        return string
    }

    private static func decodeString(encodedString: String) throws -> [String: DeferredItem] {
        var deferredItems = [String: DeferredItem]()
        var scanIndex = encodedString.startIndex

        while scanIndex != encodedString.endIndex {
            if encodedString.substringWithRange(scanIndex ..< scanIndex.advancedBy(2)) != "k," {
                throw CerealError.InvalidEncoding("Failed to get sub string")
            }

            scanIndex = scanIndex.advancedBy(2)

            guard let keyLengthEndIndex = encodedString.firstOccuranceOfString(":", fromIndex: scanIndex) else {
                throw CerealError.InvalidEncoding("Failed to get key length")
            }

            guard let keyLength = Int(encodedString[scanIndex ..< keyLengthEndIndex]) else {
                throw CerealError.UnsupportedKeyLengthValue
            }

            scanIndex = keyLengthEndIndex.advancedBy(1) // Move past key length and the following :

            // scanIndex now points to the first character of the key

            let keyEndIndex = scanIndex.advancedBy(keyLength)
            let key = encodedString[scanIndex ..< keyEndIndex]

            scanIndex = keyEndIndex.advancedBy(1) // Move past the : after the key

            let cerealType: CerealTypeIdentifier
            (cerealType, scanIndex) = try CerealDecoder.extractCerealTypeFromEncodedString(encodedString, startingAtIndex: scanIndex)

            let value: String
            (value, scanIndex) = try extractValueFromEncodedString(encodedString, startingAtIndex: scanIndex)

            deferredItems[key] = DeferredItem(type: cerealType, value: value)
        }

        return deferredItems
    }

    // MARK: - Instantiators
    // Instantiators take a String and type information, either through a CerealTypeIdentifier or a Generic, and instantiate the object
    // being asked for

    /// Used for primitive or identifying cereal values
    private static func instantiate(value: String, ofType type: CerealTypeIdentifier) throws -> CerealRepresentable {
        switch type {
        case .IdentifyingCereal:
            return try instantiateIdentifyingCereal(value)
        case .Array, .Cereal, .Dictionary:
            throw CerealError.InvalidEncoding(".Array / .Cereal / .Dictionary not expected")
        case .String:
            return value
        case .Int:
            guard let convertedValue = Int(value) else {
                throw CerealError.InvalidEncoding("Failed to create Int with value \(value)")
            }

            return convertedValue
        case .Int64:
            guard let convertedValue = Int64(value) else {
                throw CerealError.InvalidEncoding("Failed to create Int64 with value \(value)")
            }

            return convertedValue
        case .Double:
            guard let convertedValue = Double(value) else {
                throw CerealError.InvalidEncoding("Failed to create Double with value \(value)")
            }

            return convertedValue
        case .Float:
            guard let convertedValue = Float(value) else {
                throw CerealError.InvalidEncoding("Failed to create Float with value \(value)")
            }

            return convertedValue
        case .Bool:
            guard let convertedValue = Bool(value) else {
                throw CerealError.InvalidEncoding("Failed to create Bool with value \(value)")
            }
            return convertedValue
        case .Date:
            guard let convertedValue = NSTimeInterval(value) else {
                throw CerealError.InvalidEncoding("Failed to create NSTimeInterval with value \(value)")
            }
            return NSDate(timeIntervalSince1970: convertedValue)
        case .PreciseDate:
            guard let convertedValue = NSTimeInterval(value) else {
                throw CerealError.InvalidEncoding("Failed to create NSTimeInterval with value \(value)")
            }
            return NSDate(timeIntervalSinceReferenceDate: convertedValue)
        case .URL:
            guard let url = NSURL(string: value) else {
                throw CerealError.InvalidEncoding("Failed to create NSURL with value \(value)")
            }
            
            return url
        }
    }

    /// Used for CerealType where we have type data from the compiler
    private static func instantiateCereal<DecodedType: CerealType>(value: String, ofType type: CerealTypeIdentifier) throws -> DecodedType {
        let cereal: CerealDecoder
        switch type {
        case .IdentifyingCereal:
            // Skip the identifying data as we have the type in this case from the generic
            let (_, index) = try extractValueFromEncodedString(value, startingAtIndex: value.startIndex)
            cereal = try CerealDecoder(encodedString: value[index ..< value.endIndex])
        case .Cereal:
            cereal = try CerealDecoder(encodedString: value)
        default:
            throw CerealError.InvalidEncoding("Invalid type found: \(type)")
        }

        return try DecodedType.init(decoder: cereal)
    }

    private static func instantiateIdentifyingCereal(value: String) throws -> IdentifyingCerealType {
        var scanIndex = value.startIndex
        let identifier: String

        (identifier, scanIndex) = try CerealDecoder.extractValueFromEncodedString(value, startingAtIndex: scanIndex)

        let type = try identifyingCerealTypeWithIdentifier(identifier)
        let cereal = try CerealDecoder(encodedString: value[scanIndex ..< value.endIndex])
        return try type.init(decoder: cereal)
    }

    // MARK: - Extractors
    // An extractor takes a String and returns value (and optionally type) data while increasing an
    // index along the passed in string.

    private static func extractValueFromEncodedString(encodedString: String, startingAtIndex index: String.Index) throws -> (value: String, indexPassedValue: String.Index) {
        var scanIndex = index

        guard let valueLengthEndIndex = encodedString.firstOccuranceOfString(":", fromIndex: scanIndex) else {
            throw CerealError.ValueLengthEndNotFound
        }

        guard let valueLength = Int(encodedString[scanIndex ..< valueLengthEndIndex]) else {
            throw CerealError.UnsupportedValueLengthValue
        }

        scanIndex = valueLengthEndIndex.advancedBy(1) // Move past value length plus the following :
        let valueEndIndex = scanIndex.advancedBy(valueLength)
        let value = encodedString[scanIndex ..< valueEndIndex]
        scanIndex = valueEndIndex

        if valueEndIndex != encodedString.endIndex {
            scanIndex = valueEndIndex.advancedBy(1)
        }

        return (value: value, indexPassedValue: scanIndex)
    }

    private static func extractCerealTypeFromEncodedString(encodedString: String, var startingAtIndex index: String.Index) throws -> (type: CerealTypeIdentifier, indexPassedValue: String.Index) {
        let encodedStringSlice = encodedString[index ..< index.advancedBy(1)]
        guard let type = CerealTypeIdentifier(rawValue: encodedStringSlice) else {
            throw CerealError.InvalidEncoding("Failed to instantiate CerealTypeIdentifier with \(encodedStringSlice)")
        }

        index = index.advancedBy(2) // Move past type and following comma

        return (type: type, indexPassedValue: index)
    }

    private static func extractTypeAndValueFromEncodedString(encodedString: String, var startingAtIndex index: String.Index) throws -> (type: CerealTypeIdentifier, value: String, endIndex: String.Index) {
        let cerealType: CerealTypeIdentifier
        (cerealType, index) = try CerealDecoder.extractCerealTypeFromEncodedString(encodedString, startingAtIndex: index)

        let value: String
        (value, index) = try CerealDecoder.extractValueFromEncodedString(encodedString, startingAtIndex: index)

        return (type: cerealType, value: value, endIndex: index)
    }

    // MARK: - Parsers
    // Parsers are to DRY up some of the decoding code. For example, [CerealType] and [CerealRepresentable: [CerealType]] can reuse a parser for decoding
    // the array of CerealType.

    private static func parseEncodedArrayString(encodedString: String) throws -> [CerealRepresentable] {
        var decodedItems = [CerealRepresentable]()

        try encodedString.iterateEncodedValuesWithInstantationHandler { type, value in
            decodedItems.append(try CerealDecoder.instantiate(value, ofType: type))
        }

        return decodedItems
    }

    private static func parseEncodedArrayString<DecodedType: CerealRepresentable>(encodedString: String) throws -> [DecodedType] {
        var decodedItems = [DecodedType]()

        try encodedString.iterateEncodedValuesWithInstantationHandler { type, value in
            guard let decodedValue: DecodedType = try CerealDecoder.instantiate(value, ofType: type) as? DecodedType else {
                throw CerealError.InvalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems.append(decodedValue)
        }

        return decodedItems
    }

    private static func parseEncodedCerealArrayString<DecodedType: CerealType>(encodedString: String) throws -> [DecodedType] {
        var decodedItems = [DecodedType]()
        try encodedString.iterateEncodedValuesWithInstantationHandler { type, value in
            decodedItems.append(try CerealDecoder.instantiateCereal(value, ofType: type))
        }

        return decodedItems
    }

    private static func parseEncodedIdentifyingCerealArrayString(encodedString: String) throws -> [IdentifyingCerealType] {
        var decodedItems = [IdentifyingCerealType]()
        try encodedString.iterateEncodedValuesWithInstantationHandler { _, value in
            decodedItems.append(try CerealDecoder.instantiateIdentifyingCereal(value))
        }

        return decodedItems
    }

    private static func parseEncodedDictionaryString<DecodedKeyType: protocol<Hashable, CerealRepresentable>>(encodedString: String) throws -> [DecodedKeyType: CerealRepresentable] {
        var decodedItems = [DecodedKeyType: CerealRepresentable]()
        try encodedString.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, type, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.InvalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems[decodedKey] = try CerealDecoder.instantiate(value, ofType: type)
        }

        return decodedItems
    }

    private static func parseEncodedDictionaryString<DecodedKeyType: protocol<Hashable, CerealRepresentable>, DecodedValueType: CerealRepresentable>(encodedString: String) throws -> [DecodedKeyType: DecodedValueType] {
        var decodedItems = [DecodedKeyType: DecodedValueType]()
        try encodedString.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, type, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.InvalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            guard let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value, ofType: type) as? DecodedValueType else {
                throw CerealError.InvalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseEncodedCerealDictionaryString<DecodedKeyType: protocol<Hashable, CerealRepresentable>, DecodedValueType: CerealType>(encodedString: String) throws -> [DecodedKeyType: DecodedValueType] {
        var decodedItems = [DecodedKeyType: DecodedValueType]()
        try encodedString.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, type, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.InvalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems[decodedKey] = try CerealDecoder.instantiateCereal(value, ofType: type) as DecodedValueType
        }

        return decodedItems
    }

    private static func parseEncodedCerealDictionaryString<DecodedKeyType: protocol<Hashable, CerealType>, DecodedValueType: CerealRepresentable>(encodedString: String) throws -> [DecodedKeyType: DecodedValueType] {
        var decodedItems = [DecodedKeyType: DecodedValueType]()
        try encodedString.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, type, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(keyValue, ofType: keyType)
            guard let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value, ofType: type) as? DecodedValueType else {
                throw CerealError.InvalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseEncodedCerealPairDictionaryString<DecodedKeyType: protocol<Hashable, CerealType>, DecodedValueType: CerealType>(encodedString: String) throws -> [DecodedKeyType: DecodedValueType] {
        var decodedItems = [DecodedKeyType: DecodedValueType]()
        try encodedString.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, type, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(keyValue, ofType: keyType)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiateCereal(value, ofType: type)

            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseEncodedIdentifyingCerealDictionaryString<DecodedKeyType: protocol<Hashable, CerealRepresentable>>(encodedString: String) throws -> [DecodedKeyType: IdentifyingCerealType] {
        var decodedItem = [DecodedKeyType: IdentifyingCerealType]()
        try encodedString.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, _, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.InvalidEncoding("Failed to decode key value \(keyValue) with key type \(keyType)")
            }

            decodedItem[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value)
        }

        return decodedItem
    }

    private static func parseEncodedCerealToIdentifyingCerealDictionaryString<DecodedKeyType: protocol<Hashable, CerealType>>(encodedString: String) throws -> [DecodedKeyType: IdentifyingCerealType] {
        var decodedItem = [DecodedKeyType: IdentifyingCerealType]()
        try encodedString.iterateEncodedValuesWithInstantationHandler { keyType, keyValue, _, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(keyValue, ofType: keyType)
            decodedItem[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value)
        }

        return decodedItem
    }
}


extension String {
    func iterateEncodedValuesWithInstantationHandler(instantiationHandler: (type: CerealTypeIdentifier, value: String) throws -> Void) throws {
        var scanIndex = startIndex
        while scanIndex != endIndex {
            let type: CerealTypeIdentifier
            let value: String
            (type, value, scanIndex) = try CerealDecoder.extractTypeAndValueFromEncodedString(self, startingAtIndex: scanIndex)

            try instantiationHandler(type: type, value: value)
        }
    }

    func iterateEncodedValuesWithInstantationHandler(instantiationHandler: (keyType: CerealTypeIdentifier, keyValue: String, type: CerealTypeIdentifier, value: String) throws -> Void) throws {
        var scanIndex = startIndex
        while scanIndex != endIndex {
            let keyType: CerealTypeIdentifier
            let keyValue: String
            (keyType, keyValue, scanIndex) = try CerealDecoder.extractTypeAndValueFromEncodedString(self, startingAtIndex: scanIndex)

            let type: CerealTypeIdentifier
            let value: String
            (type, value, scanIndex) = try CerealDecoder.extractTypeAndValueFromEncodedString(self, startingAtIndex: scanIndex)

            try instantiationHandler(keyType: keyType, keyValue: keyValue, type: type, value: value)
        }
    }
}

extension Bool {
    private init?(_ s: String) {
        if s == "t" {
            self.init(true)
        } else if s == "f" {
            self.init(false)
        } else {
            return nil
        }
    }
}
