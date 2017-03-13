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

private class TypeIndexMapHolder: SyncHolder<TypeIndexMap> {
    func typeMap(forType type: Any.Type) -> [String: Int]? {
        var result: [String: Int]? = nil
        self.sync {
            for item in self.values where item.type == type {
                result = item.map
                break
            }
        }

        return result
    }

    func save(map: [String: Int], forType type: Any.Type) {
        self.appendData(TypeIndexMap(type: type, map: map))
    }
}

private let typesHolder = TypeIndexMapHolder()

/**
    A CerealDecoder handles decoding items that were encoded by a `CerealEncoder`.
*/
public struct CerealDecoder {

    private var items: [CoderTreeValue]
    private let reverseRange: StrideThrough<Int>
    private let indexMap: [String: Int]?

    fileprivate func itemFor(key: String) -> CoderTreeValue? {
        if items.count > 100 { // it appears that on small amount of items, a simmple array enumeration is faster than a dictionary lookup
            if let index = indexMap?[key], case let .pair(_, value) = items[index] {
                return value
            }
        }
        for index in reverseRange {
            guard case let .pair(keyValue, value) = items[index], case let .string(itemKey) = keyValue else { continue }
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
    public init(data: Data) throws {
        guard let tree = CoderTreeValue(data: data) else { throw CerealError.invalidDataContent }
        guard case .subTree(_) = tree else { throw CerealError.invalidDataContent }
        self.init(tree: tree)
    }
    
    private init(tree: CoderTreeValue) {
        switch tree {
        case let .subTree(array):
            items = array
            let count = array.count - 1
            reverseRange = stride(from: count, through: 0, by: -1)
        case let .identifyingTree(_, array):
            items = array
            let count = array.count - 1
            reverseRange = stride(from: count, through: 0, by: -1)
        default:
            items = []
            reverseRange = stride(from: 0, through: 0, by: -1)
            break
        }

        indexMap = nil
    }
    private init(items: [CoderTreeValue], map: [String: Int]) {
        self.items = items
        let count = items.count - 1
        reverseRange = stride(from: count, through: 0, by: -1)
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        let result: DecodedType = try CerealDecoder.instantiate(value: data)
        return result
    }

    /**
    Decodes the object contained in key.

    This method can decode any type that conforms to `CerealType`.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedType: CerealType>(key: String) throws -> DecodedType? {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.instantiateCereal(value: data) as DecodedType
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.instantiateIdentifyingCereal(value: data)
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parse(array: data)
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parse(array: data)
    }

    /**
    Decodes homogenous arrays of type `DecodedType`, where `DecodedType`
    conforms to `CerealType`.
    
    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCereal<DecodedType: CerealType>(key: String) throws -> [DecodedType]? {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parseCereal(array: data)
    }

    /**
    Decodes heterogeneous arrays conforming to `IdentifyingCerealType`.

    You must register the type with Cereal before it can be decoded properly.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeIdentifyingCerealArray(key: String) throws -> [IdentifyingCerealType]? {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parseIdentifyingCereal(array: data)
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
        guard let data = itemFor(key: key) else { 
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parse(dictionary: item))
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            let value: [DecodedKeyType: DecodedValueType] = try CerealDecoder.parseCereal(dictionary: item)
            decodedItems.append(value)
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCereal(dictionary: item))
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCerealPair(dictionary: item))
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseIdentifyingCereal(dictionary: item))
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCerealToIdentifyingCereal(dictionary: item))
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parse(dictionary: data)
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parse(dictionary: data)
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parseCereal(dictionary: data)
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parseCereal(dictionary: data)
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parseIdentifyingCereal(dictionary: data)
    }

    /**
    Decodes homogenous keys and values conforming to `CerealType`.

    - parameter     key:     The key that the object being decoded resides at.
    - returns:      The instantiated object, or nil if no object was at the specified key.
    */
    public func decodeCerealPair<DecodedKeyType: CerealType & Hashable, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: DecodedValueType]? {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parseCerealPair(dictionary: data)
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
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parseCerealToIdentifyingCereal(dictionary: data)
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parse(array: value)
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parseCereal(array: value)
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parse(array: value)
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parseCereal(array: value)
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = Dictionary<DecodedKeyType, [IdentifyingCerealType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parseIdentifyingCereal(array: value)
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
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = Dictionary<DecodedKeyType, [IdentifyingCerealType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parseIdentifyingCereal(array: value)
        }

        return decodedItems
    }

    // MARK: - Root Decoding

    // These methods are convenience methods that allow users to quickly decode their object.

    // MARK: Basic items

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemType: CerealRepresentable>(with rootItem: ItemType)`.
    
    If you encoded custom objects conforming to `CerealType`, use `CerealDecoder.rootCerealItem(with:)` instead.

    - parameter     data:    The data returned by `CerealEncoder.data(withRoot: ItemType)`.
    - returns:      The instantiated object.
    */
    public static func rootItem<ItemType: CerealRepresentable>(with data: Data) throws -> ItemType {
        let decoder = try CerealDecoder(data: data)
        guard let item: ItemType =  try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemType: CerealRepresentable>(withRoot: ItemType)`.
    
    This method will instantiate your custom `CerealType` objects.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemType: CerealRepresentable>(withRoot: ItemType)`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItem<ItemType: CerealType>(with data: Data) throws -> ItemType {
        let decoder = try CerealDecoder(data: data)
        guard let item: ItemType =  try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data(withRoot: IdentifyingCerealType)`.
    
    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.data(withRoot: IdentifyingCerealType)`.
    - returns:      The instantiated object.
    */
    public static func rootIdentifyingCerealItem(with data: Data) throws -> IdentifyingCerealType {
        let decoder = try CerealDecoder(data: data)
        guard let item: IdentifyingCerealType = try decoder.decodeIdentifyingCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    // MARK: Arrays

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemType: CerealRepresentable>(withRoot: [ItemType])`.
    
    If you encoded custom objects conforming to `CerealType`, use `CerealDecoder.rootCerealItems(with:)` instead.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemType: CerealRepresentable>(withRoot: [ItemType])`.
    - returns:      The instantiated object.
    */
    public static func rootItems<ItemType: CerealRepresentable>(with data: Data) throws -> [ItemType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemType] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemType: CerealRepresentable>(withRoot: [ItemType])`.
    
    This method will instantiate your custom `CerealType` objects.

    - param         data:    The data returned by `CerealEncoder.data<ItemType: CerealRepresentable>(withRoot: [ItemType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemType: CerealType>(with data: Data) throws -> [ItemType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemType] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data(withRoot: [IdentifyingCerealType])`.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.data(withRoot: [IdentifyingCerealType])`.
    - returns:      The instantiated object.
    */
    public static func rootIdentifyingCerealItems(with data: Data) throws -> [IdentifyingCerealType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [IdentifyingCerealType] = try decoder.decodeIdentifyingCerealArray(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    // MARK: Arrays of Dictionaries

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [[ItemKeyType: ItemValueType]])`.
    
    If you encoded custom objects conforming to `CerealType`, use `CerealDecoder.rootCerealItems` instead.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [[ItemKeyType: ItemValueType]])`.
    - returns:      The instantiated object.
    */
    public static func rootItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [[ItemKeyType: ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: ItemValueType]] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [[ItemKeyType: ItemValueType]])`.
    
    This method will instantiate your custom `CerealType` objects.
    
    If you encoded custom objects for the ItemKeyType conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [[ItemKeyType: ItemValueType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [[ItemKeyType: ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: ItemValueType]] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [[ItemKeyType: ItemValueType]])`.

    This method will instantiate your custom `CerealType` objects.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [[ItemKeyType: ItemValueType]])`.
    - returns:      The instantiated object.
    */

    public static func rootCerealPairItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [[ItemKeyType: ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: ItemValueType]] = try decoder.decodeCerealPair(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot: [[ItemKeyType: IdentifyingCerealType]])`.

    If you encoded custom objects for the ItemKeyType conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItems(with:)` instead.
    
    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot: [[ItemKeyType: IdentifyingCerealType]])`.
    - returns:      The instantiated object.
    */

    public static func rootIdentifyingCerealItems<ItemKeyType: CerealRepresentable & Hashable>(with data: Data) throws -> [[ItemKeyType: IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: IdentifyingCerealType]] = try decoder.decodeIdentifyingCerealArray(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot: [[ItemKeyType: IdentifyingCerealType]])`.

    If you encoded custom objects for the ItemKeyType conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItems(with:)` instead.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot: [[ItemKeyType: IdentifyingCerealType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealToIdentifyingCerealItems<ItemKeyType: CerealType & Hashable>(with data: Data) throws -> [[ItemKeyType: IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [[ItemKeyType: IdentifyingCerealType]] = try decoder.decodeCerealToIdentifyingCerealArray(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    // MARK: Dictionaries

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [ItemKeyType: ItemValueType])`.

    If you encoded custom objects for your values or keys conforming to `CerealType`, use `CerealDecoder.rootCerealItems(with:)` instead.
    
    If you encoded custom objects for your values and keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [ItemKeyType: ItemValueType])`.

    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [ItemKeyType: ItemValueType])`.

