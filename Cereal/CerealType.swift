//
//  CerealType.swift
//  Cereal
//
//  Created by James Richard on 7/24/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

/**
This is the root protocol for all types that can be handled by Cereal. Your types should not conform to it; instead,
they should conform to `CerealType` or `IdentifyingCerealType`. If your types conform just to `CerealRepresentable`
they will throw an error during encoding.
*/
public protocol CerealRepresentable { }

/**
A `CerealType` is a type that can be encoded and decoded using any of Cereal's generic encode and decode methods.
*/
public protocol CerealType: CerealRepresentable {

    /**
    Initializes with a `CerealDecoder`. All the required instantiation data will live within the
    decoder, and is generally from the `encodeWithCereal(_: CerealEncoder)` method that is also part of this protocol.
    
    - parameter     decoder:     The `CerealDecoder` containing the data to decode the object.
    */
    init(decoder: CerealDecoder) throws

    /**
    Encodes the object into the passed in `CerealEncoder`. 
    
    - parameter     encoder:    The `CerealDecoder` to encode into.
    */
    func encodeWithCereal(inout encoder: CerealEncoder) throws
}

/**
A `IdentifyingCerealType` is a type that can be encoded and decoded using any of Cereal's non-generic encode and decode
methods. This means that Cereal doesn't need the compile-time type information. Instead, these types are looked up
at runtime through types registered with `Cereal.register(_: IdentifyingCerealType)`. 

By using runtime types you can encode protocol types instead. For example, if you had a protocol `Fooable` that inherited
from `IdentifyingCerealType`, you could encode an array of `Fooable` types; each a different concrete type that is then
determined at runtime.
*/
public protocol IdentifyingCerealType: CerealType {
    /**
    The identifier used for looking up the type after it has been registered. This value
    should be unique within your program, and must be the same between process launches
    for the same type.
    
    If your type contains a generic, you must incorporate that generic into this identifier,
    and register each potential generic variation, as they are unique types that need
    to be instantiated in a specific manor.
    */
    static var initializationIdentifier: String { get }
}
