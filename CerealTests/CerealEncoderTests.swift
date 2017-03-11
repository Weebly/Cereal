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

    let emptyEncoderBytes: [UInt8] = [11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    func testToBytes_withNoData_isOkay() {
        let subject = CerealEncoder()
        XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
    }

    func testEncode_withNilPrimitive_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: String? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: Fooable? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilArrayOfPrimitive_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String]? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilArrayOfIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [IdentifyingCerealType]? = nil
            try subject.encodeIdentifyingItems(item?.CER_casted(), forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilArrayOfDictionaryPrimitives_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [[String: Int]]? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilArrayOfDictionaryIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [[String: IdentifyingCerealType]]? = nil
            try subject.encodeIdentifyingItems(item, forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilDictionaryOfPrimitive_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String: Bool]? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilDictionaryOfIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String: IdentifyingCerealType]? = nil
            try subject.encodeIdentifyingItems(item, forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilDictionaryOfArrayOfPrimitive_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String: [Bool]]? = nil
            try subject.encode(item, forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    func testEncode_withNilDictionaryOfArrayOfIdentifying_resultsInEmptyString() {
        var subject = CerealEncoder()
        do {
            let item: [String: [IdentifyingCerealType]]? = nil
            try subject.encodeIdentifyingItems(item, forKey: "test")
            XCTAssertEqual(subject.toBytes(), emptyEncoderBytes)
        } catch let error {
            XCTFail("Failed due to error: \(error)")
        }
    }

    // MARK: String

    func testToBytes_withString() {
        var subject = CerealEncoder()
        do {
            try subject.encode("Hello, world!", forKey: "string")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,38,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,115,116,114,105,110,103,1,13,0,0,0,0,0,0,0,72,101,108,108,111,44,32,119,111,114,108,100,33])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withEmptyString() {
        var subject = CerealEncoder()
        do {
            try subject.encode("", forKey: "string")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,115,116,114,105,110,103,1,0,0,0,0,0,0,0,0])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withEmojiString() {
        var subject = CerealEncoder()
        do {
            try subject.encode("🐼🍴🌿", forKey: "string")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,37,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,115,116,114,105,110,103,1,12,0,0,0,0,0,0,0,240,159,144,188,240,159,141,180,240,159,140,191])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: Bool

    func testToBytes_withTrueBool() {
        var subject = CerealEncoder()
        do {
            try subject.encode(true, forKey: "mybool")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,26,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,109,121,98,111,111,108,6,1,0,0,0,0,0,0,0,1])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFalseBool() {
        var subject = CerealEncoder()
        do {
            try subject.encode(false, forKey: "mybool")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,26,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,109,121,98,111,111,108,6,1,0,0,0,0,0,0,0,0])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: Int

    func testToBytes_withInt() {
        var subject = CerealEncoder()
        do {
            try subject.encode(86, forKey: "myint")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,109,121,105,110,116,2,8,0,0,0,0,0,0,0,86,0,0,0,0,0,0,0])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64() {
        var subject = CerealEncoder()
        do {
            try subject.encode(8006 as Int64, forKey: "mybigint")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,8,0,0,0,0,0,0,0,109,121,98,105,103,105,110,116,3,8,0,0,0,0,0,0,0,70,31,0,0,0,0,0,0])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: Double

    func testToBytes_withDouble() {
        var subject = CerealEncoder()
        do {
            try subject.encode(79.31, forKey: "mydouble")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,8,0,0,0,0,0,0,0,109,121,100,111,117,98,108,101,4,8,0,0,0,0,0,0,0,164,112,61,10,215,211,83,64])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloat() {
        var subject = CerealEncoder()
        do {
            try subject.encode(79.31 as Float, forKey: "myfloat")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,30,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,7,0,0,0,0,0,0,0,109,121,102,108,111,97,116,5,4,0,0,0,0,0,0,0,184,158,158,66])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: Date

    func testToBytes_withDate() {
        var subject = CerealEncoder()
        do {
            try subject.encode(Date(timeIntervalSinceReferenceDate: 5), forKey: "mydate")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,33,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,109,121,100,97,116,101,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,20,64])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateWithNegativeIntervalSince1970() {
        var subject = CerealEncoder()
        do {
            try subject.encode(Date(timeIntervalSinceReferenceDate: -5), forKey: "mydate")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,33,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,109,121,100,97,116,101,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,20,192])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    // MARK: NSURL
    
    func testToBytes_withURL() {
        var subject = CerealEncoder()
        do {
            try subject.encode(URL(string: "http://test.com"), forKey: "myurl")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,39,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,109,121,117,114,108,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: Data

    func testToBytes_withNSData() {
        var subject = CerealEncoder()
        do {
            let bytes: [UInt8] = [0, 1, 0, 1, 0, 0, 1, 1]
            try subject.encode(Data(bytes: bytes), forKey: "mydata")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,33,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,109,121,100,97,116,97,13,8,0,0,0,0,0,0,0,0,1,0,1,0,0,1,1])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: RawRepresentable

    func testToBytes_withStringEnum() {
        var subject = CerealEncoder()
        do {
            try subject.encode(TestEnum.testCase2, forKey: "myenum")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,34,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,109,121,101,110,117,109,1,9,0,0,0,0,0,0,0,84,101,115,116,67,97,115,101,50])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntOptionSet() {
        var subject = CerealEncoder()
        do {
            let options: TestSetType = [TestSetType.FirstOption, TestSetType.SecondOption]
            try subject.encode(options, forKey: "myoptionset")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,38,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,11,0,0,0,0,0,0,0,109,121,111,112,116,105,111,110,115,101,116,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - Custom Types

    func testToBytes_withCereal() {
        do {
            var subject = CerealEncoder()
            let object = TestCerealType(foo: "test")
            try subject.encode(object, forKey: "wat")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,56,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,11,26,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,4,0,0,0,0,0,0,0,116,101,115,116])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withEmptyCereal() {
        do {
            var subject = CerealEncoder()
            let object = OptionalTestCerealType()
            try subject.encode(object, forKey: "wat")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,30,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCereal() {
        do {
            var subject = CerealEncoder()
            let object = MyBar(bar: "baz")
            try subject.encode(object, forKey: "wat")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
        } catch let error {
             XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withProtocoledIdentifyingCereal() {
        do {
            var subject = CerealEncoder()
            let object: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encode(object, forKey: "wat")
            let result = subject.toBytes()
            XCTAssertEqual(result, [11,68,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - Data

    func testToData_istoBytesValueWithUTF8() {
        var subject = CerealEncoder()
        do {
            try subject.encode(["one","two","three"], forKey: "string")
            let result = subject.toData()
            let bytes: [UInt8] = [11,71,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,115,116,114,105,110,103,10,38,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,111,110,101,1,3,0,0,0,0,0,0,0,116,119,111,1,5,0,0,0,0,0,0,0,116,104,114,101,101]
            let expected = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
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
