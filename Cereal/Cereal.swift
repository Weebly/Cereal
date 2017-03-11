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
public enum CerealError: Error {
    /** 
    Thrown when an item is encoded incorrectly. This can happen if a `CerealType` (but not `IdentifyingCerealType`)
    is used when for a non-generic method.
    */
    case invalidEncoding(String)

    /**
    Thrown if an item is attempted to be encoded as a `CerealRepresentable` but isn't an handled by Cereal internally.
    You should never conform a type to `CerealRepresentable`; only its subprotocols `CerealType` and 
    `IdentifyingCerealType`.
    */
    case unsupportedCerealRepresentable(String)

    /**
    Thrown if an `IdentifyingCerealType` was attempted to be decoded, but wasn't registered beforehand.
    
    You register `IdentifyingCerealType`s with `Cereal.register(_: IdentifyingCerealType.Type)`.
    */
    case unregisteredCustomType(String)

    /// Thrown if a root item is attempted to be decoded that doesn't exist.
    case rootItemNotFound

    /// Thrown if a decoder couldn't be decoded from the specified data
    case invalidDataContent

    /// Thrown when expected to be decoded from another type
    case typeMismatch(String)
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
public func register(_ identifyingCerealType: IdentifyingCerealType.Type) {
    identifierMap[identifyingCerealType.initializationIdentifier] = identifyingCerealType
}

func identifyingCerealTypeWithIdentifier(_ identifier: String) throws -> IdentifyingCerealType.Type {
    guard let t = identifierMap[identifier] else {
        throw CerealError.unregisteredCustomType("Type with identifier \(identifier) not found")
    }

    return t
}

/// Used for testing to reset the state of Cereal's registered types.
func clearRegisteredCerealTypes() {
    identifierMap.removeAll()
}
