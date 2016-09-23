//
//  CerealDecoderTests.swift
//  Cereal
//
//  Created by James Richard on 8/3/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import XCTest
@testable import Cereal

class CerealDecoderTests: XCTestCase {

    override func tearDown() {
        Cereal.clearRegisteredCerealTypes()
        super.tearDown()
    }

    func testDecodingEmptyEncodingData_isOkay() {
        do {
            _ = try CerealDecoder(encodedString: "")
        } catch {
            XCTFail("Couldn't decode an empty string")
        }
    }

    // MARK: - Primitives

    func testDecodingString() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:s,5:hello")
            let result: String = try subject.decode(key: "test") ?? ""
            XCTAssertEqual(result, "hello")
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingEmptyString() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:s,0:")
            let result: String = try subject.decode(key: "test") ?? "derp"
            XCTAssertEqual(result, "")
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingBool() {
        do {
            let subject = try CerealDecoder(encodedString: "k,5:btest:b,1:t")
            let resultBool: Bool = try subject.decode(key: "btest") ?? false
            XCTAssertEqual(resultBool, true)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingInt() {
        do {
            let subject = try CerealDecoder(encodedString: "k,5:itest:i,5:10000")
            let resultInt: Int = try subject.decode(key: "itest") ?? 0
            XCTAssertEqual(resultInt, 10000)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingInt64() {
        do {
            let subject = try CerealDecoder(encodedString: "k,5:itest:z,10:1000000000")
            let resultInt: Int64 = try subject.decode(key: "itest") ?? 0
            XCTAssertEqual(resultInt, 1000000000)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingDouble() {
        do {
            let subject = try CerealDecoder(encodedString: "k,5:dtest:d,7:123.456")
            let resultDouble: Double = try subject.decode(key: "dtest") ?? 0.0
            XCTAssertEqual(resultDouble, 123.456)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingFloat() {
        do {
            let subject = try CerealDecoder(encodedString: "k,5:ftest:f,7:123.456")
            let resultFloat: Float = try subject.decode(key: "ftest") ?? 0.0
            XCTAssertEqual(resultFloat, 123.456)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingDate() {
        do {
            let subject = try CerealDecoder(encodedString: "k,5:dtest:t,4:10.0")
            let resultDate: Date = try subject.decode(key: "dtest") ?? Date()
            XCTAssertEqual(resultDate, Date(timeIntervalSince1970: 10.0))
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingPreciseDate() {
        do {
            let date = Date(timeIntervalSinceReferenceDate: TimeInterval(String(72169399.35149699))!)
            let dateString = String(date.timeIntervalSinceReferenceDate)
            let subject = try CerealDecoder(encodedString: "k,5:dtest:T,\(dateString.characters.count):\(dateString)")
            let resultDate: Date = try subject.decode(key: "dtest") ?? Date()
            XCTAssertEqual(resultDate, Date(timeIntervalSinceReferenceDate: 72169399.35149699))
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingCurrentDate() {
        do {
            let date = Date()
            let dateString = String(date.timeIntervalSinceReferenceDate)
            let subject = try CerealDecoder(encodedString: "k,5:dtest:T,\(dateString.characters.count):\(dateString)")
            let resultDate: Date = try subject.decode(key: "dtest") ?? Date()
            XCTAssertEqual(resultDate, date)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingDate_withNegativeInterval() {
        do {
            let subject = try CerealDecoder(encodedString: "k,5:dtest:t,5:-10.0")
            let resultDate: Date = try subject.decode(key: "dtest") ?? Date()
            XCTAssertEqual(resultDate, Date(timeIntervalSince1970: -10.0))
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }
    
    func testDecodingURL() {
        do {
            let subject = try CerealDecoder(encodedString: "k,5:dtest:u,18:http://testing.com")
            let resultURL: URL = try subject.decode(key: "dtest")!
            XCTAssertEqual(resultURL, URL(string: "http://testing.com"))
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingMultiplePrimitives() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:s,5:hello:k,5:itest:i,5:10000")
            let result: String = try subject.decode(key: "test") ?? ""
            let resultInt: Int = try subject.decode(key: "itest") ?? 0
            XCTAssertEqual(result, "hello")
            XCTAssertEqual(resultInt, 10000)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: RawRepresentable

    func testDecodingStringEnum() {
        do {
            let subject = try CerealDecoder(encodedString: "k,8:enumtest:s,9:TestCase2")
            let resultEnum: TestEnum = try subject.decode(key: "enumtest") ?? .TestCase1
            XCTAssertEqual(resultEnum, TestEnum.TestCase2)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingIntOptionSet() {
        do {
            let subject = try CerealDecoder(encodedString: "k,13:optionsettest:i,1:3")
            let resultOptions: TestSetType = try subject.decode(key: "optionsettest") ?? []
            XCTAssertEqual(resultOptions, [TestSetType.FirstOption, TestSetType.SecondOption])
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: - Custom Types

    func testDecoding_withCereal() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:c,15:k,3:foo:s,3:bar")
            if let result: TestCerealType = try subject.decodeCereal(key: "test") {
                XCTAssertEqual(result.foo, "bar")
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withMultipleCerealItems() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:c,15:k,3:foo:s,3:bar:k,4:jest:c,15:k,3:foo:s,3:baz")
            if let result: TestCerealType = try subject.decodeCereal(key: "test") {
                XCTAssertEqual(result.foo, "bar")
            } else {
                XCTFail("Expected key was not found")
            }

            if let result: TestCerealType = try subject.decodeCereal(key: "jest") {
                XCTAssertEqual(result.foo, "baz")
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withGenericCereal() {
        do {
            let subject = try CerealDecoder(encodedString: "k,6:custom:c,24:k,3:foo:a,11:i,1:5:i,1:2")
            if let stack: Stack<Int> = try subject.decodeCereal(key: "custom") {
                XCTAssertEqual(stack.items, [5,2])
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCereal_usingUnusedKey_returnsNil() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:c,15:k,3:foo:s,3:bar")
            let result: TestCerealType? = try subject.decodeCereal(key: "testage")
            XCTAssert(result == nil)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCereal_forProtocol() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:p,22:4:tict:k,3:foo:s,3:bar")
            if let result = try subject.decodeIdentifyingCereal(key: "test") as? Fooable {
                XCTAssertEqual(result.foo, "bar")
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCereal_forStructContainingProtocolWithSelfRequirements() {
        Cereal.register(BarBag<MyBar>.self)
        Cereal.register(MyBar.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:p,52:12:MyBar-barbag:k,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz")
            if let result = try subject.decodeIdentifyingCereal(key: "test") as? BarBag<MyBar> {
                XCTAssertEqual(result.theBar.bar, "baz")
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - General Error Handling

    func testDecoding_withInvalidStart_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedString: ",4:test:s,5:hello")
            let s: String? = try subject.decode(key: "test")
            XCTFail("Expected an error, but decoded: \(s)")
        } catch CerealError.invalidEncoding {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    func testDecoding_withoutKeyEnd_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4;test;s,5;hello")
            let s: String? = try subject.decode(key: "test")
            XCTFail("Expected an error, but decoded: \(s)")
        } catch CerealError.invalidEncoding {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    func testDecoding_withIncorrectKeyLengthValue_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedString: "k,four:test:s,5:hello")
            let s: String? = try subject.decode(key: "test")
            XCTFail("Expected an error, but decoded: \(s)")
        } catch CerealError.unsupportedKeyLengthValue {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    func testDecoding_withIncorrectTypeIdentifier_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:9,5:hello")
            let s: String? = try subject.decode(key: "test")
            XCTFail("Expected an error, but decoded: \(s)")
        } catch CerealError.invalidEncoding {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    func testDecoding_withInvalidDeferredType_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:a,5:hello")
            let object: TestCerealType? = try subject.decodeCereal(key: "test")
            XCTFail("Expected an error, but decoded: \(object)")
        } catch CerealError.invalidEncoding {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    func testDecoding_withCustomType_usingArrayEncoded_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:a,9:s,5:hello")
            let object: TestCerealType? = try subject.decodeCereal(key: "test")
            XCTFail("Expected an error, but decoded: \(object)")
        } catch CerealError.invalidEncoding {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    func testDecoding_withArrayEncoded_usingInvalidType_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:a,9:s,5:hello")
            let object: [Int]? = try subject.decode(key: "test")
            XCTFail("Expected an error, but decoded: \(object)")
        } catch CerealError.invalidEncoding {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    func testDecoding_withArrayEncoded_usingUnexpectedCerealType_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:a,9:9,5:hello")
            let object: [Int]? = try subject.decode(key: "test")
            XCTFail("Expected an error, but decoded: \(object)")
        } catch CerealError.invalidEncoding {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    // MARK: - Root Items

    func testRootItemWithData_forPrimitive_returnsCorrectData() {
        do {
            var encoder = CerealEncoder()
            try encoder.encode("testing", forKey: rootKey)
            let subject: String = try CerealDecoder.rootItem(with: encoder.toData())

            XCTAssertEqual(subject, "testing")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_forCerealType_returnsCorrectData() {
        do {
            let object = TestCerealType(foo: "test")
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: TestCerealType = try CerealDecoder.rootCerealItem(with: encoder.toData())
            XCTAssertEqual(subject, object)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_forProtocoledIdentifyingCerealType_returnsCorrectData() {
        do {
            Cereal.register(TestIdentifyingCerealType.self)
            let object: Fooable = TestIdentifyingCerealType(foo: "baz")
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            guard let subject: Fooable = try CerealDecoder.rootIdentifyingCerealItem(with: encoder.toData()) as? Fooable else {
                XCTFail("Encoded type did not decode the same way")
                return
            }
            XCTAssertEqual(subject.foo, object.foo)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withPrimitiveArray_returnsCorrectData() {
        do {
            let object = ["foo", "bar"]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [String] = try CerealDecoder.rootItems(with: encoder.toData())
            XCTAssertEqual(subject, object)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withCerealTypeArray_returnsCorrectData() {
        do {
            let object = [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [TestCerealType] = try CerealDecoder.rootCerealItems(with: encoder.toData())
            XCTAssertEqual(subject, object)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_forProtocoledIdentifyingCerealTypeArray_returnsCorrectData() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let object: [Fooable] = [TestIdentifyingCerealType(foo: "bar"), TestIdentifyingCerealType(foo: "baz")]
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(object.CER_casted(), forKey: rootKey)
            let subject: [Fooable] = try CerealDecoder.rootIdentifyingCerealItems(with: encoder.toData()).CER_casted()
            XCTAssertEqual(subject[0].foo, object[0].foo)
            XCTAssertEqual(subject[1].foo, object[1].foo)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withArrayOfPrimitiveToPrimitiveDictionary_returnsCorrectData() {
        do {
            let object = [["Foo": 1], ["Bar": 2]]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [[String: Int]] = try CerealDecoder.rootItems(with: encoder.toData())
            for (i, item) in subject.enumerated() {
                XCTAssertEqual(item, object[i])
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withArrayOfPrimitiveToCerealTypeDictionary_returnsCorrectData() {
        do {
            let object = [["Foo": TestCerealType(foo: "bar")], ["Bar": TestCerealType(foo: "bar")]]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [[String: TestCerealType]] = try CerealDecoder.rootCerealItems(with: encoder.toData())
            XCTAssertEqual(subject.count, 2)
            XCTAssertEqual(subject[0], object[0])
            XCTAssertEqual(subject[1], object[1])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withArrayOfCerealTypeToCerealTypeDictionary_returnsCorrectData() {
        do {
            let object = [[TestCerealType(foo: "bar"): TestCerealType(foo: "baz")], [TestCerealType(foo: "fee"): TestCerealType(foo: "foo")]]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [[TestCerealType: TestCerealType]] = try CerealDecoder.rootCerealPairItems(with: encoder.toData())

            XCTAssertEqual(subject.count, 2)
            XCTAssertEqual(subject[0], object[0])
            XCTAssertEqual(subject[1], object[1])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withArrayOfPrimitiveToProtocoledCerealTypeDictionary_returnsCorrectData() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let object: [[String: Fooable]] = [["Foo": TestIdentifyingCerealType(foo: "bar")], ["Bar": TestIdentifyingCerealType(foo: "baz")]]
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(deepCast(object), forKey: rootKey)
            let subject: [[String: Fooable]] = deepCast(try CerealDecoder.rootIdentifyingCerealItems(with: encoder.toData()))
            XCTAssertEqual(subject.count, 2)
            XCTAssertEqual(subject[0].count, 1)
            XCTAssertEqual(subject[1].count, 1)
            XCTAssertEqual(subject[0]["Foo"]?.foo, object[0]["Foo"]?.foo)
            XCTAssertEqual(subject[1]["Bar"]?.foo, object[1]["Bar"]?.foo)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withArrayOfCerealToProtocoledCerealTypeDictionary_returnsCorrectData() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let first = TestCerealType(foo: "hai")
            let second = TestCerealType(foo: "bai")
            let object: [[TestCerealType: Fooable]] = [[first: TestIdentifyingCerealType(foo: "bar")], [second: TestIdentifyingCerealType(foo: "baz")]]
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(deepCast(object), forKey: rootKey)
            let subject: [[TestCerealType: Fooable]] = deepCast(try CerealDecoder.rootCerealToIdentifyingCerealItems(with: encoder.toData()))

            XCTAssertEqual(subject.count, 2)
            XCTAssertEqual(subject[0].count, 1)
            XCTAssertEqual(subject[1].count, 1)
            XCTAssertEqual(subject[0][first]?.foo, object[0][first]?.foo)
            XCTAssertEqual(subject[1][second]?.foo, object[1][second]?.foo)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withPrimitiveDictionary_returnsCorrectData() {
        do {
            let object = ["foo": true]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [String: Bool] = try CerealDecoder.rootItems(with: encoder.toData())
            XCTAssertEqual(subject, object)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withPrimitiveToCerealTypeDictionary_returnsCorrectData() {
        do {
            let object = ["foo": TestCerealType(foo: "bar")]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [String: TestCerealType] = try CerealDecoder.rootCerealItems(with: encoder.toData())
            XCTAssertEqual(subject, object)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withCerealTypeToPrimitiveDictionary_returnsCorrectData() {
        do {
            let key = TestCerealType(foo: "bar")
            let object = [key: "foo"]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [TestCerealType: String] = try CerealDecoder.rootCerealItems(with: encoder.toData())
            XCTAssertEqual(subject, object)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withPrimitiveToProtocoledIdentifyingCerealTypeDictionary_returnsCorrectData() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let object: [String: Fooable] = ["foo": TestIdentifyingCerealType(foo: "bar")]
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(object.CER_casted() as [String: IdentifyingCerealType], forKey: rootKey)
            let subject: [String: Fooable] = (try CerealDecoder.rootIdentifyingCerealItems(with: encoder.toData()) as [String: IdentifyingCerealType]).CER_casted()
            XCTAssertEqual(subject.count, 1)
            XCTAssertNotNil(subject["foo"])
            XCTAssertEqual(subject["foo"]?.foo, object["foo"]?.foo)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withCerealTypeToCerealTypeDictionary_returnsCorrectData() {
        do {
            let object = [TestCerealType(foo: "baz"): TestCerealType(foo: "bar")]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [TestCerealType: TestCerealType] = try CerealDecoder.rootCerealPairItems(with: encoder.toData())
            XCTAssertEqual(subject, object)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withCerealTypeToProtocoledIdentifyingCerealTypeDictionary_returnsCorrectData() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let key = TestCerealType(foo: "baz")
            let object: [TestCerealType: Fooable] = [key: TestIdentifyingCerealType(foo: "bar")]
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(object.CER_casted() as [TestCerealType: IdentifyingCerealType], forKey: rootKey)
            let subject: [TestCerealType: Fooable] = (try CerealDecoder.rootCerealToIdentifyingCerealItems(with: encoder.toData()) as [TestCerealType: IdentifyingCerealType]).CER_casted()
            XCTAssertEqual(subject.count, 1)
            XCTAssertNotNil(subject[key])
            XCTAssertEqual(subject[key]?.foo, object[key]?.foo)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withPrimitiveToPrimitiveArrayDictionary_returnsCorrectData() {
        do {
            let object = ["hai": [1, 2]]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [String: [Int]] = try CerealDecoder.rootItems(with: encoder.toData())

            XCTAssertNotNil(subject["hai"])
            guard subject["hai"] != nil else { return }
            XCTAssertTrue(subject["hai"]! == object["hai"]!)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withPrimitiveToCerealTypeArrayDictionary_returnsCorrectData() {
        do {
            let object = ["foo": [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")]]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [String: [TestCerealType]] = try CerealDecoder.rootCerealItems(with: encoder.toData())
            XCTAssertNotNil(subject["foo"])
            guard subject["hai"] != nil else { return }
            XCTAssertEqual(subject["foo"]!, object["foo"]!)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withCerealTypeToPrimitiveArrayDictionary_returnsCorrectData() {
        do {
            let key = TestCerealType(foo: "baz")
            let object = [key: ["foo", "bar"]]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [TestCerealType: [String]] = try CerealDecoder.rootCerealItems(with: encoder.toData())
            XCTAssertNotNil(subject[key])
            guard subject[key] != nil else { return }
            XCTAssertEqual(subject[key]!, object[key]!)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withCerealTypeToCerealTypeArrayDictionary_returnsCorrectData() {
        do {
            let key = TestCerealType(foo: "foo")
            let object = [key: [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")]]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [TestCerealType: [TestCerealType]] = try CerealDecoder.rootCerealPairItems(with: encoder.toData())
            XCTAssertNotNil(subject[key])
            guard subject[key] != nil else { return }
            XCTAssertEqual(subject[key]!, object[key]!)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withPrimitiveToProtocoledIdentifyingCerealTypeArrayDictionary_returnsCorrectData() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let object: [String: [Fooable]] = ["foo": [TestIdentifyingCerealType(foo: "bar"), TestIdentifyingCerealType(foo: "baz")]]
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(deepArrayCast(object), forKey: rootKey)
            let subject: [String: [Fooable]] = deepArrayCast(try CerealDecoder.rootIdentifyingCerealItems(with: encoder.toData()))
            XCTAssertNotNil(subject["foo"])
            guard subject["foo"] != nil else { return }
            XCTAssertEqual(subject["foo"]![0].foo, object["foo"]![0].foo)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withCerealTypeToProtocoledIdentifyingCerealTypeArrayDictionary_returnsCorrectData() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let key = TestCerealType(foo: "foo")
            let object: [TestCerealType: [Fooable]] = [key: [TestIdentifyingCerealType(foo: "bar"), TestIdentifyingCerealType(foo: "baz")]]
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(deepArrayCast(object), forKey: rootKey)
            let subject: [TestCerealType: [Fooable]] = deepArrayCast(try CerealDecoder.rootCerealToIdentifyingCerealItems(with: encoder.toData()))
            XCTAssertNotNil(subject[key])
            guard subject[key] != nil else { return }
            XCTAssertEqual(subject[key]![0].foo, object[key]![0].foo)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

}
