//
//  Utilities.swift
//  Cereal
//
//  Created by James Richard on 10/12/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

/**
Force casts the contents of a [[Key: Value]] into an expected return type. This is necessary because
you cannot return a [[Key: IdentifyingCerealType]] to a subprotocol of IdentifyingCerealType.

- parameter     sequence:   The sequence to be casted
- returns:      The casted copy
*/
public func deepCast<KeyType: Hashable, ValueType, CastedType>(_ sequence: [[KeyType: ValueType]]) -> [[KeyType: CastedType]] {
    return sequence.map {
        return $0.reduce([KeyType: CastedType]()) { memo, object in
            var memo = memo
            memo[object.0] = (object.1 as! CastedType)
            return memo
        }
    }
}

/**
Force casts the contents of a [Key: [Value]] into an expected return type. This is necessary because
you cannot return a [Key: [IdentifyingCerealType]] to a subprotocol of IdentifyingCerealType.

- parameter     sequence:   The sequence to be casted
- returns:      The casted copy
*/
public func deepArrayCast<KeyType: Hashable, ValueType, CastedType>(_ sequence: [KeyType: [ValueType]]) -> [KeyType: [CastedType]] {
    return sequence.reduce([KeyType: [CastedType]]()) { memo, object in
        var memo = memo
        memo[object.0] = object.1.CER_casted()
        return memo
    }
}
