Cereal is a serialization framework built for Swift. Its intended as a substitution for NSCoding to allow
advanced Swift features. With NSCoding, you cannot encode or decode a Swift struct, enum, or generic class. Cereal
solves this issue through deferred decoding with generics, and a protocol that doesn't depend on NSObjectProtocol.

Please note that the data stored in Cereal 2.0 is different from Cereal 1.3, and while the API is the same they are not compatible. Do not expect data written by 1.3 to be readable by 2.0.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


# Features

* Encode and decode String, Bool, Int, Int64, Float, Double, NSDate and NSURL
* Encode and decode Arrays, Arrays of Dictionaries, Dictionaries, and Dictionaries of Arrays
* Encode and decode your own ```enum``` types
* Encode and decode your own ```struct``` types
* Encode and decode your own ```class``` types, even if they don't inherit from NSObject
* Encode and decode as a ```protocol```
* Encode and decode types with generics
* Encode and decode `RawRepresentable` types, whose RawValue's are also encodable/decodable
* Enforce decoding of the same type as encoded with
* Comprehensive test suite

# Requirements

* iOS 8.0+ / Mac OS X 10.9 / watchOS 2
* Xcode 7.0+ (7.1 for CocoaPods w/ Watch OS 2)

# Installation

## CocoaPods

CocoaPods is a dependency manager for Cocoa projects that handles much of the integration for you.

CocoaPods 0.38 is required to integrate Cereal into basic projects; if you'd like to include Cereal in 
both your watchOS target and iOS target, you'll need to use 0.39 to resolve a bug.

### Basic integration

For basic integration, add this to your Podfile:

```
pod 'Cereal', '~> 2.0'
```

### Multiple Targets

If you want to incorporate Cereal with your watchOS target and your iOS target, you'll need something like this:

```ruby
def shared_pods 
  pod 'Cereal', '~> 2.0'
end

target :"iOS App Target" do
    platform :ios, '8.0'
    shared_pods
end

target :"watchOS Extension Target" do
    platform :watchos, '2.0'
    shared_pods
end
```

## Carthage

Carthage is a decentralized dependency manager. Add the following to your Cartfile to build Cereal:

```
github "Weebly/Cereal" ~> 1.3.0
```

## Manually

If you'd like to add Cereal to your project manually you can copy the .swift files contained in the Cereal directory into
your project and have them compile on all the necessary targets.

# Usage

Cereal works similarly to NSKeyedArchiver. For encoding, you create a CerealEncoder, and encode the objects you'd
like stored in the resulting data. Here is an example of encoding various primitive types:

```swift
var encoder = CerealEncoder()
try encoder.encode(5, forKey: "myInt")
try encoder.encode([1,2,3], forKey: "myIntArray")
try encoder.encode(["Hello,", "World!"], forKey: "myStringArray")
try encoder.encode(["Foo": "Bar"], forKey: "myStringToStringDictionary")
let data = encoder.toData()
```

From there you can store your data anywhere you'd like; be it state restoration, user defaults, to a file, or
communicating to the users watch with WatchConnectivity. To decode the object on the other end:

```swift
let decoder = CerealDecoder(data: data)
let myInt: Int? = try decoder.decode("myInt")
let myIntArray: [Int]? = try decoder.decode("myIntArray")
let myStringArray: [String]? = try decoder.decode("myStringArray")
let myStringToStringDictionary: [String: String]? = try decoder.decode("myStringToStringDictionary")
```

Due to the complexity of generic code used with dictionaries and arrays, you cannot deeply nest 
dictionaries/arrays into themselves. However, support for dictionaries of arrays and arrays of 
dictionaries are included. I strongly recommend you serialize your own custom types instead of dictionaries 
whenever possible. Here is an example from our example iOS project:


```swift
// employees is a [Employee]; Employee is a Swift struct.
let data = try CerealEncoder.data(withRoot: employees) // Returns an Data object
```

And to decode that data


