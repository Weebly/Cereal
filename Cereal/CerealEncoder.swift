//
//  CerealEncoder.swift
//  Cereal
//
//  Created by James Richard on 8/3/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Foundation

/**
    A CerealEncoder handles encoding items into a format that can be stored in a simple format, such as NSData or String.
*/
public struct CerealEncoder {
    private var items = [String: String]()

    /**
    Initializes a `CerealEncoder` to store encoded data.
    */
    public init() { }

    /// Returns all the encoded items as a `String` object.
    public func toString() -> String {
        var encodedItems = [String]()

        for (key, item) in items {
            encodedItems.append("k,\(key.characters.count):\(key):\(item)")
        }

        let joined = encodedItems.joinWithSeparator(":")

        return joined
    }

    /// Returns all of the encoded items as an `NSData` object.
    public func toData() -> NSData {
        return toString().dataUsingEncoding(NSUTF8StringEncoding)!
    }

    // MARK: - Single items

    /**
    Encodes an object conforming to `CerealRepresentable` under `key`.
    
    - parameter     item:    The object being encoded.
    - parameter     key:     The key the object should be encoded under.
    */
    public mutating func encode<ItemType: CerealRepresentable>(item: ItemType?, forKey key: String) throws {
        guard let unwrapped = item else { return }
        items[key] = try encodeItem(unwrapped)
    }

    /**
    Encodes an object conforming to `IdentifyingCerealType` under `key`.

    - parameter     item:    The object being encoded.
    - parameter     key:     The key the object should be encoded under.
    */
    public mutating func encode(item: IdentifyingCerealType?, forKey key: String) throws {
        guard let unwrapped = item else { return }
        self.items[key] = try encodeItem(unwrapped)
    }

    // MARK: - Arrays

