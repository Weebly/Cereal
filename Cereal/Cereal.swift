//
//  Cereal.swift
//  Cereal
//
//  Created by James Richard on 7/24/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

var identifierMap = [String: IdentifyingCerealType.Type]()
let rootKey = "root"

/// The error type used for encoding and decoding within Cereal.
public enum CerealError: ErrorType {
    /** 
    Thrown when an item is encoded incorrectly. This can happen if a `CerealType` (but not `IdentifyingCerealType`)
    is used when for a non-generic method.
    */
    case InvalidEncoding(String)

    /// Thrown when the structure of an encoded item is incorrect.
    case UnsupportedKeyLengthValue

    /// Thrown when the structure of an encoded item is incorrect.
    case ValueLengthEndNotFound

    /// Thrown when the structure of an encoded item is incorrect.
    case UnsupportedValueLengthValue

    /**
    Thrown if an item is attempted to be encoded as a `CerealRepresentable` but isn't an handled by Cereal internally.
    You should never conform a type to `CerealRepresentable`; only its subprotocols `CerealType` and 
    `IdentifyingCerealType`.
    */
    case UnsupportedCerealRepresentable(String)

    /**
    Thrown if an `IdentifyingCerealType` was attempted to be decoded, but wasn't registered beforehand.
    
    You register `IdentifyingCerealType`s with `Cereal.register(_: IdentifyingCerealType.Type)`.
    */
    case UnregisteredCustomType(String)

    /// Thrown if a root item is attempted to be decoded that doesn't exist.
    case RootItemNotFound

    /// Thrown if a decoder couldn't be decoded from the specified data
    case InvalidDataContent
}

/**
Register a type for runtime lookup. If you are decoding types that conform to `IdentifyingCerealType`, and are
encoding them using a non-generic encoding and decoding method, you must register it. At runtime the type
will be asked for the initializationIdentifier and lookup registered types. If the type isn't registered, 
a CerealError.UnregisteredCustomType error will be thrown.

To use this method, you pass the `self` of the type. For example:

```
Cereal.register(Fooable.self)
```

- parameter identifyingCerealType:  The type being registered.
*/
public func register(identifyingCerealType: IdentifyingCerealType.Type) {
    identifierMap[identifyingCerealType.initializationIdentifier] = identifyingCerealType
}

func identifyingCerealTypeWithIdentifier(identifier: String) throws -> IdentifyingCerealType.Type {
    guard let t = identifierMap[identifier] else {
        throw CerealError.UnregisteredCustomType("Type with identifier \(identifier) not found")
    }

    return t
}

/// Used for testing to reset the state of Cereal's registered types.
func clearRegisteredCerealTypes() {
    identifierMap.removeAll()
}