```swift
do {
    employees = try CerealDecoder.rootCerealItems(with: storedEmployeeData)
} catch let error {
    NSLog("Couldn't decode employees due to error: \(error)")
}
```

The above examples are using a shorthand to encode and decode at the root level. Typically you encode items to a particular
key.

## Serializing your concrete types

Your custom types should adopt CerealType (or its subprotocol, IdentifyingCerealType) to be encoded
and decoded. Here is the Employee struct:

```swift
struct Employee {
    var name = ""
    var age = 18
    var gender: Gender = .Female

    init() { }
}

extension Employee: CerealType {
    private struct Keys {
        static let name = "name"
        static let age = "age"
        static let gender = "gender"
    }

    init(cereal: CerealDecoder) throws {
        name = try cereal.decode(Keys.name) ?? ""
        age = try cereal.decode(Keys.age) ?? 0
        gender = try cereal.decodeCereal(Keys.gender) ?? .Female
    }

    func encodeWithCereal(inout cereal: CerealEncoder) throws {
        try cereal.encode(name, forKey: Keys.name)
        try cereal.encode(age, forKey: Keys.age)
        try cereal.encode(gender, forKey: Keys.gender)
    }
}
```

You may notice above that there are two decoding methods; decode and decodeCereal. This is because the compiler
cannot tell which version of decode to use just from the return type (since primitives and custom types must conform
to CerealRepresentable, our internal protocol which should not be conformed to in your code), so there are a few different methods for decoding.

## Serializing your protocols

Protocol-Oriented Programming was a concept Cereal had to support out of the box. Protocols don't give instantiatable
type data for our generic decoders, though, so we needed a way to identify the concrete type under the protocol abstraction.

In order for your types to support encoding behind a protocol we register the concrete type using ```Cereal.register```, which
takes the .Type of your type. Here's an example of a protocol-oriented type:

```swift
protocol Vehicle: IdentifyingCerealType {
    var make: String { get }
    var model: String { get }
    var description: String { get }
}

// Used for other implementers of Vehicle
private struct SharedKeys {
    static let make = "make"
    static let model = "model"
}

enum VehicleError: ErrorType {
    case MissingData
}

struct Car: Vehicle {
    private struct Keys {
        static let cylinders = "cylinders"
    }

    let make: String
    let model: String
    let cylinders: Int

    var description: String {
        return "\(model) by \(make) w/ \(cylinders) cylinders"
    }

    static let initializationIdentifier = "car"

    init(cereal: CerealDecoder) throws {
        guard let make: String = try cereal.decode(SharedKeys.make) else { throw VehicleError.MissingData }
        self.make = make

        guard let model: String = try cereal.decode(SharedKeys.model) else { throw VehicleError.MissingData }
        self.model = model

        guard let cylinders: Int = try cereal.decode(Keys.cylinders) else { throw VehicleError.MissingData }
        self.cylinders = cylinders
    }

    init(make: String, model: String, cylinders: Int) {
        self.make = make
        self.model = model
        self.cylinders = cylinders
    }

    func encodeWithCereal(inout cereal: CerealEncoder) throws {
        try cereal.encode(make, forKey: SharedKeys.make)
        try cereal.encode(model, forKey: SharedKeys.model)
        try cereal.encode(cylinders, forKey: Keys.cylinders)
    }
}

// This is where the magic happens!
Cereal.register(Car.self)
```

Phew! Thats how we can create an object to use in protocol referenced decoding, but how do we actually decode and encode it?

```swift
let vehicle: Vehicle = Car(make: "Foo", model: "Bar", cylinders: 8)

// Encoding
let encoder = CerealEncoder()
try encoder.encode(vehicle, forKey: "vehicle")

// Decoding
let decoder = CerealDecoder(data: encoder.toData())
let decodedVehicle: Vehicle = try decoder.decodeCereal("vehicle") as! Vehicle
```

### Secure decoding with IdentifyingCerealType