    /**
    Encodes an array of objects conforming to `CerealRepresentable` object under `key`.

    - parameter     items:   The objects being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemType: CerealRepresentable>(items: [ItemType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        self.items[key] = try encodeItems(unwrapped)
    }

    /**
    Encodes an array of objects conforming to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The objects being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems(items: [IdentifyingCerealType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        self.items[key] = try encodeIdentifyingItems(unwrapped)
    }

    // MARK: Arrays of Dictionaries

    /**
    Encodes an array of dictionaries where the key and value conform to `CerealRepresentable` object under `key`.

    - parameter     items:   The dictionaries being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [[ItemKeyType: ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        self.items[key] = try encodeItems(unwrapped)
    }

    /**
    Encodes an array of dictionaries where the keys conform to `CerealRepresentable` and values conform to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The dictionaries being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [[ItemKeyType: IdentifyingCerealType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        self.items[key] = try encodeItems(unwrapped)
    }

    // MARK: - Dictionaries

    /**
    Encodes a dictionary of keys and values conforming to `CerealRepresentable` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [ItemKeyType: ItemValueType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        self.items[key] = try encodeItems(unwrapped)
    }

    /**
    Encodes a dictionary of keys conforming to `CerealRepresentable` and values conforming to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: IdentifyingCerealType]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        self.items[key] = try encodeIdentifyingItems(unwrapped)
    }

    // MARK: Dictionaries of Arrays

    /**
    Encodes a dictionary of keys and arrays of values conforming to `CerealRepresentable` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key:     The key the objects should be encoded under.
    */
    public mutating func encode<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [ItemKeyType: [ItemValueType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        self.items[key] = try encodeItems(unwrapped)
    }

    /**
    Encodes a dictionary of keys conforming to `CerealRepresentable` and arrays of values conforming to `IdentifyingCerealType` object under `key`.

    - parameter     items:   The dictionary being encoded.
    - parameter     key     The key the objects should be encoded under.
    */
    public mutating func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: [IdentifyingCerealType]]?, forKey key: String) throws {
        guard let unwrapped = items else { return }
        self.items[key] = try encodeIdentifyingItems(unwrapped)
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

    private func encodeItem<ItemType: CerealRepresentable>(item: ItemType) throws -> String {
        
        switch item {
            
        case let value as Int :
            return "i,\(String(value).characters.count):\(value)"
            
        case let value as Int64 :
            return "z,\(String(value).characters.count):\(value)"
            
        case let value as String:
            return "s,\(value.characters.count):\(value)"
            
        case let value as Double :
            return "d,\(String(value).characters.count):\(value)"
            
        case let value as Float :
            return "f,\(String(value).characters.count):\(value)"
            
        case let value as Bool :
            return "b,1:\(value ? "t" : "f")"
            
        case let value as NSDate :
            let interval = value.timeIntervalSince1970
            return "t,\(String(interval).characters.count):\(interval)"
            
        case let value as IdentifyingCerealType :
            return try encodeItem(value)
            
        case let value as CerealType :
            
            var cereal = CerealEncoder()
            try value.encodeWithCereal(&cereal)
            let s = cereal.toString()
            
            let len = s.characters.count
            return "c,\(len):\(s)"
            
        default: throw CerealError.UnsupportedCerealRepresentable("Item \(item) not supported)")
        }
    }

    private func encodeItem(item: IdentifyingCerealType) throws -> String {
        var cereal = CerealEncoder()
        try item.encodeWithCereal(&cereal)
        let s = cereal.toString()
        let ident = item.dynamicType.initializationIdentifier
        let identLen = ident.characters.count
        let identLenLen = String(identLen).characters.count
        let encodedLength = s.characters.count
        let length = encodedLength + identLen + identLenLen + 2 // For the , and :

        return "p,\(length):\(identLen):\(ident):\(s)"
    }

    // MARK: Arrays of Dictionaries

    private func encodeItems<ItemType: CerealRepresentable>(items: [ItemType]) throws -> String {
        var encodedArrayItems = [String]()

        for obj in items {
            encodedArrayItems.append(try encodeItem(obj))
        }

        let combined = encodedArrayItems.joinWithSeparator(":")

        return "a,\(combined.characters.count):\(combined)"
    }

    private func encodeIdentifyingItems(items: [IdentifyingCerealType]) throws -> String {
        var encodedArrayItems = [String]()

        for obj in items {
            encodedArrayItems.append(try encodeItem(obj))
        }

        let combined = encodedArrayItems.joinWithSeparator(":")

        return "a,\(combined.characters.count):\(combined)"
    }

    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [[ItemKeyType: ItemValueType]]) throws-> String {
        var encodedArrayItems = [String]()

        for obj in items {
            encodedArrayItems.append(try encodeItems(obj))
        }

        let combined = encodedArrayItems.joinWithSeparator(":")

        return "a,\(combined.characters.count):\(combined)"
    }

    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [[ItemKeyType: IdentifyingCerealType]]) throws-> String {
        var encodedArrayItems = [String]()

        for obj in items {
            encodedArrayItems.append(try encodeItems(obj))
        }

        let combined = encodedArrayItems.joinWithSeparator(":")

        return "a,\(combined.characters.count):\(combined)"
    }

    // MARK: Dictionaries

    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [ItemKeyType: ItemValueType]) throws -> String {
        var encodedDictionaryItems = [String]()

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append("\(encodedKey):\(encodedValue)")
        }

        let combined = encodedDictionaryItems.joinWithSeparator(":")

        return "m,\(combined.characters.count):\(combined)"
    }

    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: IdentifyingCerealType]) throws -> String {
        var encodedDictionaryItems = [String]()

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append("\(encodedKey):\(encodedValue)")
        }

        let combined = encodedDictionaryItems.joinWithSeparator(":")

        return "m,\(combined.characters.count):\(combined)"
    }

    private func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: IdentifyingCerealType]) throws -> String {
        var encodedDictionaryItems = [String]()

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItem(value)
            encodedDictionaryItems.append("\(encodedKey):\(encodedValue)")
        }

        let combined = encodedDictionaryItems.joinWithSeparator(":")

        return "m,\(combined.characters.count):\(combined)"
    }

    // MARK: Dictionaries of Arrays
    private func encodeItems<ItemKeyType: protocol<CerealRepresentable, Hashable>, ItemValueType: CerealRepresentable>(items: [ItemKeyType: [ItemValueType]]) throws -> String {
        var encodedDictionaryItems = [String]()

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeItems(value)
            encodedDictionaryItems.append("\(encodedKey):\(encodedValue)")
        }

        let combined = encodedDictionaryItems.joinWithSeparator(":")

        return "m,\(combined.characters.count):\(combined)"
    }

    private func encodeIdentifyingItems<ItemKeyType: protocol<CerealRepresentable, Hashable>>(items: [ItemKeyType: [IdentifyingCerealType]]) throws -> String {
        var encodedDictionaryItems = [String]()

        for (key, value) in items {
            let encodedKey = try encodeItem(key)
            let encodedValue = try encodeIdentifyingItems(value)
            encodedDictionaryItems.append("\(encodedKey):\(encodedValue)")
        }

        let combined = encodedDictionaryItems.joinWithSeparator(":")

        return "m,\(combined.characters.count):\(combined)"
    }

}
