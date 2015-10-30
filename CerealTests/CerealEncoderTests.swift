//
//  CerealEncoderTests.swift
//  Cereal
//
//  Created by James Richard on 8/3/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import XCTest
@testable import Cereal

class CerealEncoderTests: XCTestCase {
    // MARK: Empty / Nil encoding

    func testToString_withNoData_isOkay() {
        let subject = CerealEncoder()
        XCTAssertEqual(subject.toString(), "")
    }

    func testEncode_withNilPrimitive_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: String? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: Fooable? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilArrayOfPrimitive_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String]? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilArrayOfIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [IdentifyingCerealType]? = nil
            try subject.encodeIdentifyingItems(item?.CER_casted(), forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilArrayOfDictionaryPrimitives_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [[String: Int]]? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilArrayOfDictionaryIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [[String: IdentifyingCerealType]]? = nil
            try subject.encodeIdentifyingItems(item, forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilDictionaryOfPrimitive_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String: Bool]? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilDictionaryOfIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String: IdentifyingCerealType]? = nil
            try subject.encodeIdentifyingItems(item, forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilDictionaryOfArrayOfPrimitive_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String: [Bool]]? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilDictionaryOfArrayOfIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String: [IdentifyingCerealType]]? = nil
            try subject.encodeIdentifyingItems(item, forKey: "test")
            XCTAssertEqual(subject.toString(), "")
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    // MARK: - Primitives

    func testToString_withMultiplePrimitives() {
        var subject = CerealEncoder()
        do {
            try subject.encode(5, forKey: "int")
            try subject.encode("test", forKey: "string")
            let result = subject.toString()
            var expected = "k,3:int:i,1:5"
            XCTAssert(result.rangeOfString(expected) != nil, "String '\(result)' did not contain substring '\(expected)'")
            expected = "k,6:string:s,4:test"
            XCTAssert(result.rangeOfString(expected) != nil, "String '\(result)' did not contain substring '\(expected)'")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: String

    func testToString_withString() {
        var subject = CerealEncoder()
        do {
            try subject.encode("Hello, world!", forKey: "string")
            let result = subject.toString()
            XCTAssertEqual(result, "k,6:string:s,13:Hello, world!")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withEmptyString() {
        var subject = CerealEncoder()
        do {
            try subject.encode("", forKey: "string")
            let result = subject.toString()
            XCTAssertEqual(result, "k,6:string:s,0:")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withEmojiString() {
        var subject = CerealEncoder()
        do {
            try subject.encode("🐼🍴🌿", forKey: "string")
            let result = subject.toString()
            XCTAssertEqual(result, "k,6:string:s,3:🐼🍴🌿")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: Bool

    func testToString_withTrueBool() {
        var subject = CerealEncoder()
        do {
            try subject.encode(true, forKey: "mybool")
            let result = subject.toString()
            XCTAssertEqual(result, "k,6:mybool:b,1:t")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFalseBool() {
        var subject = CerealEncoder()
        do {
            try subject.encode(false, forKey: "mybool")
            let result = subject.toString()
            XCTAssertEqual(result, "k,6:mybool:b,1:f")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: Int

    func testToString_withInt() {
        var subject = CerealEncoder()
        do {
            try subject.encode(86, forKey: "myint")
            let result = subject.toString()
            XCTAssertEqual(result, "k,5:myint:i,2:86")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64() {
        var subject = CerealEncoder()
        do {
            try subject.encode(8006 as Int64, forKey: "mybigint")
            let result = subject.toString()
            XCTAssertEqual(result, "k,8:mybigint:z,4:8006")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: Double

    func testToString_withDouble() {
        var subject = CerealEncoder()
        do {
            try subject.encode(79.31, forKey: "mydouble")
            let result = subject.toString()
            XCTAssertEqual(result, "k,8:mydouble:d,5:79.31")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloat() {
        var subject = CerealEncoder()
        do {
            try subject.encode(79.31 as Float, forKey: "myfloat")
            let result = subject.toString()
            XCTAssertEqual(result, "k,7:myfloat:f,5:79.31")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: Date

    func testToString_withDate() {
        var subject = CerealEncoder()
        do {
            try subject.encode(NSDate(timeIntervalSince1970: 5), forKey: "mydate")
            let result = subject.toString()
            XCTAssertEqual(result, "k,6:mydate:t,3:5.0")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDateWithNegativeIntervalSince1970() {
        var subject = CerealEncoder()
        do {
            try subject.encode(NSDate(timeIntervalSince1970: -5), forKey: "mydate")
            let result = subject.toString()
            XCTAssertEqual(result, "k,6:mydate:t,4:-5.0")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    // MARK: NSURL
    
    func testToString_withURL() {
        var subject = CerealEncoder()
        do {
            try subject.encode(NSURL(string: "http://test.com"), forKey: "myurl")
            let result = subject.toString()
            XCTAssertEqual(result, "k,5:myurl:u,15:http://test.com")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    // MARK: - Custom Types

    func testToString_withCereal() {
        do {
            var subject = CerealEncoder()
            let object = TestCerealType(foo: "test")
            try subject.encode(object, forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:c,16:k,3:foo:s,4:test"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withMultiCereal() {
        do {
            var subject = CerealEncoder()
            let object = TestMultiCerealType(foo: "hello", bar: "world")
            try subject.encode(object, forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:c,35:"))
            XCTAssertTrue(result.containsSubstring("k,3:foo:s,5:hello"))
            XCTAssertTrue(result.containsSubstring("k,3:bar:s,5:world"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withEmptyCereal() {
        do {
            var subject = CerealEncoder()
            let object = OptionalTestCerealType()
            try subject.encode(object, forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:c,0:"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCereal() {
        do {
            var subject = CerealEncoder()
            let object = MyBar(bar: "baz")
            try subject.encode(object, forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:p,23:5:MyBar:k,3:bar:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
             XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withProtocoledIdentifyingCereal() {
        do {
            var subject = CerealEncoder()
            let object: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encode(object, forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - Data

    func testToData_isToStringValueWithUTF8() {
        var subject = CerealEncoder()
        do {
            try subject.encode(["one","two","three"], forKey: "string")
            let result = subject.toData()
            let expected = ("k,6:string:a,25:s,3:one:s,3:two:s,5:three" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - Root Items

    func testDataWithRootItem_forPrimitive_returnsCorrectData() {
        do {
            let subject = try CerealEncoder.dataWithRootItem("testing")
            var encoder = CerealEncoder()
            try encoder.encode("testing", forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_forCerealType_returnsCorrectData() {
        do {
            let object = TestCerealType(foo: "test")
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_forProtocoledIdentifyingCerealType_returnsCorrectData() {
        do {
            let object: Fooable = TestIdentifyingCerealType(foo: "baz")
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withPrimitiveArray_returnsCorrectData() {
        do {
            let subject = try CerealEncoder.dataWithRootItem(["foo", "bar"])
            var encoder = CerealEncoder()
            try encoder.encode(["foo", "bar"], forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withCerealTypeArray_returnsCorrectData() {
        do {
            let object = [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")]
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_forProtocoledIdentifyingCerealTypeArray_returnsCorrectData() {
        do {
            let object: [Fooable] = [TestIdentifyingCerealType(foo: "bar"), TestIdentifyingCerealType(foo: "baz")]
            let subject = try CerealEncoder.dataWithRootItem(object.CER_casted())
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(object.CER_casted(), forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withArrayOfPrimitiveToPrimitiveDictionary_returnsCorrectData() {
        do {
            let object = [["Foo": 1], ["Bar": 2]]
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withArrayOfCerealTypeToCerealTypeDictionary_returnsCorrectData() {
        do {
            let object = [[TestCerealType(foo: "bar"): TestCerealType(foo: "baz")], [TestCerealType(foo: "fee"): TestCerealType(foo: "foo")]]
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withArrayOfPrimitiveToProtocoledCerealTypeDictionary_returnsCorrectData() {
        do {
            let object: [[String: Fooable]] = [["Foo": TestIdentifyingCerealType(foo: "bar")], ["Bar": TestIdentifyingCerealType(foo: "baz")]]
            let subject = try CerealEncoder.dataWithRootItem(deepCast(object))
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(deepCast(object), forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withPrimitiveDictionary_returnsCorrectData() {
        do {
            let object = ["foo?": true]
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withPrimitiveToCerealTypeDictionary_returnsCorrectData() {
        do {
            let object = ["foo?": TestCerealType(foo: "bar")]
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withCerealTypeToCerealTypeDictionary_returnsCorrectData() {
        do {
            let object = [TestCerealType(foo: "baz"): TestCerealType(foo: "bar")]
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withCerealTypeToProtocoledIdentifyingCerealTypeDictionary_returnsCorrectData() {
        do {
            let object: [String: Fooable] = ["hai": TestIdentifyingCerealType(foo: "bar")]
            let subject = try CerealEncoder.dataWithRootItem(object.CER_casted() as [String: IdentifyingCerealType])
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(object.CER_casted() as [String: IdentifyingCerealType], forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withPrimitiveToPrimitiveArrayDictionary_returnsCorrectData() {
        do {
            let object = ["hai": [1, 2]]
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withCerealTypeToCerealTypeArrayDictionary_returnsCorrectData() {
        do {
            let object = [TestCerealType(foo: "foo"): [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")]]
            let subject = try CerealEncoder.dataWithRootItem(object)
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDataWithRootItem_withCerealTypeToProtocoledIdentifyingCerealTypeArrayDictionary_returnsCorrectData() {
        do {
            let object: [String: [Fooable]] = ["foo": [TestIdentifyingCerealType(foo: "bar"), TestIdentifyingCerealType(foo: "baz")]]
            let subject = try CerealEncoder.dataWithRootItem(deepArrayCast(object))
            var encoder = CerealEncoder()
            try encoder.encodeIdentifyingItems(deepArrayCast(object), forKey: rootKey)
            let expected = encoder.toData()
            XCTAssertEqual(subject, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
}
