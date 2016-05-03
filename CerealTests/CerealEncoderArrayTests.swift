//
//  CerealEncoderArrayTests.swift
//  Cereal
//
//  Created by James Richard on 8/24/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import XCTest
@testable import Cereal

class CerealEncoderArrayTests: XCTestCase {
    var subject: CerealEncoder!

    override func setUp() {
        super.setUp()
        subject = CerealEncoder()
    }

    override func tearDown() {
        subject = nil
        Cereal.clearRegisteredCerealTypes()
        super.tearDown()
    }

    func testToBytes_withEmptyIntArray() {
        do {
            try subject.encode([Int](), forKey: "arrrr!")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,33,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,97,114,114,114,114,33,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolArray() {
        do {
            try subject.encode([true,false,true], forKey: "arrrr!")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,42,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,97,114,114,114,114,33,10,9,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,6,1,1,6,1,0,6,1,1]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntArray() {
        do {
            try subject.encode([5,3,80], forKey: "arrrr!")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,84,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,97,114,114,114,114,33,10,51,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,80,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleArray() {
        do {
            try subject.encode([5.3,3.98,80.1], forKey: "dubs")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,82,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,100,117,98,115,10,51,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,21,64,4,8,0,0,0,0,0,0,0,215,163,112,61,10,215,15,64,4,8,0,0,0,0,0,0,0,102,102,102,102,102,6,84,64]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatArray() {
        do {
            try subject.encode([5.3,3.98,80.1] as [Float], forKey: "floating")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,74,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,8,0,0,0,0,0,0,0,102,108,111,97,116,105,110,103,10,39,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,154,153,169,64,5,4,0,0,0,0,0,0,0,82,184,126,64,5,4,0,0,0,0,0,0,0,51,51,160,66]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringArray() {
        do {
            try subject.encode(["one","two","three"], forKey: "string")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,71,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,6,0,0,0,0,0,0,0,115,116,114,105,110,103,10,38,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,111,110,101,1,3,0,0,0,0,0,0,0,116,119,111,1,5,0,0,0,0,0,0,0,116,104,114,101,101]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateArray() {
        do {
            try subject.encode([NSDate(timeIntervalSinceReferenceDate: 10.0),NSDate(timeIntervalSinceReferenceDate: 11.0),NSDate(timeIntervalSinceReferenceDate: 20.0)], forKey: "date")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,82,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,100,97,116,101,10,51,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,38,64,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    func testToBytes_withURLArray() {
        do {
            try subject.encode([NSURL(string: "http://test.com")!,NSURL(string: "http://test1.com")!,NSURL(string: "http://test2.com")!], forKey: "urls")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,105,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,117,114,108,115,10,74,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,50,46,99,111,109]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withUnsupportedCerealRepresentable_returnsCorrectError() {
        do {
            try subject.encode(NSData(), forKey: "string")
            XCTFail("Exepcted an error to be thrown")
        } catch CerealError.UnsupportedCerealRepresentable {
            // The test passes if this block is executed
        } catch {
            XCTFail("The expected type of error was not thrown")
        }
    }

    func testToBytes_withCerealTypeArray() {
        do {
            let customType = TestCerealType(foo: "bar")

            try subject.encode([customType], forKey: "wat")

            let result = subject.toBytes()
            let expected: [UInt8] = [11,72,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,42,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealTypeArray() {
        do {
            let customType = TestIdentifyingCerealType(foo: "bar")
            try subject.encode([customType], forKey: "wat")

            let result = subject.toBytes()
            let expected: [UInt8] = [11,85,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,55,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withProtocoledIdentifyingCerealTypeArray() {
        do {
            let customType: Fooable = TestIdentifyingCerealType(foo: "bar")
            try subject.encodeIdentifyingItems([customType], forKey: "wat")

            let result = subject.toBytes()
            let expected: [UInt8] = [11,85,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,55,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringEnumRawRepresentableArray() {
        do {
            try subject.encode([TestEnum.TestCase1, TestEnum.TestCase2], forKey: "raws")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,67,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,114,97,119,115,10,36,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,9,0,0,0,0,0,0,0,84,101,115,116,67,97,115,101,49,1,9,0,0,0,0,0,0,0,84,101,115,116,67,97,115,101,50]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - Array of Dictionaries

    // MARK: [Bool: XXX]

    func testToBytes_withArrayOfBoolToBool() {
        do {
            try subject.encode([[true: true], [false: false]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,78,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,7,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,1,6,1,1,10,7,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,6,1,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfBoolToInt() {
        do {
            try subject.encode([[true: 2], [true: 4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,106,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,76,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,1,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,1,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfBoolToInt64() {
        do {
            try subject.encode([[false: 2], [false: 4]] as [[Bool: Int64]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,106,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,76,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfBoolToFloat() {
        do {
            try subject.encode([[false: 0.2], [true: 0.4]] as [[Bool: Float]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,68,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,17,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,5,4,0,0,0,0,0,0,0,205,204,76,62,10,17,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,1,5,4,0,0,0,0,0,0,0,205,204,204,62]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfBoolToDouble() {
        do {
            try subject.encode([[true: 0.2], [false: 0.4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,106,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,76,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,1,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfBoolToString() {
        do {
            try subject.encode([[true: "a"], [false: "b"]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,14,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,1,1,1,0,0,0,0,0,0,0,97,10,14,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,1,1,0,0,0,0,0,0,0,98]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfBoolToCereal() {
        do {
            try subject.encode([[true: TestCerealType(foo: "bar")], [false: TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,156,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,126,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,46,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,1,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,46,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfBoolToIdentifyingCereal() {
        do {
            try subject.encode([[true: TestIdentifyingCerealType(foo: "bar")], [false: TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,182,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,152,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,1,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfBoolToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[true: first], [false: second]] as [[Bool: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,182,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,152,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,1,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int: XXX]

    func testToBytes_withArrayOfIntToBool() {
        do {
            try subject.encode([[1: true], [3: false]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,106,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,76,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,6,1,1,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,6,1,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIntToInt() {
        do {
            try subject.encode([[1: 2], [3: 4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,134,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,104,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIntToInt64() {
        do {
            try subject.encode([[1: 2], [3: 4]] as [[Int: Int64]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,134,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,104,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIntToFloat() {
        do {
            try subject.encode([[1: 0.2], [3: 0.4]] as [[Int: Float]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,126,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,96,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,76,62,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,62]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIntToDouble() {
        do {
            try subject.encode([[1: 0.2], [3: 0.4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,134,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,104,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIntToString() {
        do {
            try subject.encode([[1: "a"], [3: "b"]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,120,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,90,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,98]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIntToCereal() {
        do {
            try subject.encode([[1: TestCerealType(foo: "bar")], [3: TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,184,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,154,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIntToIdentifyingCereal() {
        do {
            try subject.encode([[1: TestIdentifyingCerealType(foo: "bar")], [3: TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,210,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,180,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIntToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[1: first], [3: second]] as [[Int: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,210,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,180,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int64: XXX]

    func testToBytes_withArrayOfInt64ToBool() {
        do {
            try subject.encode([[1: true], [3: true]] as [[Int64: Bool]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,106,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,76,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,6,1,1,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,6,1,1]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfInt64ToInt() {
        do {
            try subject.encode([[1: 2], [3: 4]] as [[Int64: Int]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,134,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,104,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfInt64ToInt64() {
        do {
            try subject.encode([[1: 2], [3: 4]] as [[Int64: Int64]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,134,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,104,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfInt64ToFloat() {
        do {
            try subject.encode([[1: 0.2], [3: 0.4]] as [[Int64: Float]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,126,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,96,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,76,62,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,62]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfInt64ToDouble() {
        do {
            try subject.encode([[1: 0.2], [3: 0.4]] as [[Int64: Double]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,134,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,104,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfInt64ToString() {
        do {
            try subject.encode([[1: "a"], [3: "b"]] as [[Int64: String]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,120,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,90,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,98]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfInt64ToCereal() {
        do {
            try subject.encode([[1: TestCerealType(foo: "bar")], [3: TestCerealType(foo: "baz")]] as [[Int64: TestCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,184,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,154,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfInt64ToIdentifyingCereal() {
        do {
            try subject.encode([[1: TestIdentifyingCerealType(foo: "bar")], [3: TestIdentifyingCerealType(foo: "baz")]] as [[Int64: TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,210,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,180,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfInt64ToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[1: first], [3: second]] as [[Int64: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,210,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,180,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Float: XXX]

    func testToBytes_withArrayOfFloatToBool() {
        do {
            try subject.encode([[0.1: false], [0.3: false]] as [[Float: Bool]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,68,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,17,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,6,1,0,10,17,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,153,62,6,1,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfFloatToInt() {
        do {
            try subject.encode([[0.1: 2], [0.3: 4]] as [[Float: Int]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,126,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,96,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,153,62,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfFloatToInt64() {
        do {
            try subject.encode([[0.1: 2], [0.3: 4]] as [[Float: Int64]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,126,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,96,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,153,62,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfFloatToFloat() {
        do {
            try subject.encode([[0.1: 0.2], [0.3: 0.4]] as [[Float: Float]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,118,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,88,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,27,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,5,4,0,0,0,0,0,0,0,205,204,76,62,10,27,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,153,62,5,4,0,0,0,0,0,0,0,205,204,204,62]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfFloatToDouble() {
        do {
            try subject.encode([[0.1: 0.2], [0.3: 0.4]] as [[Float: Double]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,126,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,96,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,153,62,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfFloatToString() {
        do {
            try subject.encode([[0.1: "a"], [0.3: "b"]] as [[Float: String]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,112,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,82,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,1,1,0,0,0,0,0,0,0,97,10,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,153,62,1,1,0,0,0,0,0,0,0,98]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfFloatToCereal() {
        do {
            try subject.encode([[0.1: TestCerealType(foo: "bar")], [0.3: TestCerealType(foo: "baz")]] as [[Float: TestCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,56,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,153,62,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfFloatToIdentifyingCereal() {
        do {
            try subject.encode([[0.1: TestIdentifyingCerealType(foo: "bar")], [0.3: TestIdentifyingCerealType(foo: "baz")]] as [[Float: TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,202,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,172,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,153,62,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfFloatToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[0.1: first], [0.3: second]] as [[Float: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,202,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,172,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,153,62,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Double: XXX]

    func testToBytes_withArrayOfDoubleToBool() {
        do {
            try subject.encode([[0.1: false], [0.3: false]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,106,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,76,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,6,1,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,6,1,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfDoubleToInt() {
        do {
            try subject.encode([[0.1: 2], [0.3: 4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,134,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,104,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfDoubleToInt64() {
        do {
            try subject.encode([[0.1: 2], [0.3: 4]] as [[Double: Int64]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,134,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,104,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfDoubleToFloat() {
        do {
            try subject.encode([[0.1: 0.2], [0.3: 0.4]] as [[Double: Float]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,126,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,96,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,5,4,0,0,0,0,0,0,0,205,204,76,62,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,5,4,0,0,0,0,0,0,0,205,204,204,62]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfDoubleToDouble() {
        do {
            try subject.encode([[0.1: 0.2], [0.3: 0.4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,134,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,104,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfDoubleToString() {
        do {
            try subject.encode([[0.1: "a"], [0.3: "b"]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,120,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,90,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,1,1,0,0,0,0,0,0,0,97,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,1,1,0,0,0,0,0,0,0,98]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfDoubleToCereal() {
        do {
            try subject.encode([[0.1: TestCerealType(foo: "bar")], [0.3: TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,184,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,154,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfDoubleToIdentifyingCereal() {
        do {
            try subject.encode([[0.1: TestIdentifyingCerealType(foo: "bar")], [0.3: TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,210,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,180,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfDoubleToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[0.1: first], [0.3: second]] as [[Double: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,210,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,180,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [String: XXX]

    func testToBytes_withArrayOfStringToBool() {
        do {
            try subject.encode([["1": true], ["3": false]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,14,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,49,6,1,1,10,14,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,51,6,1,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfStringToInt() {
        do {
            try subject.encode([["1": 2], ["3": 4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,120,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,90,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,49,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,51,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfStringToInt64() {
        do {
            try subject.encode([["1": 2], ["3": 4]] as [[String: Int64]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,120,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,90,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,49,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,51,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfStringToFloat() {
        do {
            try subject.encode([["1": 0.2], ["3": 0.4]] as [[String: Float]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,112,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,82,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,49,5,4,0,0,0,0,0,0,0,205,204,76,62,10,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,51,5,4,0,0,0,0,0,0,0,205,204,204,62]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfStringToDouble() {
        do {
            try subject.encode([["1": 0.2], ["3": 0.4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,120,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,90,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,49,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,51,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfStringToString() {
        do {
            try subject.encode([["1": "a"], ["3": "b"]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,106,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,76,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,49,1,1,0,0,0,0,0,0,0,97,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,51,1,1,0,0,0,0,0,0,0,98]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfStringToCereal() {
        do {
            try subject.encode([["1": TestCerealType(foo: "bar")], ["3": TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,170,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,140,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,53,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,49,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,53,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,51,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfStringToIdentifyingCereal() {
        do {
            try subject.encode([["1": TestIdentifyingCerealType(foo: "bar")], ["3": TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,196,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,166,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,66,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,49,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,66,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,51,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfStringToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([["1": first], ["3": second]] as [[String: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,196,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,166,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,66,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,49,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,66,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,51,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [CerealType: XXX]

    func testToBytes_withArrayOfCerealToBool() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): true], [TestCerealType(foo: "oof"): false]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,156,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,126,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,46,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,6,1,1,10,46,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,6,1,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfCerealToInt() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): 2], [TestCerealType(foo: "oof"): 4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,184,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,154,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfCerealToInt64() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): 2], [TestCerealType(foo: "oof"): 4]] as [[TestCerealType: Int64]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,184,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,154,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfCerealToFloat() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): 0.2], [TestCerealType(foo: "oof"): 0.4]] as [[TestCerealType: Float]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,5,4,0,0,0,0,0,0,0,205,204,76,62,10,56,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,5,4,0,0,0,0,0,0,0,205,204,204,62]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfCerealToDouble() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): 0.2], [TestCerealType(foo: "oof"): 0.4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,184,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,154,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfCerealToString() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): "a"], [TestCerealType(foo: "oof"): "b"]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,170,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,140,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,53,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,1,1,0,0,0,0,0,0,0,97,10,53,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,1,1,0,0,0,0,0,0,0,98]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfCerealToCereal() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): TestCerealType(foo: "bar")], [TestCerealType(foo: "oof"): TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,234,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,204,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,85,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,85,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfCerealToIdentifyingCereal() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): TestIdentifyingCerealType(foo: "bar")], [TestCerealType(foo: "oof"): TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,4,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,230,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfCerealToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[TestCerealType(foo: "foo"): first], [TestCerealType(foo: "oof"): second]] as [[TestCerealType: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,4,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,230,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [IdentifyingCerealType: XXX]

    func testToBytes_withArrayOfIdentifyingCerealToBool() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): true], [TestIdentifyingCerealType(foo: "oof"): false]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,182,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,152,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,6,1,1,10,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,6,1,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIdentifyingCerealToInt() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): 2], [TestIdentifyingCerealType(foo: "oof"): 4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,210,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,180,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIdentifyingCerealToInt64() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): 2], [TestIdentifyingCerealType(foo: "oof"): 4]] as [[TestIdentifyingCerealType: Int64]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,210,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,180,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIdentifyingCerealToFloat() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): 0.2], [TestIdentifyingCerealType(foo: "oof"): 0.4]] as [[TestIdentifyingCerealType: Float]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,202,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,172,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,5,4,0,0,0,0,0,0,0,205,204,76,62,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,5,4,0,0,0,0,0,0,0,205,204,204,62]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIdentifyingCerealToDouble() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): 0.2], [TestIdentifyingCerealType(foo: "oof"): 0.4]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,210,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,180,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,73,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIdentifyingCerealToString() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): "a"], [TestIdentifyingCerealType(foo: "oof"): "b"]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,196,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,166,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,66,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,1,1,0,0,0,0,0,0,0,97,10,66,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,1,1,0,0,0,0,0,0,0,98]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIdentifyingCerealToCereal() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): TestCerealType(foo: "bar")], [TestIdentifyingCerealType(foo: "oof"): TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,4,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,230,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIdentifyingCerealToIdentifyingCereal() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): TestIdentifyingCerealType(foo: "bar")], [TestIdentifyingCerealType(foo: "oof"): TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,30,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,0,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,111,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,111,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withArrayOfIdentifyingCerealToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[TestIdentifyingCerealType(foo: "foo"): first], [TestIdentifyingCerealType(foo: "oof"): second]] as [[TestIdentifyingCerealType: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            let expected: [UInt8] = [11,30,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,0,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,111,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,111,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
}