    If you encoded custom objects for your values conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [ItemKeyType: ItemValueType])`.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [ItemKeyType: ItemValueType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealPairItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [ItemKeyType: ItemValueType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: ItemValueType] = try decoder.decodeCerealPair(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot: [ItemKeyType: IdentifyingCerealType])`.
    
    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItems(with:)` instead.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot: [ItemKeyType: IdentifyingCerealType])`.
    - returns:      The instantiated object.
    */
    public static func rootIdentifyingCerealItems<ItemKeyType: CerealRepresentable & Hashable>(with data: Data) throws -> [ItemKeyType: IdentifyingCerealType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: IdentifyingCerealType] = try decoder.decodeIdentifyingCerealDictionary(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot: [ItemKeyType: IdentifyingCerealType])`.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot: [ItemKeyType: IdentifyingCerealType])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealToIdentifyingCerealItems<ItemKeyType: CerealType & Hashable>(with data: Data) throws -> [ItemKeyType: IdentifyingCerealType] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: IdentifyingCerealType] = try decoder.decodeCerealToIdentifyingCerealDictionary(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    // MARK: Dictionaries of Arrays

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot: [ItemKeyType: [ItemValueType]])`.

    If you encoded custom objects for your values or keys conforming to `CerealType`, use `CerealDecoder.rootCerealItems(with:)` instead.

    If you encoded custom objects for your values and keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.
    - returns:       The instantiated object.
    */
    public static func rootItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.

    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealRepresentable & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.

    If you encoded custom objects for your values conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.
    - returns:       The instantiated object.
    */
    public static func rootCerealItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.
    - returns:       The instantiated object.
    */
    public static func rootCerealPairItems<ItemKeyType: CerealType & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCerealPair(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot:  [ItemKeyType: [IdentifyingCerealType]])`.

    If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItems(with:)` instead.
    
    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot:  [ItemKeyType: [IdentifyingCerealType]])`.
    - returns:       The instantiated object.
    */
    public static func rootIdentifyingCerealItems<ItemKeyType: CerealRepresentable & Hashable>(with data: Data) throws -> [ItemKeyType: [IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [IdentifyingCerealType]] = try decoder.decodeIdentifyingCerealDictionary(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
    Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot:  [ItemKeyType: [IdentifyingCerealType]])`.

    The `IdentifyingCerealType` for the returned object must be registered
    before calling this method.

    - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot:  [ItemKeyType: [IdentifyingCerealType]])`.
    - returns:      The instantiated object.
    */
    public static func rootCerealToIdentifyingCerealItems<ItemKeyType: CerealType & Hashable>(with data: Data) throws -> [ItemKeyType: [IdentifyingCerealType]] {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [IdentifyingCerealType]] = try decoder.decodeCerealToIdentifyingCerealDictionary(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    // MARK: - Instantiators
    // Instantiators take a CoderTreeValue, optionally through a Generic, and instantiate the object
    // being asked for

    /// Used for primitive or identifying cereal values
    fileprivate static func instantiate(value: CoderTreeValue) throws -> CerealRepresentable {
        switch value {
            case let .string(val): return val
            case let .int(val):    return val
            case let .int64(val):  return val
            case let .double(val): return val
            case let .float(val):  return val
            case let .bool(val):   return val
            case let .date(val): return val
            case let .url(val):  return val
            case let .data(val): return val

            case .pair, .array, .subTree:
                throw CerealError.invalidEncoding(".Array / .Cereal / .Dictionary not expected")

            case .identifyingTree:
                return try instantiateIdentifyingCereal(value: value)
        }
    }
    fileprivate static func instantiate<DecodedType: CerealRepresentable>(value: CoderTreeValue) throws -> DecodedType {
        guard let decodedResult: DecodedType = try CerealDecoder.instantiate(value: value) as? DecodedType else {
            throw CerealError.invalidEncoding("Failed to decode value \(value)")
        }

        return decodedResult
    }

    /// Helper method to improve decoding speed for large objects:
    /// method returns index map to read value for key without enumerating through all the items
    fileprivate static func propertiesIndexMapForType(type: Any.Type, value: CoderTreeValue) -> [String: Int] {
        if let map = typesHolder.typeMap(forType: type) {
            return map
        }

        func buildIndexMap(items: [CoderTreeValue]) -> [String: Int] {
            // assuming the array of decoded values always contains constant number of entries
            var indexMap = [String: Int]()
            for (index,item) in items.enumerated() {
                guard case let .pair(keyValue, _) = item, case let .string(itemKey) = keyValue else { continue }
                indexMap[itemKey] = index
            }

            return indexMap
        }

        switch value {
        case let .identifyingTree(_, items):
            let map = buildIndexMap(items: items)
            typesHolder.save(map: map, forType: type)
            return map

        case let .subTree(items):
            let map = buildIndexMap(items: items)
            typesHolder.save(map: map, forType: type)
            return map
        default:
            return [:]
        }
    }

    /// Used for CerealType where we have type data from the compiler
    fileprivate static func instantiateCereal<DecodedType: CerealType>(value: CoderTreeValue) throws -> DecodedType {
        let map = CerealDecoder.propertiesIndexMapForType(type: DecodedType.self, value: value)

        let cereal: CerealDecoder
        switch value {
        case let .identifyingTree(_, items):
            cereal = CerealDecoder(items: items, map: map)
        case let .subTree(items):
            cereal = CerealDecoder(items: items, map: map)
        default:
            throw CerealError.invalidEncoding("Invalid type found: \(value)")
        }

        return try DecodedType.init(decoder: cereal)
    }

    fileprivate static func instantiateIdentifyingCereal(value: CoderTreeValue) throws -> IdentifyingCerealType {
        guard case let .identifyingTree(identifier, items) = value else {
            throw CerealError.rootItemNotFound
        }

        let type = try identifyingCerealTypeWithIdentifier(identifier)

        let map = CerealDecoder.propertiesIndexMapForType(type: type.self, value: value)

        let cereal = CerealDecoder(items: items, map: map)
        return try type.init(decoder: cereal)
    }

    // MARK: - Parsers
    // Parsers are to DRY up some of the decoding code. For example, [CerealType] and [CerealRepresentable: [CerealType]] can reuse a parser for decoding
    // the array of CerealType.

    fileprivate static func parse(array: CoderTreeValue) throws -> [CerealRepresentable] {
        guard case let .array(items) = array else { throw CerealError.typeMismatch("\(array) should be of type Array (line \(#line))") }

        var decodedItems = [CerealRepresentable]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.instantiate(value: item))
        }

        return decodedItems
    }

    fileprivate static func parse<DecodedType: CerealRepresentable>(array: CoderTreeValue) throws -> [DecodedType] {
        guard case let .array(items) = array else { throw CerealError.typeMismatch("\(array) should be of type Array (line \(#line))") }

        var decodedItems = [DecodedType]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            let decodedValue: DecodedType = try CerealDecoder.instantiate(value: item)
            decodedItems.append(decodedValue)
        }

        return decodedItems
    }

    fileprivate static func parseCereal<DecodedType: CerealType>(array: CoderTreeValue) throws -> [DecodedType] {
        guard case let .array(items) = array else { throw CerealError.typeMismatch("\(array) should be of type Array (line \(#line))") }

        var decodedItems = [DecodedType]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.instantiateCereal(value: item))
        }

        return decodedItems
    }

    fileprivate static func parseIdentifyingCereal(array: CoderTreeValue) throws -> [IdentifyingCerealType] {
        guard case let .array(items) = array else { throw CerealError.typeMismatch("\(array) should be of type Array (line \(#line))") }

        var decodedItems = [IdentifyingCerealType]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.instantiateIdentifyingCereal(value: item))
        }

        return decodedItems
    }

    fileprivate static func parse<DecodedKeyType: Hashable & CerealRepresentable>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: CerealRepresentable] {
        guard case let .array(items) = dictionary else { throw CerealError.rootItemNotFound }

        var decodedItems = Dictionary<DecodedKeyType, CerealRepresentable>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.instantiate(value: value)
        }

        return decodedItems
    }

    fileprivate static func parse<DecodedKeyType: Hashable & CerealRepresentable, DecodedValueType: CerealRepresentable>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.rootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value: value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    fileprivate static func parseCereal<DecodedKeyType: Hashable & CerealRepresentable, DecodedValueType: CerealType>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateCereal(value: value) as DecodedValueType
        }

        return decodedItems
    }

    fileprivate static func parseCereal<DecodedKeyType: Hashable & CerealType, DecodedValueType: CerealRepresentable>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.rootItemNotFound }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value: value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    fileprivate static func parseCerealPair<DecodedKeyType: Hashable & CerealType, DecodedValueType: CerealType>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiateCereal(value: value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    fileprivate static func parseIdentifyingCereal<DecodedKeyType: Hashable & CerealRepresentable>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: IdentifyingCerealType] {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, IdentifyingCerealType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value: value)
        }

        return decodedItems
    }

    fileprivate static func parseCerealToIdentifyingCereal<DecodedKeyType: Hashable & CerealType>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: IdentifyingCerealType] {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, IdentifyingCerealType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value: value)
        }

        return decodedItems
    }
}

// MARK: - RawRepresentable overrides -

public extension CerealDecoder {
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
    public func decode<DecodedType: RawRepresentable & CerealRepresentable>(key: String) throws -> DecodedType? where DecodedType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        }

        let decodedResult: DecodedType = try CerealDecoder.instantiate(value: data)
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
    public func decode<DecodedType: RawRepresentable & CerealRepresentable>(key: String) throws -> [DecodedType]? where DecodedType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parse(array: data)
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
    public func decode<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable, DecodedValueType: CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parse(dictionary: item))
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
    public func decode<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable, DecodedValueType: RawRepresentable & CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? where DecodedKeyType.RawValue: CerealRepresentable, DecodedValueType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parse(dictionary: item))
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
    public func decodeCereal<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable, DecodedValueType: CerealType>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCereal(dictionary: item))
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
    public func decodeCereal<DecodedKeyType: CerealType & Hashable, DecodedValueType: RawRepresentable & CerealRepresentable>(key: String) throws -> [[DecodedKeyType: DecodedValueType]]? where DecodedValueType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: DecodedValueType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseCereal(dictionary: item))
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
    public func decode<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: DecodedValueType]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parse(dictionary: data)
    }
    /**
     Decodes homogeneous dictoinaries conforming to `CerealRepresentable` for both the key
     and value.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable, DecodedValueType: RawRepresentable & CerealRepresentable>(key: String) throws -> [DecodedKeyType: DecodedValueType]? where DecodedKeyType.RawValue: CerealRepresentable, DecodedValueType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parse(dictionary: data)
    }

    /**
     Decodes heterogeneous values conforming to `CerealRepresentable`.
     They key must be homogeneous.

     This method does not support decoding `CerealType` objects, but
     can decode `IdentifyingCerealType` objects.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decode<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable>(key: String) throws -> [DecodedKeyType: CerealRepresentable]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parse(dictionary: data)
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
    public func decodeCereal<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: DecodedValueType]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parseCereal(dictionary: data)
    }

    /**
     Decodes homogenous values conforming to `CerealRepresentable` and keys conforming to
     `IdentifyingCerealType`.

     The `IdentifyingCerealType` for the value must be registered
     before calling this method.

     - parameter     key:     The key that the object being decoded resides at.
     - returns:      The instantiated object, or nil if no object was at the specified key.
     */
    public func decodeIdentifyingCerealDictionary<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable>(key: String) throws -> [DecodedKeyType: IdentifyingCerealType]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        }

        return try CerealDecoder.parseIdentifyingCereal(dictionary: data)
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
    public func decode<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable, DecodedValueType: CerealRepresentable>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.rootItemNotFound }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parse(array: value)
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
    public func decode<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable, DecodedValueType: RawRepresentable & CerealRepresentable>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? where DecodedKeyType.RawValue: CerealRepresentable, DecodedValueType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parse(array: value)
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
    public func decodeCereal<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable, DecodedValueType: CerealType>(key: String) throws -> [DecodedKeyType: [DecodedValueType]]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = Dictionary<DecodedKeyType, [DecodedValueType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parseCereal(array: value)
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
    public func decodeIdentifyingCerealDictionary<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable>(key: String) throws -> [DecodedKeyType: [IdentifyingCerealType]]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else {
            return nil
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("Expected array but \(data) found")
        }

        var decodedItems = Dictionary<DecodedKeyType, [IdentifyingCerealType]>(minimumCapacity: items.count)
        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }

            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.parseIdentifyingCereal(array: value)
        }

        return decodedItems
    }

    // MARK: - Root Decoding

    // These methods are convenience methods that allow users to quickly decode their object.

    // MARK: Arrays of Dictionaries

    /**
     Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.

     If you encoded custom objects for your values or keys conforming to `CerealType`, use `CerealDecoder.rootCerealItems(with:)` instead.

     If you encoded custom objects for your values and keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

     - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.
     - returns:       The instantiated object.
     */
    public static func rootItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealRepresentable>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] where ItemKeyType.RawValue: CerealRepresentable {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
     Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.

     If you encoded custom objects for your values or keys conforming to `CerealType`, use `CerealDecoder.rootCerealItems(with:)` instead.

     If you encoded custom objects for your values and keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

     - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.
     - returns:       The instantiated object.
     */
    public static func rootItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: RawRepresentable & CerealRepresentable>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] where ItemKeyType.RawValue: CerealRepresentable, ItemValueType.RawValue: CerealRepresentable {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decode(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    /**
     Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.

     If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealPairItems(with:)` instead.

     - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(withRoot:  [ItemKeyType: [ItemValueType]])`.
     - returns:      The instantiated object.
     */
    public static func rootCerealItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable, ItemValueType: CerealType>(with data: Data) throws -> [ItemKeyType: [ItemValueType]] where ItemKeyType.RawValue: CerealRepresentable {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [ItemValueType]] = try decoder.decodeCereal(key: rootKey) else { throw CerealError.rootItemNotFound }
        return item
    }

    // MARK: Dictionaries of Arrays

    /**
     Decodes objects encoded with `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot:  [ItemKeyType: [IdentifyingCerealType]])`.

     If you encoded custom objects for your keys conforming to `CerealType`, use `CerealDecoder.rootCerealToIdentifyingCerealItems(with:)` instead.

     The `IdentifyingCerealType` for the returned object must be registered
     before calling this method.

     - parameter     data:    The data returned by `CerealEncoder.data<ItemKeyType: protocol<CerealRepresentable, Hashable>>(withRoot:  [ItemKeyType: [IdentifyingCerealType]])`.
     - returns:       The instantiated object.
     */
    public static func rootIdentifyingCerealItems<ItemKeyType: RawRepresentable & CerealRepresentable & Hashable>(with data: Data) throws -> [ItemKeyType: [IdentifyingCerealType]] where ItemKeyType.RawValue: CerealRepresentable {
        let decoder = try CerealDecoder(data: data)
        guard let item: [ItemKeyType: [IdentifyingCerealType]] = try decoder.decodeIdentifyingCerealDictionary(key: rootKey) else { throw CerealError.rootItemNotFound }
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
    public func decodeIdentifyingCerealArray<DecodedKeyType: RawRepresentable & CerealRepresentable & Hashable>(key: String) throws -> [[DecodedKeyType: IdentifyingCerealType]]? where DecodedKeyType.RawValue: CerealRepresentable {
        guard let data = itemFor(key: key) else { 
            return nil 
        } 
        guard case let .array(items) = data else {
            throw CerealError.typeMismatch("\(data) should be an array (line \(#line))")
        }

        var decodedItems = [[DecodedKeyType: IdentifyingCerealType]]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            decodedItems.append(try CerealDecoder.parseIdentifyingCereal(dictionary: item))
        }

        return decodedItems
    }
}

// MARK: - RawRepresentable private functions overrides -

fileprivate extension CerealDecoder {
    // MARK: - Instantiators
    // Instantiators take a CoderTreeValue, optionally through a Generic, and instantiate the object
    // being asked for

    /// Used for primitive or identifying cereal values

    fileprivate static func instantiate<DecodedType: RawRepresentable>(value: CoderTreeValue) throws -> DecodedType where DecodedType: CerealRepresentable, DecodedType.RawValue: CerealRepresentable {
        guard let rawValue = try CerealDecoder.instantiate(value: value) as? DecodedType.RawValue, let decodedResult = DecodedType(rawValue: rawValue) else {
            throw CerealError.typeMismatch("Failed to decode value \(value)")
        }

        return decodedResult
    }

    // MARK: - Parsers
    
    fileprivate static func parse<DecodedType: RawRepresentable>(array: CoderTreeValue) throws -> [DecodedType] where DecodedType: CerealRepresentable, DecodedType.RawValue: CerealRepresentable {
        guard case let .array(items) = array else { throw CerealError.typeMismatch("\(array) should be of type Array (line \(#line))") }

        var decodedItems = [DecodedType]()
        decodedItems.reserveCapacity(items.count)
        for item in items {
            let decodedValue: DecodedType = try CerealDecoder.instantiate(value: item)
            decodedItems.append(decodedValue)
        }

        return decodedItems
    }

    fileprivate static func parse<DecodedKeyType: RawRepresentable & Hashable & CerealRepresentable>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: CerealRepresentable] where DecodedKeyType.RawValue: CerealRepresentable {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, CerealRepresentable>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.instantiate(value: value)
        }

        return decodedItems
    }

    fileprivate static func parse<DecodedKeyType: RawRepresentable & Hashable & CerealRepresentable, DecodedValueType: CerealRepresentable>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] where DecodedKeyType.RawValue: CerealRepresentable {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value: value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    fileprivate static func parse<DecodedKeyType: RawRepresentable & Hashable & CerealRepresentable, DecodedValueType: RawRepresentable & CerealRepresentable>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] where DecodedKeyType.RawValue: CerealRepresentable, DecodedValueType.RawValue: CerealRepresentable {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value: value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    fileprivate static func parseCereal<DecodedKeyType: RawRepresentable & Hashable & CerealRepresentable, DecodedValueType: CerealType>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] where DecodedKeyType.RawValue: CerealRepresentable {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateCereal(value: value) as DecodedValueType
        }

        return decodedItems
    }

    fileprivate static func parseCereal<DecodedKeyType: Hashable & CerealType, DecodedValueType: RawRepresentable & CerealRepresentable>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: DecodedValueType] where DecodedValueType.RawValue: CerealRepresentable {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, DecodedValueType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiateCereal(value: key)
            let decodedValue: DecodedValueType = try CerealDecoder.instantiate(value: value)
            decodedItems[decodedKey] = decodedValue
        }

        return decodedItems
    }

    fileprivate static func parseIdentifyingCereal<DecodedKeyType: RawRepresentable & Hashable & CerealRepresentable>(dictionary: CoderTreeValue) throws -> [DecodedKeyType: IdentifyingCerealType] where DecodedKeyType.RawValue: CerealRepresentable {
        guard case let .array(items) = dictionary else { throw CerealError.typeMismatch("\(dictionary) should be an Array of pairs (line \(#line))") }

        var decodedItems = Dictionary<DecodedKeyType, IdentifyingCerealType>(minimumCapacity: items.count)

        for item in items {
            guard case let .pair(key, value) = item else { throw CerealError.typeMismatch("\(item) not expected (line \(#line))") }
            let decodedKey: DecodedKeyType = try CerealDecoder.instantiate(value: key)
            decodedItems[decodedKey] = try CerealDecoder.instantiateIdentifyingCereal(value: value)
        }

        return decodedItems
    }

}
