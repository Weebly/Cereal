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

    func testToString_withEmptyIntArray() {
        do {
            try subject.encode([Int](), forKey: "arrrr!")
            let result = subject.toString()
            let expected = "k,6:arrrr!:a,0:"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolArray() {
        do {
            try subject.encode([true,false,true], forKey: "arrrr!")
            let result = subject.toString()
            let expected = "k,6:arrrr!:a,17:b,1:t:b,1:f:b,1:t"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntArray() {
        do {
            try subject.encode([5,3,80], forKey: "arrrr!")
            let result = subject.toString()
            let expected = "k,6:arrrr!:a,18:i,1:5:i,1:3:i,2:80"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleArray() {
        do {
            try subject.encode([5.3,3.98,80.1], forKey: "dubs")
            let result = subject.toString()
            let expected = "k,4:dubs:a,25:d,3:5.3:d,4:3.98:d,4:80.1"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatArray() {
        do {
            try subject.encode([5.3,3.98,80.1] as [Float], forKey: "floating")
            let result = subject.toString()
            let expected = "k,8:floating:a,25:f,3:5.3:f,4:3.98:f,4:80.1"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringArray() {
        do {
            try subject.encode(["one","two","three"], forKey: "string")
            let result = subject.toString()
            let expected = "k,6:string:a,25:s,3:one:s,3:two:s,5:three"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withUnsupportedCerealRepresentable_returnsCorrectError() {
        do {
            try subject.encode(NSData(), forKey: "string")
            XCTFail("Exepcted an error to be thrown")
        } catch CerealError.UnsupportedCerealRepresentable {
            // The test passes if this block is executed
        } catch {
            XCTFail("The expected type of error was not thrown")
        }
    }

    func testToString_withCerealTypeArray() {
        do {
            let customType = TestCerealType(foo: "bar")

            try subject.encode([customType], forKey: "wat")

            let result = subject.toString()
            let expected = "k,3:wat:a,20:c,15:k,3:foo:s,3:bar"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealTypeArray() {
        do {
            let customType = TestIdentifyingCerealType(foo: "bar")
            try subject.encode([customType], forKey: "wat")

            let result = subject.toString()
            let expected = "k,3:wat:a,27:p,22:4:tict:k,3:foo:s,3:bar"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withProtocoledIdentifyingCerealTypeArray() {
        do {
            let customType: Fooable = TestIdentifyingCerealType(foo: "bar")
            try subject.encodeIdentifyingItems([customType], forKey: "wat")

            let result = subject.toString()
            let expected = "k,3:wat:a,27:p,22:4:tict:k,3:foo:s,3:bar"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - Array of Dictionaries

    // MARK: [Bool: XXX]

    func testToString_withArrayOfBoolToBool() {
        do {
            try subject.encode([[true: true], [false: false]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:b,1:t:b,1:t:m,11:b,1:f:b,1:f"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfBoolToInt() {
        do {
            try subject.encode([[true: 2], [true: 4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:b,1:t:i,1:2:m,11:b,1:t:i,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfBoolToInt64() {
        do {
            try subject.encode([[false: 2], [false: 4]] as [[Bool: Int64]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:b,1:f:z,1:2:m,11:b,1:f:z,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfBoolToFloat() {
        do {
            try subject.encode([[false: 0.2], [true: 0.4]] as [[Bool: Float]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:b,1:f:f,3:0.2:m,13:b,1:t:f,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfBoolToDouble() {
        do {
            try subject.encode([[true: 0.2], [false: 0.4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:b,1:t:d,3:0.2:m,13:b,1:f:d,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfBoolToString() {
        do {
            try subject.encode([[true: "a"], [false: "b"]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:b,1:t:s,1:a:m,11:b,1:f:s,1:b"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfBoolToCereal() {
        do {
            try subject.encode([[true: TestCerealType(foo: "bar")], [false: TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,63:m,26:b,1:t:c,15:k,3:foo:s,3:bar:m,26:b,1:f:c,15:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfBoolToIdentifyingCereal() {
        do {
            try subject.encode([[true: TestIdentifyingCerealType(foo: "bar")], [false: TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:b,1:t:p,22:4:tict:k,3:foo:s,3:bar:m,33:b,1:f:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfBoolToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[true: first], [false: second]] as [[Bool: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:b,1:t:p,22:4:tict:k,3:foo:s,3:bar:m,33:b,1:f:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int: XXX]

    func testToString_withArrayOfIntToBool() {
        do {
            try subject.encode([[1: true], [3: false]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:i,1:1:b,1:t:m,11:i,1:3:b,1:f"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIntToInt() {
        do {
            try subject.encode([[1: 2], [3: 4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:i,1:1:i,1:2:m,11:i,1:3:i,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIntToInt64() {
        do {
            try subject.encode([[1: 2], [3: 4]] as [[Int: Int64]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:i,1:1:z,1:2:m,11:i,1:3:z,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIntToFloat() {
        do {
            try subject.encode([[1: 0.2], [3: 0.4]] as [[Int: Float]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:i,1:1:f,3:0.2:m,13:i,1:3:f,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIntToDouble() {
        do {
            try subject.encode([[1: 0.2], [3: 0.4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:i,1:1:d,3:0.2:m,13:i,1:3:d,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIntToString() {
        do {
            try subject.encode([[1: "a"], [3: "b"]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:i,1:1:s,1:a:m,11:i,1:3:s,1:b"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIntToCereal() {
        do {
            try subject.encode([[1: TestCerealType(foo: "bar")], [3: TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,63:m,26:i,1:1:c,15:k,3:foo:s,3:bar:m,26:i,1:3:c,15:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIntToIdentifyingCereal() {
        do {
            try subject.encode([[1: TestIdentifyingCerealType(foo: "bar")], [3: TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:i,1:1:p,22:4:tict:k,3:foo:s,3:bar:m,33:i,1:3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIntToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[1: first], [3: second]] as [[Int: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:i,1:1:p,22:4:tict:k,3:foo:s,3:bar:m,33:i,1:3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int64: XXX]

    func testToString_withArrayOfInt64ToBool() {
        do {
            try subject.encode([[1: true], [3: true]] as [[Int64: Bool]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:z,1:1:b,1:t:m,11:z,1:3:b,1:t"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfInt64ToInt() {
        do {
            try subject.encode([[1: 2], [3: 4]] as [[Int64: Int]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:z,1:1:i,1:2:m,11:z,1:3:i,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfInt64ToInt64() {
        do {
            try subject.encode([[1: 2], [3: 4]] as [[Int64: Int64]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:z,1:1:z,1:2:m,11:z,1:3:z,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfInt64ToFloat() {
        do {
            try subject.encode([[1: 0.2], [3: 0.4]] as [[Int64: Float]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:z,1:1:f,3:0.2:m,13:z,1:3:f,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfInt64ToDouble() {
        do {
            try subject.encode([[1: 0.2], [3: 0.4]] as [[Int64: Double]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:z,1:1:d,3:0.2:m,13:z,1:3:d,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfInt64ToString() {
        do {
            try subject.encode([[1: "a"], [3: "b"]] as [[Int64: String]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:z,1:1:s,1:a:m,11:z,1:3:s,1:b"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfInt64ToCereal() {
        do {
            try subject.encode([[1: TestCerealType(foo: "bar")], [3: TestCerealType(foo: "baz")]] as [[Int64: TestCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,63:m,26:z,1:1:c,15:k,3:foo:s,3:bar:m,26:z,1:3:c,15:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfInt64ToIdentifyingCereal() {
        do {
            try subject.encode([[1: TestIdentifyingCerealType(foo: "bar")], [3: TestIdentifyingCerealType(foo: "baz")]] as [[Int64: TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:z,1:1:p,22:4:tict:k,3:foo:s,3:bar:m,33:z,1:3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfInt64ToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[1: first], [3: second]] as [[Int64: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:z,1:1:p,22:4:tict:k,3:foo:s,3:bar:m,33:z,1:3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Float: XXX]

    func testToString_withArrayOfFloatToBool() {
        do {
            try subject.encode([[0.1: false], [0.3: false]] as [[Float: Bool]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:f,3:0.1:b,1:f:m,13:f,3:0.3:b,1:f"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfFloatToInt() {
        do {
            try subject.encode([[0.1: 2], [0.3: 4]] as [[Float: Int]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:f,3:0.1:i,1:2:m,13:f,3:0.3:i,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfFloatToInt64() {
        do {
            try subject.encode([[0.1: 2], [0.3: 4]] as [[Float: Int64]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:f,3:0.1:z,1:2:m,13:f,3:0.3:z,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfFloatToFloat() {
        do {
            try subject.encode([[0.1: 0.2], [0.3: 0.4]] as [[Float: Float]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,41:m,15:f,3:0.1:f,3:0.2:m,15:f,3:0.3:f,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfFloatToDouble() {
        do {
            try subject.encode([[0.1: 0.2], [0.3: 0.4]] as [[Float: Double]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,41:m,15:f,3:0.1:d,3:0.2:m,15:f,3:0.3:d,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfFloatToString() {
        do {
            try subject.encode([[0.1: "a"], [0.3: "b"]] as [[Float: String]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:f,3:0.1:s,1:a:m,13:f,3:0.3:s,1:b"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfFloatToCereal() {
        do {
            try subject.encode([[0.1: TestCerealType(foo: "bar")], [0.3: TestCerealType(foo: "baz")]] as [[Float: TestCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,67:m,28:f,3:0.1:c,15:k,3:foo:s,3:bar:m,28:f,3:0.3:c,15:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfFloatToIdentifyingCereal() {
        do {
            try subject.encode([[0.1: TestIdentifyingCerealType(foo: "bar")], [0.3: TestIdentifyingCerealType(foo: "baz")]] as [[Float: TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,81:m,35:f,3:0.1:p,22:4:tict:k,3:foo:s,3:bar:m,35:f,3:0.3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfFloatToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[0.1: first], [0.3: second]] as [[Float: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,81:m,35:f,3:0.1:p,22:4:tict:k,3:foo:s,3:bar:m,35:f,3:0.3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Double: XXX]

    func testToString_withArrayOfDoubleToBool() {
        do {
            try subject.encode([[0.1: false], [0.3: false]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:d,3:0.1:b,1:f:m,13:d,3:0.3:b,1:f"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfDoubleToInt() {
        do {
            try subject.encode([[0.1: 2], [0.3: 4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:d,3:0.1:i,1:2:m,13:d,3:0.3:i,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfDoubleToInt64() {
        do {
            try subject.encode([[0.1: 2], [0.3: 4]] as [[Double: Int64]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:d,3:0.1:z,1:2:m,13:d,3:0.3:z,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfDoubleToFloat() {
        do {
            try subject.encode([[0.1: 0.2], [0.3: 0.4]] as [[Double: Float]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,41:m,15:d,3:0.1:f,3:0.2:m,15:d,3:0.3:f,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfDoubleToDouble() {
        do {
            try subject.encode([[0.1: 0.2], [0.3: 0.4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,41:m,15:d,3:0.1:d,3:0.2:m,15:d,3:0.3:d,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfDoubleToString() {
        do {
            try subject.encode([[0.1: "a"], [0.3: "b"]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:d,3:0.1:s,1:a:m,13:d,3:0.3:s,1:b"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfDoubleToCereal() {
        do {
            try subject.encode([[0.1: TestCerealType(foo: "bar")], [0.3: TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,67:m,28:d,3:0.1:c,15:k,3:foo:s,3:bar:m,28:d,3:0.3:c,15:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfDoubleToIdentifyingCereal() {
        do {
            try subject.encode([[0.1: TestIdentifyingCerealType(foo: "bar")], [0.3: TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,81:m,35:d,3:0.1:p,22:4:tict:k,3:foo:s,3:bar:m,35:d,3:0.3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfDoubleToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[0.1: first], [0.3: second]] as [[Double: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,81:m,35:d,3:0.1:p,22:4:tict:k,3:foo:s,3:bar:m,35:d,3:0.3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [String: XXX]

    func testToString_withArrayOfStringToBool() {
        do {
            try subject.encode([["1": true], ["3": false]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:s,1:1:b,1:t:m,11:s,1:3:b,1:f"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfStringToInt() {
        do {
            try subject.encode([["1": 2], ["3": 4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:s,1:1:i,1:2:m,11:s,1:3:i,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfStringToInt64() {
        do {
            try subject.encode([["1": 2], ["3": 4]] as [[String: Int64]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:s,1:1:z,1:2:m,11:s,1:3:z,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfStringToFloat() {
        do {
            try subject.encode([["1": 0.2], ["3": 0.4]] as [[String: Float]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:s,1:1:f,3:0.2:m,13:s,1:3:f,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfStringToDouble() {
        do {
            try subject.encode([["1": 0.2], ["3": 0.4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,37:m,13:s,1:1:d,3:0.2:m,13:s,1:3:d,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfStringToString() {
        do {
            try subject.encode([["1": "a"], ["3": "b"]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,33:m,11:s,1:1:s,1:a:m,11:s,1:3:s,1:b"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfStringToCereal() {
        do {
            try subject.encode([["1": TestCerealType(foo: "bar")], ["3": TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,63:m,26:s,1:1:c,15:k,3:foo:s,3:bar:m,26:s,1:3:c,15:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfStringToIdentifyingCereal() {
        do {
            try subject.encode([["1": TestIdentifyingCerealType(foo: "bar")], ["3": TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:s,1:1:p,22:4:tict:k,3:foo:s,3:bar:m,33:s,1:3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfStringToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([["1": first], ["3": second]] as [[String: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:s,1:1:p,22:4:tict:k,3:foo:s,3:bar:m,33:s,1:3:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [CerealType: XXX]

    func testToString_withArrayOfCerealToBool() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): true], [TestCerealType(foo: "oof"): false]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,63:m,26:c,15:k,3:foo:s,3:foo:b,1:t:m,26:c,15:k,3:foo:s,3:oof:b,1:f"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfCerealToInt() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): 2], [TestCerealType(foo: "oof"): 4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,63:m,26:c,15:k,3:foo:s,3:foo:i,1:2:m,26:c,15:k,3:foo:s,3:oof:i,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfCerealToInt64() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): 2], [TestCerealType(foo: "oof"): 4]] as [[TestCerealType: Int64]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,63:m,26:c,15:k,3:foo:s,3:foo:z,1:2:m,26:c,15:k,3:foo:s,3:oof:z,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfCerealToFloat() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): 0.2], [TestCerealType(foo: "oof"): 0.4]] as [[TestCerealType: Float]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,67:m,28:c,15:k,3:foo:s,3:foo:f,3:0.2:m,28:c,15:k,3:foo:s,3:oof:f,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfCerealToDouble() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): 0.2], [TestCerealType(foo: "oof"): 0.4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,67:m,28:c,15:k,3:foo:s,3:foo:d,3:0.2:m,28:c,15:k,3:foo:s,3:oof:d,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfCerealToString() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): "a"], [TestCerealType(foo: "oof"): "b"]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,63:m,26:c,15:k,3:foo:s,3:foo:s,1:a:m,26:c,15:k,3:foo:s,3:oof:s,1:b"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfCerealToCereal() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): TestCerealType(foo: "bar")], [TestCerealType(foo: "oof"): TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,93:m,41:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:bar:m,41:c,15:k,3:foo:s,3:oof:c,15:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfCerealToIdentifyingCereal() {
        do {
            try subject.encode([[TestCerealType(foo: "foo"): TestIdentifyingCerealType(foo: "bar")], [TestCerealType(foo: "oof"): TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,107:m,48:c,15:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:bar:m,48:c,15:k,3:foo:s,3:oof:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfCerealToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[TestCerealType(foo: "foo"): first], [TestCerealType(foo: "oof"): second]] as [[TestCerealType: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,107:m,48:c,15:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:bar:m,48:c,15:k,3:foo:s,3:oof:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [IdentifyingCerealType: XXX]

    func testToString_withArrayOfIdentifyingCerealToBool() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): true], [TestIdentifyingCerealType(foo: "oof"): false]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:p,22:4:tict:k,3:foo:s,3:foo:b,1:t:m,33:p,22:4:tict:k,3:foo:s,3:oof:b,1:f"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIdentifyingCerealToInt() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): 2], [TestIdentifyingCerealType(foo: "oof"): 4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:p,22:4:tict:k,3:foo:s,3:foo:i,1:2:m,33:p,22:4:tict:k,3:foo:s,3:oof:i,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIdentifyingCerealToInt64() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): 2], [TestIdentifyingCerealType(foo: "oof"): 4]] as [[TestIdentifyingCerealType: Int64]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:p,22:4:tict:k,3:foo:s,3:foo:z,1:2:m,33:p,22:4:tict:k,3:foo:s,3:oof:z,1:4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIdentifyingCerealToFloat() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): 0.2], [TestIdentifyingCerealType(foo: "oof"): 0.4]] as [[TestIdentifyingCerealType: Float]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,81:m,35:p,22:4:tict:k,3:foo:s,3:foo:f,3:0.2:m,35:p,22:4:tict:k,3:foo:s,3:oof:f,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIdentifyingCerealToDouble() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): 0.2], [TestIdentifyingCerealType(foo: "oof"): 0.4]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,81:m,35:p,22:4:tict:k,3:foo:s,3:foo:d,3:0.2:m,35:p,22:4:tict:k,3:foo:s,3:oof:d,3:0.4"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIdentifyingCerealToString() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): "a"], [TestIdentifyingCerealType(foo: "oof"): "b"]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,77:m,33:p,22:4:tict:k,3:foo:s,3:foo:s,1:a:m,33:p,22:4:tict:k,3:foo:s,3:oof:s,1:b"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIdentifyingCerealToCereal() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): TestCerealType(foo: "bar")], [TestIdentifyingCerealType(foo: "oof"): TestCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,107:m,48:p,22:4:tict:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:bar:m,48:p,22:4:tict:k,3:foo:s,3:oof:c,15:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIdentifyingCerealToIdentifyingCereal() {
        do {
            try subject.encode([[TestIdentifyingCerealType(foo: "foo"): TestIdentifyingCerealType(foo: "bar")], [TestIdentifyingCerealType(foo: "oof"): TestIdentifyingCerealType(foo: "baz")]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,121:m,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:bar:m,55:p,22:4:tict:k,3:foo:s,3:oof:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withArrayOfIdentifyingCerealToProtocoledIdentifyingCereal() {
        do {
            let first: Fooable = TestIdentifyingCerealType(foo: "bar")
            let second: Fooable = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([[TestIdentifyingCerealType(foo: "foo"): first], [TestIdentifyingCerealType(foo: "oof"): second]] as [[TestIdentifyingCerealType: IdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            let expected = "k,3:wat:a,121:m,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:bar:m,55:p,22:4:tict:k,3:foo:s,3:oof:p,22:4:tict:k,3:foo:s,3:baz"
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
}
