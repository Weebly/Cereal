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
            _ = try CerealDecoder(encodedBytes: [11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        } catch {
            XCTFail("Couldn't decode an empty string")
        }
    }

    // MARK: - Primitives

    func testDecodingString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,1,5,0,0,0,0,0,0,0,104,101,108,108,111])
            let result: String = try subject.decode(key: "test") ?? ""
            XCTAssertEqual(result, "hello")
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingEmptyString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,23,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,1,0,0,0,0,0,0,0,0])
            let result: String = try subject.decode(key: "test") ?? "derp"
            XCTAssertEqual(result, "")
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingBool() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,98,116,101,115,116,6,1,0,0,0,0,0,0,0,1])
            let resultBool: Bool = try subject.decode(key: "btest") ?? false
            XCTAssertEqual(resultBool, true)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingInt() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,105,116,101,115,116,2,8,0,0,0,0,0,0,0,16,39,0,0,0,0,0,0])
            let resultInt: Int = try subject.decode(key: "itest") ?? 0
            XCTAssertEqual(resultInt, 10000)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingInt64() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,105,116,101,115,116,3,8,0,0,0,0,0,0,0,0,202,154,59,0,0,0,0])
            let resultInt: Int64 = try subject.decode(key: "itest") ?? 0
            XCTAssertEqual(resultInt, 1000000000)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingDouble() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,100,116,101,115,116,4,8,0,0,0,0,0,0,0,119,190,159,26,47,221,94,64])
            let resultDouble: Double = try subject.decode(key: "dtest") ?? 0.0
            XCTAssertEqual(resultDouble, 123.456)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingFloat() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,102,116,101,115,116,5,4,0,0,0,0,0,0,0,121,233,246,66])
            let resultFloat: Float = try subject.decode(key: "ftest") ?? 0.0
            XCTAssertEqual(resultFloat, 123.456)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingDate() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,100,116,101,115,116,7,8,0,0,0,0,0,0,0,0,0,0,59,228,39,205,193])
            let resultDate: Date = try subject.decode(key: "dtest") ?? Date()
            XCTAssertEqual(resultDate, Date(timeIntervalSince1970: 10.0))
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingPreciseDate() {
        do {
            let date = Date(timeIntervalSinceReferenceDate: TimeInterval(String(72169399.35149699))!)
            let interval = date.timeIntervalSinceReferenceDate
            let bytes = [11,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,100,116,101,115,116, 7,8,0,0,0,0,0,0,0] + toByteArray(interval)
            let subject = try CerealDecoder(encodedBytes: bytes)
            let resultDate: Date = try subject.decode(key: "dtest") ?? Date()
            XCTAssertEqual(resultDate, Date(timeIntervalSinceReferenceDate: 72169399.35149699))
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingCurrentDate() {
        do {
            let date = Date()
            let interval = date.timeIntervalSinceReferenceDate
            let bytes = [11,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,100,116,101,115,116, 7,8,0,0,0,0,0,0,0] + toByteArray(interval)

            let subject = try CerealDecoder(encodedBytes: bytes)
            let resultDate: Date = try subject.decode(key: "dtest") ?? Date()
            XCTAssertEqual(resultDate, date)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingDate_withNegativeInterval() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,100,116,101,115,116,7,8,0,0,0,0,0,0,0,0,0,0,69,228,39,205,193])
            let resultDate: Date = try subject.decode(key: "dtest") ?? Date()
            XCTAssertEqual(resultDate, Date(timeIntervalSince1970: -10.0))
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }
    
    func testDecodingURL() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,42,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,100,116,101,115,116,8,18,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,105,110,103,46,99,111,109])
            let resultURL: URL? = try subject.decode(key: "dtest")
            XCTAssertEqual(resultURL, URL(string: "http://testing.com"))
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingNSData() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,100,116,101,115,116,13,8,0,0,0,0,0,0,0,0,1,0,1,0,0,1,1])
            let resultData: Data = try subject.decode(key: "dtest") ?? Data()
            let bytes: [UInt8] = [0, 1, 0, 1, 0, 0, 1, 1]
            let testData = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
            XCTAssertEqual(resultData, testData)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingMultiplePrimitives() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,60,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,1,5,0,0,0,0,0,0,0,104,101,108,108,111,9,1,5,0,0,0,0,0,0,0,105,116,101,115,116,2,8,0,0,0,0,0,0,0,16,39,0,0,0,0,0,0])
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
            let subject = try CerealDecoder(encodedBytes: [11,36,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,8,0,0,0,0,0,0,0,101,110,117,109,116,101,115,116,1,9,0,0,0,0,0,0,0,84,101,115,116,67,97,115,101,50])
            let resultEnum: TestEnum = try subject.decode(key: "enumtest") ?? .testCase1
            XCTAssertEqual(resultEnum, TestEnum.testCase2)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingIntOptionSet() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,40,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,13,0,0,0,0,0,0,0,111,112,116,105,111,110,115,101,116,116,101,115,116,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0])
            let resultOptions: TestSetType = try subject.decode(key: "optionsettest") ?? []
            XCTAssertEqual(resultOptions, [TestSetType.FirstOption, TestSetType.SecondOption])
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: - Custom Types

    func testDecoding_withCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,56,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114])
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
            let subject = try CerealDecoder(encodedBytes: [11,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,9,1,4,0,0,0,0,0,0,0,106,101,115,116,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
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
            let subject = try CerealDecoder(encodedBytes: [11,97,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,99,117,115,116,111,109,11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0])
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
            let subject = try CerealDecoder(encodedBytes: [11,56,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114])
            let result: TestCerealType? = try subject.decodeCereal(key: "testage")
            XCTAssert(result == nil)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCereal_forProtocol() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114])
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
            let subject = try CerealDecoder(encodedBytes: [11,121,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,12,1,12,0,0,0,0,0,0,0,77,121,66,97,114,45,98,97,114,98,97,103,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
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
            let subject = try CerealDecoder(encodedBytes: [10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,1,5,0,0,0,0,0,0,0,104,101,108,108,111])
            XCTFail("Expected an error, but instantiated decoder: \(subject)")
        } catch CerealError.invalidDataContent {
            // Test passes if this block is hit
        } catch let error {
            XCTFail("An incorrect error was thrown: \(error)")
        }
    }

    func testDecoding_withIncorrectDataContent_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,116,101,115,116,1,5,0,0,0,0,0,0,0,104,101,108,108,111])
            XCTFail("Expected an error, but instantiated decoder: \(subject)")
        } catch CerealError.invalidDataContent {
            // Test passes if this block is hit
        } catch let error {
            XCTFail("An incorrect error was thrown: \(error)")
        }
    }

    func testDecoding_withIncorrectType_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,2,5,0,0,0,0,0,0,0,104,101,108,108,111])
            let s: String? = try subject.decode(key: "test")
            XCTFail("Expected an error, but decoded: \(s)")
        } catch CerealError.invalidEncoding {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    func testDecoding_withInvalidDecodeType_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,1,5,0,0,0,0,0,0,0,104,101,108,108,111])
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
            let subject = try CerealDecoder(encodedBytes: [11,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,1,5,0,0,0,0,0,0,0,104,101,108,108,111])
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
            let subject = try CerealDecoder(encodedBytes: [11,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,1,5,0,0,0,0,0,0,0,104,101,108,108,111])
            let object: [Int]? = try subject.decode(key: "test")
            XCTFail("Expected an error, but decoded: \(object)")
        } catch CerealError.typeMismatch {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    func testDecoding_withArrayEncoded_usingUnexpectedCerealType_raisesExpectedError() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,1,5,0,0,0,0,0,0,0,104,101,108,108,111])
            let object: [Int]? = try subject.decode(key: "test")
            XCTFail("Expected an error, but decoded: \(object)")
        } catch CerealError.typeMismatch {
            // Test passes if this block is hit
        } catch {
            XCTFail("An incorrect error was thrown")
        }
    }

    // MARK: Value rewrite

    func testDecoding_withValueRewrite() {
        do {
            var encoder = CerealEncoder()
            try encoder.encode("string", forKey: "string")
            try encoder.encode("string-new-value", forKey: "string")

            let decoder = try CerealDecoder(data: encoder.toData())
            let subject: String = try decoder.decode(key: "string") ?? ""

            XCTAssertEqual(subject, "string-new-value")
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - Root Items

    func testRootItemWithData_forPrimitive_returnsCorrectData() {
        do {
            var encoder = CerealEncoder()
            try encoder.encode("testing", forKey: rootKey)
            let subject: String = try CerealDecoder.rootItemWithData(data: encoder.toData())

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
            let subject: TestCerealType = try CerealDecoder.rootCerealItemWithData(data: encoder.toData())
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
            guard let subject: Fooable = try CerealDecoder.rootIdentifyingCerealItemWithData(data: encoder.toData()) as? Fooable else {
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
            let subject: [String] = try CerealDecoder.rootItemsWithData(data: encoder.toData())
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
            let subject: [TestCerealType] = try CerealDecoder.rootCerealItemsWithData(data: encoder.toData())
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
            let subject: [Fooable] = try CerealDecoder.rootIdentifyingCerealItemsWithData(data: encoder.toData()).CER_casted()
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
            let subject: [[String: Int]] = try CerealDecoder.rootItemsWithData(data: encoder.toData())
            XCTAssertEqual(subject[0], object[0])
            XCTAssertEqual(subject[1], object[1])
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testRootItemWithData_withArrayOfPrimitiveToCerealTypeDictionary_returnsCorrectData() {
        do {
            let object = [["Foo": TestCerealType(foo: "bar")], ["Bar": TestCerealType(foo: "bar")]]
            var encoder = CerealEncoder()
            try encoder.encode(object, forKey: rootKey)
            let subject: [[String: TestCerealType]] = try CerealDecoder.rootCerealItemsWithData(data: encoder.toData())
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
            let subject: [[TestCerealType: TestCerealType]] = try CerealDecoder.rootCerealPairItemsWithData(data: encoder.toData())

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
            let subject: [[String: Fooable]] = deepCast(try CerealDecoder.rootIdentifyingCerealItemsWithData(data: encoder.toData()))

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
            let subject: [[TestCerealType: Fooable]] = deepCast(try CerealDecoder.rootCerealToIdentifyingCerealItemsWithData(data: encoder.toData()))

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
            let subject: [String: Bool] = try CerealDecoder.rootItemsWithData(data: encoder.toData())
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
            let subject: [String: TestCerealType] = try CerealDecoder.rootCerealItemsWithData(data: encoder.toData())
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
            let subject: [TestCerealType: String] = try CerealDecoder.rootCerealItemsWithData(data: encoder.toData())
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
            let subject: [String: Fooable] = (try CerealDecoder.rootIdentifyingCerealItemsWithData(data: encoder.toData()) as [String: IdentifyingCerealType]).CER_casted()
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
            let subject: [TestCerealType: TestCerealType] = try CerealDecoder.rootCerealPairItemsWithData(data: encoder.toData())
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
            let subject: [TestCerealType: Fooable] = (try CerealDecoder.rootCerealToIdentifyingCerealItemsWithData(data: encoder.toData()) as [TestCerealType: IdentifyingCerealType]).CER_casted()
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
            let subject: [String: [Int]] = try CerealDecoder.rootItemsWithData(data: encoder.toData())

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
            let subject: [String: [TestCerealType]] = try CerealDecoder.rootCerealItemsWithData(data: encoder.toData())
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
            let subject: [TestCerealType: [String]] = try CerealDecoder.rootCerealItemsWithData(data: encoder.toData())
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
            let subject: [TestCerealType: [TestCerealType]] = try CerealDecoder.rootCerealPairItemsWithData(data: encoder.toData())
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
            let subject: [String: [Fooable]] = deepArrayCast(try CerealDecoder.rootIdentifyingCerealItemsWithData(data: encoder.toData()))
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
            let subject: [TestCerealType: [Fooable]] = deepArrayCast(try CerealDecoder.rootCerealToIdentifyingCerealItemsWithData(data: encoder.toData()))
            XCTAssertNotNil(subject[key])
            guard subject[key] != nil else { return }
            XCTAssertEqual(subject[key]![0].foo, object[key]![0].foo)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
}