In addition to allowing you to encode and decode protocols, you can use IdentifyingCerealType as a method to
ensure the same type gets decoded as was encoded.

### Handling dictionaries and arrays with protocol types

When working with protocol collections, such as [Vehicle], the compiler has issues encoding and decoding the types. To support
these theres an extension on Array and Dictionary, ```CER_casted()``` which will cast the type into the appropriately expected type:

```swift
let decoder = try CerealDecoder(data: storedVehicleData)
let vehicles: [Vehicles] = try decoder.decodeIdentifyingCerealArray("vehicles")?.CER_casted() ?? []
```

Encoding requires a similar treatment:

```swift
var encoder = CerealEncoder()
try encoder.encodeIdentifyingItems(vehicles.CER_casted(), forKey: "vehicles")
```

There's also ```deepCast(_: [[KeyType: ValueType])``` and ```deepArrayCast(_: [KeyType: [ValueType])``` to handle arrays of dictionaries and dictionaries of arrays, respectively.

## Serializing generics

Your generic types work the same was as the other serializable types. However, your generic types should 
constrain to CerealRepresentable:

```swift
struct Stack<ItemType: CerealRepresentable>: CerealType {
    private items: [ItemType]
    // ... rest of the implementation ...
}
```

From there you can encode and decode the object using the same methods.

### Registering generic types

If your generic type is using IdentifyingCerealType you'll need to register the specialization in Cereal so it knows how to properly initialize your type. For example, if Stack had conformed to IdentifyingCerealType:

```swift
Cereal.register(Stack<Int>.self)
```

When you implement initializationIdentifier in your generic type it should also be based on the generic:

```swift
struct Stack<ItemType: CerealRepresentable>: IdentifyingCerealType {
    static var initializationIdentifier: String {
        return "Stack-\(ItemType.self)"
    }
    // ... rest of the implementation ...
}
```

## RawRepresentable support

Adding serialization to `RawRepresentable` types never been easier, since they may be represented with their raw value.
So, if you have an enum, or option set with a raw value of type that supports `CerealRepresentable` (like `String`, `Bool`, `Int`), then all you have to do is to add `CerealRepresentable` conformance to your `RawRepresentable` type and you're done.
For example this `RawRepresentable` types:

```swift
enum Gender: Int {
    case Female
    case Male
}

struct EmployeeResponsibilites : OptionSetType {
    let rawValue: Int

    static let None           = OptionSet(rawValue: 0)
    static let CleanWorkplace = OptionSet(rawValue: 1 << 0)
    static let OpenWindow     = OptionSet(rawValue: 1 << 1)
    static let BringCofee     = OptionSet(rawValue: 1 << 2)
}
```

may be easily encoded and decoded by just adding `CerealRepresentable` conformance:

```swift
extension Gender: CerealRepresentable {}
extension EmployeeResponsibilites: CerealRepresentable {}
```

And encode/decode may looks something like this:
```swift
struct Employee {
    var gender: Gender = .Female
    var responsibilities: EmployeeResponsibilites = [.CleanWorkplace, .OpenWindow]
    init() { }
}

extension Employee: CerealType {
    private struct Keys {
        static let gender = "gender"
        static let responsibility = "responsibility"
    }

    init(decoder: CerealDecoder) throws {
        gender = try decoder.decode(Keys.gender) ?? .Female
        responsibility = try decoder.decode(Keys.responsibility) ?? .None
    }

    func encodeWithCereal(inout cereal: CerealEncoder) throws {
        try cereal.encode(gender, forKey: Keys.gender)
        try cereal.encode(responsibility, forKey: Keys.responsibility)
    }
}
```

## Further reading

There are a lot of permutations that can be done with Cereal. I strongly encourage you to read the API, and if you have any questions about usage, check out our comprehensive test suite. It covers everything.

# LICENSE

Copyright (c) 2015, Weebly All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. Neither the name of Weebly nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Weebly, Inc BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



