//
//  DictionaryExtensions.swift
//  Cereal
//
//  Created by James Richard on 10/9/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

extension Dictionary {
    /**
    Force casts the contents of the Dictionary's values into an expected return type. This is necessary because
    you cannot return a [String: IdentifyingCerealType] to a subprotocol of IdentifyingCerealType.
    
    - returns:      The casted copy
    */
    public func CER_casted<CastedType>() -> [Key: CastedType] {
        return reduce([Key: CastedType]()) { memo, object in
            var memo = memo
            memo[object.0] = (object.1 as! CastedType)
            return memo
        }
    }
}
