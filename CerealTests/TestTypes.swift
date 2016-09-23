//
//  TestTypes.swift
//  Cereal
//
//  Created by James Richard on 8/3/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Cereal

struct TestCerealType: CerealType {
    var foo: String

    init(decoder: CerealDecoder) throws {
        foo = try decoder.decode(key: "foo") ?? ""
    }

    init(foo: String) {
        self.foo = foo
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(foo, forKey: "foo")
    }
}

extension TestCerealType: Hashable {
    var hashValue: Int {
        return foo.hashValue
    }
}

func == (lhs: TestCerealType, rhs: TestCerealType) -> Bool {
    return lhs.foo == rhs.foo
}

struct OptionalTestCerealType: CerealType {
    var foo: String?

    init(decoder: CerealDecoder) throws {
        foo = try decoder.decode(key: "foo")
    }

    init(foo: String?) {
        self.foo = foo
    }

    init() { }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        if let f = foo {
            try cereal.encode(f, forKey: "foo")
        }
    }
}

struct TestMultiCerealType: CerealType {
    var foo: String
    var bar: String

    init(decoder: CerealDecoder) throws {
        foo = try decoder.decode(key: "foo") ?? ""
        bar = try decoder.decode(key: "bar") ?? ""
    }

    init(foo: String, bar: String) {
        self.foo = foo
        self.bar = bar
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(foo, forKey: "foo")
        try cereal.encode(bar, forKey: "bar")
    }
}

struct Stack<Element: CerealRepresentable>: CerealType {
    var items: [Element]

    init(decoder: CerealDecoder) throws {
        items = try decoder.decode(key: "foo") ?? []
    }

    init() {
        items = [Element]()
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(items, forKey: "foo")
    }

    mutating func push(_ element: Element) {
        items.append(element)
    }
}

struct TestIdentifyingCerealType: Fooable {
    var foo: String

    init(decoder: CerealDecoder) throws {
        foo = try decoder.decode(key: "foo") ?? ""
    }

    init(foo: String) {
        self.foo = foo
    }

    var hashValue: Int {
        return foo.hashValue
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(foo, forKey: "foo")
    }

    static var initializationIdentifier: String {
        return "tict"
    }
}

extension TestIdentifyingCerealType: Hashable { }

protocol Fooable: IdentifyingCerealType {
    var foo: String { get }
}

func == (lhs: TestIdentifyingCerealType, rhs: TestIdentifyingCerealType) -> Bool {
    return lhs.foo == rhs.foo
}

protocol Barable: IdentifyingCerealType, Hashable {
    var bar: String { get }
}

struct MyBar: Barable {
    var bar: String

    init(decoder: CerealDecoder) throws {
        bar = try decoder.decode(key: "bar") ?? ""
    }

    init(bar: String) {
        self.bar = bar
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(bar, forKey: "bar")
    }

    var hashValue: Int {
        return bar.hashValue
    }

    static let initializationIdentifier = "MyBar"
}

func == (lhs: MyBar, rhs: MyBar) -> Bool {
    return lhs.bar == rhs.bar
}

struct BarBag<Bar: Barable>: IdentifyingCerealType {
    var theBar: Bar

    init(decoder: CerealDecoder) throws {
        if let value = try decoder.decodeIdentifyingCereal(key: "bar") as? Bar {
            theBar = value
        } else {
            throw CerealError.invalidEncoding("Not able to decode")
        }
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(theBar, forKey: "bar")
    }

    static var initializationIdentifier: String {
        return "\(Bar.initializationIdentifier)-barbag"
    }
}

protocol Bazable: IdentifyingCerealType {
    var baz: String { get }
}

struct MyBaz: Bazable {
    var baz: String

    init(decoder: CerealDecoder) throws {
        baz = try decoder.decode(key: "baz") ?? ""
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(baz, forKey: "baz")
    }

    static let initializationIdentifier = "MyBaz"
}

// Extending objects with CerealRepresentable is not supported, so this will be used to test
// that if it is, the correct error is used.
extension Data: CerealRepresentable { }

enum TestEnum: String {
    case TestCase1
    case TestCase2
}

extension TestEnum: CerealRepresentable { }

struct TestSetType : OptionSet {
    let rawValue: Int

    static let None         = TestSetType(rawValue: 0)
    static let FirstOption  = TestSetType(rawValue: 1 << 0)
    static let SecondOption = TestSetType(rawValue: 1 << 1)
    static let ThirdOption  = TestSetType(rawValue: 1 << 2)
}

extension TestSetType: CerealRepresentable { }
