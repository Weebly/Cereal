//
//  Utilities.swift
//  Cereal
//
//  Created by James Richard on 10/12/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Foundation

/**
Force casts the contents of a [[Key: Value]] into an expected return type. This is necessary because
you cannot return a [[Key: IdentifyingCerealType]] to a subprotocol of IdentifyingCerealType.

- parameter     sequence:   The sequence to be casted
- returns:      The casted copy
*/
public func deepCast<KeyType: Hashable, ValueType, CastedType>(sequence: [[KeyType: ValueType]]) -> [[KeyType: CastedType]] {
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
public func deepArrayCast<KeyType: Hashable, ValueType, CastedType>(sequence: [KeyType: [ValueType]]) -> [KeyType: [CastedType]] {
    return sequence.reduce([KeyType: [CastedType]]()) { memo, object in
        var memo = memo
        memo[object.0] = object.1.CER_casted()
        return memo
    }
}

private extension dispatch_queue_t {
    func sync(specificKey: UnsafePointer<Void>?, block: dispatch_block_t) {
        if let key = specificKey where dispatch_get_specific(key) != nil {
            block()
        } else {
            dispatch_sync(self, block)
        }
    }

    @warn_unused_result
    func assignSpecificKey() -> UnsafePointer<Void> {
        let opPtr = Unmanaged <dispatch_queue_t>.passUnretained(self).toOpaque()
        let result = UnsafeMutablePointer<Void>(opPtr)
        dispatch_queue_set_specific(self, result, result, nil)

        return UnsafePointer<Void>(result)
    }
}

/**
 Helper wrapper class that provides thread-safe access to a wrapping values 
 */
internal class SyncHolder<Type> {
    private(set) var values = [Type]()

    private let valueReadQueue = dispatch_queue_create("Cereal Queue", DISPATCH_QUEUE_SERIAL)
    private lazy var specificKey: UnsafePointer<Void> = self.valueReadQueue.assignSpecificKey()

    final func sync(block: () -> ()) {
        self.valueReadQueue.sync(self.specificKey, block: block)
    }
    final func appendData(newData: Type) {
        self.sync {
            self.values.append(newData)
        }
    }
}