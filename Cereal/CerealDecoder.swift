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
    public init(data: Data) throws {
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

        return try CerealDecoder.instantiateValue(data.value, ofType: data.type) as? DecodedType
    }

    /**
     Decodes the `RawRepresentable` object contained in key.

     This method is identical to `decode<DecodedType: CerealRepresentable>`, but may automatically decode
     `RawRepresentable` types whose RawValue conforms `CerealRepresentable`.

     - parameter    key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedType: RawRepresentable>(key: String) throws -> DecodedType? where DecodedType: CerealRepresentable, DecodedType.RawValue: CerealRepresentable {
        guard let data = items[key] else {
            return nil
        }

        guard let rawValue = try CerealDecoder.instantiateValue(data.value, ofType: data.type) as? DecodedType.RawValue else {
            return nil
        }
        return DecodedType(rawValue: rawValue)
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

        return try CerealDecoder.instantiateCereal(value: data.value, ofType: data.type) as DecodedType
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

        return try CerealDecoder.instantiateIdentifyingCereal(value: data.value)
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
    public func decode<DecodedKeyType: CerealRepresentable & Hashable, DecodedValueType: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()

        try data.value.iterateEncodedValues { type, value in
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
    public func decodeCereal<DecodedKeyType: CerealRepresentable & Hashable, DecodedValueType: CerealType>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()

        try data.value.iterateEncodedValues { type, value in
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
    public func decodeCereal<DecodedKeyType: CerealType & Hashable, DecodedValueType: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()

        try data.value.iterateEncodedValues { type, value in
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
    public func decodeCerealPair<DecodedKeyType: CerealType & Hashable, DecodedValueType: CerealType>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()

        try data.value.iterateEncodedValues { type, value in
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
    public func decodeIdentifyingCerealArray<DecodedKeyType: CerealRepresentable & Hashable>(key: String) throws -> [[DecodedKeyType: IdentifyingCerealType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        try data.value.iterateEncodedValues { type, value in
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
    public func decodeCerealToIdentifyingCerealArray<DecodedKeyType: CerealType & Hashable>(key: String) throws -> [[DecodedKeyType: IdentifyingCerealType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        try data.value.iterateEncodedValues { type, value in
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
    public func decode<DecodedKeyType: CerealRepresentable & Hashable, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
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
    public func decode<DecodedKeyType: CerealRepresentable & Hashable>(key: String) throws -> [DecodedKeyType: CerealRepresentable]? {
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
    public func decodeCereal<DecodedKeyType: CerealRepresentable & Hashable, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
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
    public func decodeCereal<DecodedKeyType: CerealType & Hashable, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
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
    public func decodeIdentifyingCerealDictionary<DecodedKeyType: CerealRepresentable & Hashable>(key: String) throws -> [DecodedKeyType: IdentifyingCerealType]? {
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
    public func decodeCerealPair<DecodedKeyType: CerealType & Hashable, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
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
    public func decodeCerealToIdentifyingCerealDictionary<DecodedKeyType: CerealType & Hashable>(key: String) throws -> [DecodedKeyType: IdentifyingCerealType]? {
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
    public func decode<DecodedKeyType: CerealRepresentable & Hashable, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [DecodedValueType]]()

        try data.value.iterateEncodedValues { keyType, keyValue, _, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiateValue(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.invalidEncoding("Failed to instantiate keyValue \(keyValue) of type \(keyType)")
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
    public func decodeCereal<DecodedKeyType: CerealRepresentable & Hashable, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [DecodedValueType]]()

        try data.value.iterateEncodedValues { keyType, keyValue, _, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiateValue(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.invalidEncoding("Failed to instantiate keyValue \(keyValue) of type \(keyType)")
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
    public func decodeCereal<DecodedKeyType: CerealType & Hashable, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [DecodedValueType]]()

        try data.value.iterateEncodedValues { keyType, keyValue, _, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: keyValue, ofType: keyType)
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
    public func decodeCerealPair<DecodedKeyType: CerealType & Hashable, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [DecodedValueType]]()

        try data.value.iterateEncodedValues { keyType, keyValue, _, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: keyValue, ofType: keyType)
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
    public func decodeIdentifyingCerealDictionary<DecodedKeyType: CerealRepresentable & Hashable>(key: String) throws -> [DecodedKeyType: [IdentifyingCerealType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [IdentifyingCerealType]]()

        try data.value.iterateEncodedValues { keyType, keyValue, _, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiateValue(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.invalidEncoding("Failed to instantiate keyValue \(keyValue) of type \(keyType)")
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
    public func decodeCerealToIdentifyingCerealDictionary<DecodedKeyType: CerealType & Hashable>(key: String) throws -> [DecodedKeyType: [IdentifyingCerealType]]? {
        guard let data = items[key] else {
            return nil
        }

        var decodedItems = [DecodedKeyType: [IdentifyingCerealType]]()

        try data.value.iterateEncodedValues { keyType, keyValue, _, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: keyValue, ofType: keyType)
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
    public static func rootItem<ItemType: CerealRepresentable>(with data: Data) throws -> ItemType {
        let decoder = try CerealDecoder(data: data)
        guard let item: ItemType =  try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: ItemType)`.
    
    This method will instantiate your custom `CerealType` objects.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: ItemType)`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItem<ItemType: CerealType>(with data: Data) throws -> ItemType {
        let decoder = try CerealDecoder(data: data)
        guard let item: ItemType =  try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem(_: IdentifyingCerealType)`.
    
    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem(_: IdentifyingCerealType)`.
    - returns:      The instantiated object.
    */
    public static func rootIdentifyingCerealItem(with data: Data) throws -> IdentifyingCerealType {
        let decoder = try CerealDecoder(data: data)
        guard let item: IdentifyingCerealType = try decoder.decodeIdentifyingCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    // MARK: Arrays

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: [ItemType])`.
    
    If you encoded custom objects conforming to `CerealType`, use `CerealDecoder.rootCerealItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: [ItemType])`.
    - returns:      The instantiated object.
    */
    public static func rootItems<ItemType: CerealRepresentable>(with data: Data) throws -> [ItemType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemType] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: [ItemType])`.
    
    This method will instantiate your custom `CerealType` objects.

    - param         data:    The data returned by `CerealEncoder.dataWithRootItem<ItemType: CerealRepresentable>(_: [ItemType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemType: CerealType>(with data: Data) throws -> [ItemType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemType] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem(_: [IdentifyingCerealType])`.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem(_: [IdentifyingCerealType])`.
    - returns:      The instantiated object.
    */
    public static func rootIdentifyingCerealItems(with data: Data) throws -> [IdentifyingCerealType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [IdentifyingCerealType] = try decoder.decodeIdentifyingCerealArray(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    // MARK: Arrays of Dictionaries

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    
    If you encoded custom objects conforming to `CerealType`, use `CerealDecoder.rootCerealItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    - returns:      The instantiated object.
    */
    public static func rootItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [[ItemKeyType: ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: ItemValueType]] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    
    This method will instantiate your custom `CerealType` objects.
    
    If you encoded custom objects for the ItemKeyType conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [[ItemKeyType: ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: ItemValueType]] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.

    This method will instantiate your custom `CerealType` objects.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(_: [[ItemKeyType: ItemValueType]])`.
    - returns:      The instantiated object.
    */

    public static func rootCerealPairItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [[ItemKeyType: ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: ItemValueType]] = try decoder.decodeCerealPair(key: rootKey) else { throw CerealError.rootItemNotFound }
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

    public static func rootIdentifyingCerealItems<ItemKeyType: CerealRepresentable & Hashable>(with data: Data) throws -> [[ItemKeyType: IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: IdentifyingCerealType]] = try decoder.decodeIdentifyingCerealArray(key: rootKey) else { throw CerealError.rootItemNotFound }
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
    public static func rootCerealToIdentifyingCerealItems<ItemKeyType: CerealType & Hashable>(with data: Data) throws -> [[ItemKeyType: IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: IdentifyingCerealType]] = try decoder.decodeCerealToIdentifyingCerealArray(key: rootKey) else { throw CerealError.rootItemNotFound }
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
    public static func rootItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.

    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.

    If you encoded custom objects for your values conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealPairItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decodeCerealPair(key: rootKey) else { throw CerealError.rootItemNotFound }
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
    public static func rootIdentifyingCerealItems<ItemKeyType: CerealRepresentable & Hashable>(with data: Data) throws -> [ItemKeyType: IdentifyingCerealType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: IdentifyingCerealType] = try decoder.decodeIdentifyingCerealDictionary(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: IdentifyingCerealType])`.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: IdentifyingCerealType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealToIdentifyingCerealItems<ItemKeyType: CerealType & Hashable>(with data: Data) throws -> [ItemKeyType: IdentifyingCerealType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: IdentifyingCerealType] = try decoder.decodeCerealToIdentifyingCerealDictionary(key: rootKey) else { throw CerealError.rootItemNotFound }
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
    public static func rootItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

    If you encoded custom objects for your values conforming to `CerealType`, use `CerealDecoder.rootCerealPairItemsWithData` instead.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
    - returns:       The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(root: [ItemKeyType: [ItemValueType]])`.
    - returns:       The instantiated object.
    */
    public static func rootCerealPairItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCerealPair(key: rootKey) else { throw CerealError.rootItemNotFound }
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
    public static func rootIdentifyingCerealItems<ItemKeyType: CerealRepresentable & Hashable>(with data: Data) throws -> [ItemKeyType: [IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [IdentifyingCerealType]] = try decoder.decodeIdentifyingCerealDictionary(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: [IdentifyingCerealType]])`.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.dataWithRootItem<ItemKeyType: protocol<CerealRepresentable, Hashable>>(root: [ItemKeyType: [IdentifyingCerealType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealToIdentifyingCerealItems<ItemKeyType: CerealType & Hashable>(with data: Data) throws -> [ItemKeyType: [IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [IdentifyingCerealType]] = try decoder.decodeCerealToIdentifyingCerealDictionary(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    // MARK: Initial Decoding
    private static func decodeData(_ data: Data) throws -> String {
        guard let string = String.init(data: data, encoding: .utf8) else {
            throw CerealError.invalidEncoding("Failed to instantiate string")
        }

        return string
    }

    private static func decodeString(_ encodedString: String) throws -> [String: DeferredItem] {
        var deferredItems = [String: DeferredItem]()
        var scanIndex = encodedString.startIndex

        while scanIndex != encodedString.endIndex {
            if encodedString.substring(with: scanIndex ..< encodedString.index(scanIndex, offsetBy: 2)) != "k," {
                throw CerealError.invalidEncoding("Failed to get sub string")
            }

            scanIndex = encodedString.index(scanIndex, offsetBy: 2)

            guard let keyLengthEndIndex = encodedString.firstOccuranceOfString(":", fromIndex: scanIndex) else {
                throw CerealError.invalidEncoding("Failed to get key length")
            }

            guard let keyLength = Int(encodedString[scanIndex ..< keyLengthEndIndex]) else {
                throw CerealError.unsupportedKeyLengthValue
            }

            scanIndex = encodedString.index(keyLengthEndIndex, offsetBy: 1) // Move past key length and the following :

            // scanIndex now points to the first character of the key

            let keyEndIndex = encodedString.index(scanIndex, offsetBy: keyLength)
            let key = encodedString[scanIndex ..< keyEndIndex]

            scanIndex = encodedString.index(keyEndIndex, offsetBy: 1) // Move past the : after the key

            let cerealType: CerealTypeIdentifier
            (cerealType, scanIndex) = try CerealDecoder.extractCerealType(fromEncodedString: encodedString, startingAt: scanIndex)

            let value: String
            (value, scanIndex) = try extractValue(fromEncodedString: encodedString, startingAt: scanIndex)

            deferredItems[key] = DeferredItem(type: cerealType, value: value)
        }

        return deferredItems
    }

    // MARK: - Instantiators
    // Instantiators take a String and type information, either through a CerealTypeIdentifier or a Generic, and instantiate the object
    // being asked for

    /// Used for primitive or identifying cereal values
    private static func instantiateValue(_ value: String, ofType type: CerealTypeIdentifier) throws -> CerealRepresentable {
        switch type {
        case .identifyingCereal:
            return try instantiateIdentifyingCereal(value: value)
        case .array, .cereal, .dictionary:
            throw CerealError.invalidEncoding(".Array / .Cereal / .Dictionary not expected")
        case .string:
            return value
        case .int:
            guard let convertedValue = Int(value) else {
                throw CerealError.invalidEncoding("Failed to create Int with value \(value)")
            }

            return convertedValue
        case .int64:
            guard let convertedValue = Int64(value) else {
                throw CerealError.invalidEncoding("Failed to create Int64 with value \(value)")
            }

            return convertedValue
        case .double:
            guard let convertedValue = Double(value) else {
                throw CerealError.invalidEncoding("Failed to create Double with value \(value)")
            }

            return convertedValue
        case .float:
            guard let convertedValue = Float(value) else {
                throw CerealError.invalidEncoding("Failed to create Float with value \(value)")
            }

            return convertedValue
        case .bool:
            guard let convertedValue = Bool(value) else {
                throw CerealError.invalidEncoding("Failed to create Bool with value \(value)")
            }
            return convertedValue
        case .date:
            guard let convertedValue = TimeInterval(value) else {
                throw CerealError.invalidEncoding("Failed to create TimeInterval with value \(value)")
            }
            return Date(timeIntervalSince1970: convertedValue)
        case .preciseDate:
            guard let convertedValue = TimeInterval(value) else {
                throw CerealError.invalidEncoding("Failed to create TimeInterval with value \(value)")
            }
            return Date(timeIntervalSinceReferenceDate: convertedValue)
        case .url:
            guard let url = URL(string: value) else {
                throw CerealError.invalidEncoding("Failed to create URL with value \(value)")
            }
            
            return url
        }
    }

    /// Used for CerealType where we have type data from the compiler
    private static func instantiateCereal<DecodedType: CerealType>(value: String, ofType type: CerealTypeIdentifier) throws -> DecodedType {
        let cereal: CerealDecoder
        switch type {
        case .identifyingCereal:
            // Skip the identifying data as we have the type in this case from the generic
            let (_, index) = try extractValue(fromEncodedString: value, startingAt: value.startIndex)
            cereal = try CerealDecoder(encodedString: value[index ..< value.endIndex])
        case .cereal:
            cereal = try CerealDecoder(encodedString: value)
        default:
            throw CerealError.invalidEncoding("Invalid type found: \(type)")
        }

        return try DecodedType.init(decoder: cereal)
    }

    private static func instantiateIdentifyingCereal(value: String) throws -> IdentifyingCerealType {
        var scanIndex = value.startIndex
        let identifier: String

        (identifier, scanIndex) = try CerealDecoder.extractValue(fromEncodedString: value, startingAt: scanIndex)

        let type = try identifyingCerealType(withIdentifier: identifier)
        let cereal = try CerealDecoder(encodedString: value[scanIndex ..< value.endIndex])
        return try type.init(decoder: cereal)
    }

    // MARK: - Extractors
    // An extractor takes a String and returns value (and optionally type) data while increasing an
    // index along the passed in string.

    private static func extractValue(fromEncodedString encodedString: String, startingAt index: String.Index) throws -> (value: String, indexPassedValue: String.Index) {
        var scanIndex = index

        guard let valueLengthEndIndex = encodedString.firstOccuranceOfString(":", fromIndex: scanIndex) else {
            throw CerealError.valueLengthEndNotFound
        }

        guard let valueLength = Int(encodedString[scanIndex ..< valueLengthEndIndex]) else {
            throw CerealError.unsupportedValueLengthValue
        }

        scanIndex = encodedString.index(valueLengthEndIndex, offsetBy: 1) // Move past value length plus the following :
        let valueEndIndex = encodedString.index(scanIndex, offsetBy: valueLength)
        let value = encodedString[scanIndex ..< valueEndIndex]
        scanIndex = valueEndIndex

        if valueEndIndex != encodedString.endIndex {
            scanIndex = encodedString.index(valueEndIndex, offsetBy: 1)
        }

        return (value: value, indexPassedValue: scanIndex)
    }

    private static func extractCerealType(fromEncodedString encodedString: String, startingAt index: String.Index) throws -> (type: CerealTypeIdentifier, indexPassedValue: String.Index) {
        var index = index
        let encodedStringSlice = encodedString[index ..< encodedString.index(index, offsetBy: 1)]
        guard let type = CerealTypeIdentifier(rawValue: encodedStringSlice) else {
            throw CerealError.invalidEncoding("Failed to instantiate CerealTypeIdentifier with \(encodedStringSlice)")
        }

        index = encodedString.index(index, offsetBy: 2) // Move past type and following comma

        return (type: type, indexPassedValue: index)
    }

    fileprivate static func extractTypeAndValue(fromEncodedString encodedString: String, startingAtIndex index: String.Index) throws -> (type: CerealTypeIdentifier, value: String, endIndex: String.Index) {
        var index = index
        let cerealType: CerealTypeIdentifier
        (cerealType, index) = try CerealDecoder.extractCerealType(fromEncodedString: encodedString, startingAt: index)

        let value: String
        (value, index) = try CerealDecoder.extractValue(fromEncodedString: encodedString, startingAt: index)

        return (type: cerealType, value: value, endIndex: index)
    }

    // MARK: - Parsers
    // Parsers are to DRY up some of the decoding code. For example, [CerealType] and [CerealRepresentable: [CerealType]] can reuse a parser for decoding
    // the array of CerealType.

    private static func parseEncodedArrayString(_ encodedString: String) throws -> [CerealRepresentable] {
        var decodedItems = [CerealRepresentable]()

        try encodedString.iterateEncodedValues { type, value in
            decodedItems.append(try CerealDecoder.instantiateValue(value, ofType: type))
        }

        return decodedItems
    }

    private static func parseEncodedArrayString<DecodedType: CerealRepresentable>(_ encodedString: String) throws -> [DecodedType] {
        var decodedItems = [DecodedType]()

        try encodedString.iterateEncodedValues { type, value in
            guard let decodedValue: DecodedType = try CerealDecoder.instantiateValue(value, ofType: type) as? DecodedType else {
                throw CerealError.invalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems.append(decodedValue)
        }

        return decodedItems
    }

    private static func parseEncodedCerealArrayString<DecodedType: CerealType>(_ encodedString: String) throws -> [DecodedType] {
        var decodedItems = [DecodedType]()
        try encodedString.iterateEncodedValues { type, value in
            decodedItems.append(try CerealDecoder.instantiateCereal(value: value, ofType: type))
        }

        return decodedItems
    }

    private static func parseEncodedIdentifyingCerealArrayString(_ encodedString: String) throws -> [IdentifyingCerealType] {
        var decodedItems = [IdentifyingCerealType]()
        try encodedString.iterateEncodedValues { _, value in
            decodedItems.append(try CerealDecoder.instantiateIdentifyingCereal(value: value))
        }

        return decodedItems
    }

    private static func parseEncodedDictionaryString<DecodedKeyType: Hashable & CerealRepresentable>(_ encodedString: String) throws -> [DecodedKeyType: CerealRepresentable] {
        var decodedItems = [DecodedKeyType: CerealRepresentable]()
        try encodedString.iterateEncodedValues { keyType, keyValue, type, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiateValue(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.invalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems[decodedKey] = try CerealDecoder.instantiateValue(value, ofType: type)
        }

        return decodedItems
    }

    private static func parseEncodedDictionaryString<DecodedKeyType: Hashable & CerealRepresentable, DecodedValueType: CerealRepresentable>(_ encodedString: String) throws -> [DecodedKeyType: DecodedValueType] {
        var decodedItems = [DecodedKeyType: DecodedValueType]()
        try encodedString.iterateEncodedValues { keyType, keyValue, type, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiateValue(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.invalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            guard let decodedValue: DecodedValueType = try CerealDecoder.instantiateValue(value, ofType: type) as? DecodedValueType else {
                throw CerealError.invalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseEncodedCerealDictionaryString<DecodedKeyType: Hashable & CerealRepresentable, DecodedValueType: CerealType>(_ encodedString: String) throws -> [DecodedKeyType: DecodedValueType] {
        var decodedItems = [DecodedKeyType: DecodedValueType]()
        try encodedString.iterateEncodedValues { keyType, keyValue, type, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiateValue(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.invalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems[decodedKey] = try CerealDecoder.instantiateCereal(value: value, ofType: type) as DecodedValueType
        }

        return decodedItems
    }

    private static func parseEncodedCerealDictionaryString<DecodedKeyType: Hashable & CerealType, DecodedValueType: CerealRepresentable>(_ encodedString: String) throws -> [DecodedKeyType: DecodedValueType] {
        var decodedItems = [DecodedKeyType: DecodedValueType]()
        try encodedString.iterateEncodedValues { keyType, keyValue, type, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: keyValue, ofType: keyType)
            guard let decodedValue: DecodedValueType = try CerealDecoder.instantiateValue(value, ofType: type) as? DecodedValueType else {
                throw CerealError.invalidEncoding("Failed to decode value \(value) of type \(type)")
            }

            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseEncodedCerealPairDictionaryString<DecodedKeyType: Hashable & CerealType, DecodedValueType: CerealType>(_ encodedString: String) throws -> [DecodedKeyType: DecodedValueType] {
        var decodedItems = [DecodedKeyType: DecodedValueType]()
        try encodedString.iterateEncodedValues { keyType, keyValue, type, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: keyValue, ofType: keyType)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiateCereal(value: value, ofType: type)

            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    private static func parseEncodedIdentifyingCerealDictionaryString<DecodedKeyType: Hashable & CerealRepresentable>(_ encodedString: String) throws -> [DecodedKeyType: IdentifyingCerealType] {
        var decodedItem = [DecodedKeyType: IdentifyingCerealType]()
        try encodedString.iterateEncodedValues { keyType, keyValue, _, value in
            guard let decodedKey: DecodedKeyType = try CerealDecoder.instantiateValue(keyValue, ofType: keyType) as? DecodedKeyType else {
                throw CerealError.invalidEncoding("Failed to decode key value \(keyValue) with key type \(keyType)")
            }

            decodedItem[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value: value)
        }

        return decodedItem
    }

    private static func parseEncodedCerealToIdentifyingCerealDictionaryString<DecodedKeyType: Hashable & CerealType>(_ encodedString: String) throws -> [DecodedKeyType: IdentifyingCerealType] {
        var decodedItem = [DecodedKeyType: IdentifyingCerealType]()
        try encodedString.iterateEncodedValues { keyType, keyValue, _, value in
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: keyValue, ofType: keyType)
            decodedItem[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value: value)
        }

        return decodedItem
    }
}


extension String {
    func iterateEncodedValues(withInstantiationHandler instantiationHandler: (_ type: CerealTypeIdentifier, _ value: String) throws -> Void) throws {
        var scanIndex = startIndex
        while scanIndex != endIndex {
            let type: CerealTypeIdentifier
            let value: String
            (type, value, scanIndex) = try CerealDecoder.extractTypeAndValue(fromEncodedString: self, startingAtIndex: scanIndex)

            try instantiationHandler(type, value)
        }
    }

    func iterateEncodedValues(withInstantationHandler instantiationHandler: (_ keyType: CerealTypeIdentifier, _ keyValue: String, _ type: CerealTypeIdentifier, _ value: String) throws -> Void) throws {
        var scanIndex = startIndex
        while scanIndex != endIndex {
            let keyType: CerealTypeIdentifier
            let keyValue: String
            (keyType, keyValue, scanIndex) = try CerealDecoder.extractTypeAndValue(fromEncodedString: self, startingAtIndex: scanIndex)

            let type: CerealTypeIdentifier
            let value: String
            (type, value, scanIndex) = try CerealDecoder.extractTypeAndValue(fromEncodedString: self, startingAtIndex: scanIndex)

            try instantiationHandler(keyType, keyValue, type, value)
        }
    }
}

extension Bool {
    fileprivate init?(_ s: String) {
        if s == "t" {
            self.init(true)
        } else if s == "f" {
            self.init(false)
        } else {
            return nil
        }
    }
}
