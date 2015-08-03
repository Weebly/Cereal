//
//  ArrayExtensions.swift
//  Cereal
//
//  Created by James Richard on 8/20/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

extension Array {
    /**
    Force casts the contents of the Array into an expected return type. This is necessary because
    you cannot return a [IdentifyingCerealType] to a subprotocol of IdentifyingCerealType.
    
    - returns:      The casted copy
    */
    public func CER_casted<CastedType>() -> [CastedType] {
        return map { $0 as! CastedType }
    }
}
