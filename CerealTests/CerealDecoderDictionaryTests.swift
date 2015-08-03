//
//  CerealDecoderDictionaryTests.swift
//  Cereal
//
//  Created by James Richard on 8/15/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import XCTest
@testable import Cereal

class CerealDecoderDictionaryTests: XCTestCase {

    override func tearDown() {
        Cereal.clearRegisteredCerealTypes()
        super.tearDown()
    }

    // MARK: - [ABC: XYZ] -

    // MARK: [Bool: XYZ]

    func testDecoding_withBoolToBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,11:b,1:t:b,1:f")
            if let dict: [Bool: Bool] = try subject.decode("hi") {
                XCTAssertEqual(dict[true], false)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,12:b,1:t:i,2:10")
            if let dict: [Bool: Int] = try subject.decode("hi") {
                XCTAssertEqual(dict[true], 10)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,13:b,1:f:s,3:foo")
            if let dict: [Bool: String] = try subject.decode("hi") {
                XCTAssertEqual(dict[false], "foo")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,29:b,1:t:z,18:123456789012345678")
            if let dict: [Bool: Int64] = try subject.decode("hi") {
                XCTAssertEqual(dict[true], 123456789012345678 as Int64)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,13:b,1:t:d,3:3.9")
            if let dict: [Bool: Double] = try subject.decode("hi") {
                XCTAssertEqual(dict[true], 3.9)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,14:b,1:f:f,4:3.14")
            if let dict: [Bool: Float] = try subject.decode("hi") {
                XCTAssertEqual(dict[false], 3.14)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [Int: XYZ]

    func testDecoding_withIntToBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,11:i,1:0:b,1:t")
            if let dict: [Int: Bool] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], true)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,12:i,1:0:i,2:10")
            if let dict: [Int: Int] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], 10)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,13:i,1:0:s,3:foo")
            if let dict: [Int: String] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], "foo")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,29:i,1:0:z,18:123456789012345678")
            if let dict: [Int: Int64] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], 123456789012345678 as Int64)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,13:i,1:0:d,3:3.9")
            if let dict: [Int: Double] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], 3.9)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,14:i,1:0:f,4:3.14")
            if let dict: [Int: Float] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], 3.14)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [Int64: XYZ]

    func testDecoding_withInt64ToBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,11:z,1:0:b,1:t")
            if let dict: [Int64: Bool] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], true)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,12:z,1:0:i,2:10")
            if let dict: [Int64: Int] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], 10)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,13:z,1:0:s,3:foo")
            if let dict: [Int64: String] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], "foo")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,29:z,1:0:z,18:123456789012345678")
            if let dict: [Int64: Int64] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], 123456789012345678 as Int64)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,13:z,1:0:d,3:3.9")
            if let dict: [Int64: Double] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], 3.9)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,14:z,1:0:f,4:3.14")
            if let dict: [Int64: Float] = try subject.decode("hi") {
                XCTAssertEqual(dict[0], 3.14)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [String: XYZ]

    func testDecoding_withStringToBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,15:s,5:hello:b,1:t")
            if let dict: [String: Bool] = try subject.decode("hi") {
                XCTAssertEqual(dict["hello"], true)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,17:s,5:hello:i,3:123")
            if let dict: [String: Int] = try subject.decode("hi") {
                XCTAssertEqual(dict["hello"], 123)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,33:s,5:hello:z,18:123456789012345678")
            if let dict: [String: Int64] = try subject.decode("hi") {
                XCTAssertEqual(dict["hello"], 123456789012345678 as Int64)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,19:s,5:hello:s,5:world")
            if let dict: [String: String] = try subject.decode("hi") {
                XCTAssertEqual(dict["hello"], "world")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,19:s,5:hello:f,5:0.513")
            if let dict: [String: Float] = try subject.decode("hi") {
                XCTAssertEqual(dict["hello"], 0.513)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,19:s,5:hello:d,5:9.513")
            if let dict: [String: Double] = try subject.decode("hi") {
                XCTAssertEqual(dict["hello"], 9.513)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [Float: XYZ]

    func testDecoding_withFloatToBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,14:f,4:3.14:b,1:f")
            if let dict: [Float: Bool] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], false)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,15:f,4:3.14:i,2:10")
            if let dict: [Float: Int] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], 10)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,16:f,4:3.14:s,3:foo")
            if let dict: [Float: String] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], "foo")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,32:f,4:3.14:z,18:123456789012345678")
            if let dict: [Float: Int64] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], 123456789012345678 as Int64)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,16:f,4:3.14:d,3:3.9")
            if let dict: [Float: Double] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], 3.9)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,16:f,4:3.14:f,3:9.9")
            if let dict: [Float: Float] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], 9.9)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [Double: XYZ]

    func testDecoding_withDoubleToBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,14:d,4:3.14:b,1:t")
            if let dict: [Double: Bool] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], true)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,15:d,4:3.14:i,2:10")
            if let dict: [Double: Int] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], 10)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,16:d,4:3.14:s,3:foo")
            if let dict: [Double: String] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], "foo")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,32:d,4:3.14:z,18:123456789012345678")
            if let dict: [Double: Int64] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], 123456789012345678 as Int64)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,16:d,4:3.14:d,3:3.9")
            if let dict: [Double: Double] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], 3.9)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,16:d,4:3.14:f,3:9.9")
            if let dict: [Double: Float] = try subject.decode("hi") {
                XCTAssertEqual(dict[3.14], 9.9)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: Heterogeneous

    func testDecoding_withBoolToHeterogeneousDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,28:b,1:t:f,4:3.14:b,1:f:d,3:1.3")
            if let dict: [Bool: CerealRepresentable] = try subject.decode("hi") {
                XCTAssertEqual(dict[true] as? Float, 3.14)
                XCTAssertEqual(dict[false] as? Double, 1.3)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToHeterogeneousDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,72:i,1:0:f,4:3.14:i,1:1:d,3:1.3:i,1:2:s,4:roxy:i,1:3:i,2:47:i,1:4:z,5:12345")
            if let dict: [Int: CerealRepresentable] = try subject.decode("hi") {
                XCTAssertEqual(dict[0] as? Float, 3.14)
                XCTAssertEqual(dict[1] as? Double, 1.3)
                XCTAssertEqual(dict[2] as? String, "roxy")
                XCTAssertEqual(dict[3] as? Int, 47)
                XCTAssertEqual(dict[4] as? Int64, 12345)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToHeterogeneousDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,72:z,1:0:f,4:3.14:z,1:1:d,3:1.3:z,1:2:s,4:roxy:z,1:3:i,2:47:z,1:4:z,5:12345")
            if let dict: [Int64: CerealRepresentable] = try subject.decode("hi") {
                XCTAssertEqual(dict[0] as? Float, 3.14)
                XCTAssertEqual(dict[1] as? Double, 1.3)
                XCTAssertEqual(dict[2] as? String, "roxy")
                XCTAssertEqual(dict[3] as? Int, 47)
                XCTAssertEqual(dict[4] as? Int64, 12345)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToHeterogeneousDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,72:s,1:a:f,4:3.14:s,1:b:d,3:1.3:s,1:c:s,4:roxy:s,1:d:i,2:47:s,1:e:z,5:12345")
            if let dict: [String: CerealRepresentable] = try subject.decode("hi") {
                XCTAssertEqual(dict["a"] as? Float, 3.14)
                XCTAssertEqual(dict["b"] as? Double, 1.3)
                XCTAssertEqual(dict["c"] as? String, "roxy")
                XCTAssertEqual(dict["d"] as? Int, 47)
                XCTAssertEqual(dict["e"] as? Int64, 12345)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToHeterogeneousDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,82:f,3:0.1:f,4:3.14:f,3:1.1:d,3:1.3:f,3:1.2:s,4:roxy:f,3:1.3:i,2:47:f,3:1.4:z,5:12345")
            if let dict: [Float: CerealRepresentable] = try subject.decode("hi") {
                XCTAssertEqual(dict[0.1] as? Float, 3.14)
                XCTAssertEqual(dict[1.1] as? Double, 1.3)
                XCTAssertEqual(dict[1.2] as? String, "roxy")
                XCTAssertEqual(dict[1.3] as? Int, 47)
                XCTAssertEqual(dict[1.4] as? Int64, 12345)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToHeterogeneousDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,82:d,3:0.1:f,4:3.14:d,3:1.1:d,3:1.3:d,3:1.2:s,4:roxy:d,3:1.3:i,2:47:d,3:1.4:z,5:12345")
            if let dict: [Double: CerealRepresentable] = try subject.decode("hi") {
                XCTAssertEqual(dict[0.1] as? Float, 3.14)
                XCTAssertEqual(dict[1.1] as? Double, 1.3)
                XCTAssertEqual(dict[1.2] as? String, "roxy")
                XCTAssertEqual(dict[1.3] as? Int, 47)
                XCTAssertEqual(dict[1.4] as? Int64, 12345)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [CerealType: XYZ]

    func testDecoding_withIntToCustomDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:m,26:i,1:0:c,15:k,3:foo:s,3:bar")
            if let result: [Int: TestCerealType] = try subject.decodeCereal("test") {
                XCTAssertEqual(result[0]?.foo, "bar")
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCustomToBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:m,26:c,15:k,3:foo:s,3:baz:b,1:t")
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Bool] = try subject.decodeCereal("test") {
                XCTAssertEqual(result[key], true)
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCustomToIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:m,26:c,15:k,3:foo:s,3:baz:i,1:5")
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Int] = try subject.decodeCereal("test") {
                XCTAssertEqual(result[key], 5)
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCustomToInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:m,44:c,15:k,3:foo:s,3:baz:z,18:123456789012345678")
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Int64] = try subject.decodeCereal("test") {
                XCTAssertEqual(result[key], 123456789012345678)
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCustomToStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:m,30:c,15:k,3:foo:s,3:baz:s,5:hello")
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: String] = try subject.decodeCereal("test") {
                XCTAssertEqual(result[key], "hello")
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCustomToFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:m,31:c,15:k,3:foo:s,3:baz:f,6:123.45")
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Float] = try subject.decodeCereal("test") {
                XCTAssertEqual(result[key], 123.45)
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCustomToDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:m,31:c,15:k,3:foo:s,3:baz:d,6:12.345")
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Double] = try subject.decodeCereal("test") {
                XCTAssertEqual(result[key], 12.345)
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [CerealType: CerealType]

    func testDecoding_withCustomToCustomDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,4:test:m,41:c,15:k,3:foo:s,3:baz:c,15:k,3:foo:s,3:bar")
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: TestCerealType] = try subject.decodeCerealPair("test") {
                XCTAssertEqual(result[key]?.foo, "bar")
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }


    // MARK: - [ABC: [XYZ]] -

    // MARK: [Bool: [XYZ]]

    func testDecoding_withBoolToArrayOfBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,22:b,1:t:a,11:b,1:t:b,1:f")
            if let dict: [Bool: [Bool]] = try subject.decode("hi") {
                guard let array = dict[true] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [true,false])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToArrayOfIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:b,1:t:a,13:i,2:10:i,2:20")
            if let dict: [Bool: [Int]] = try subject.decode("hi") {
                guard let array = dict[true] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToArrayOfInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:b,1:f:a,13:z,2:10:z,2:20")
            if let dict: [Bool: [Int64]] = try subject.decode("hi") {
                guard let array = dict[false] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToArrayOfStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:b,1:t:a,13:s,2:hi:s,2:yo")
            if let dict: [Bool: [String]] = try subject.decode("hi") {
                guard let array = dict[true] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == ["hi","yo"])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToArrayOfFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:b,1:t:a,15:f,3:1.0:f,3:2.0")
            if let dict: [Bool: [Float]] = try subject.decode("hi") {
                guard let array = dict[true] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToArrayOfDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:b,1:t:a,15:d,3:1.0:d,3:2.0")
            if let dict: [Bool: [Double]] = try subject.decode("hi") {
                guard let array = dict[true] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToArrayOfCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,52:b,1:t:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz")
            if let dict: [Bool: [TestCerealType]] = try subject.decodeCereal("hi") {
                guard let array = dict[true] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToArrayOfIdentifyingCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,68:b,1:t:a,57:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz")
            if let dict: [Bool: [MyBar]] = try subject.decodeCereal("hi") {
                guard let array = dict[true] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [MyBar(bar: "bar"), MyBar(bar: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withBoolToArrayOfProtocolIdentifyingCerealTypeDictionary() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,66:b,1:f:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz")
            if let dict: [Bool: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary("hi") {
                guard let array: [Fooable] = dict[false]?.CER_casted() else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertEqual(array.first?.foo, "bar")
                XCTAssertEqual(array.last?.foo, "baz")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [Int: [XYZ]]

    func testDecoding_withIntToArrayOfBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,22:i,1:0:a,11:b,1:t:b,1:f")
            if let dict: [Int: [Bool]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [true,false])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToArrayOfIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:i,1:0:a,13:i,2:10:i,2:20")
            if let dict: [Int: [Int]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToArrayOfInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:i,1:0:a,13:z,2:10:z,2:20")
            if let dict: [Int: [Int64]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToArrayOfStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:i,1:0:a,13:s,2:hi:s,2:yo")
            if let dict: [Int: [String]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == ["hi","yo"])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToArrayOfFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:i,1:0:a,15:f,3:1.0:f,3:2.0")
            if let dict: [Int: [Float]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToArrayOfDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:i,1:0:a,15:d,3:1.0:d,3:2.0")
            if let dict: [Int: [Double]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToArrayOfCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,52:i,1:0:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz")
            if let dict: [Int: [TestCerealType]] = try subject.decodeCereal("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToArrayOfIdentifyingCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,68:i,1:0:a,57:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz")
            if let dict: [Int: [MyBar]] = try subject.decodeCereal("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [MyBar(bar: "bar"), MyBar(bar: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntToArrayOfProtocolIdentifyingCerealTypeDictionary() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,66:i,1:0:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz")
            if let dict: [Int: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary("hi") {
                guard let array: [Fooable] = dict[0]?.CER_casted() else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertEqual(array.first?.foo, "bar")
                XCTAssertEqual(array.last?.foo, "baz")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [Int64: [XYZ]]

    func testDecoding_withInt64ToArrayOfBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,22:z,1:0:a,11:b,1:t:b,1:f")
            if let dict: [Int64: [Bool]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [true,false])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToArrayOfIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:z,1:0:a,13:i,2:10:i,2:20")
            if let dict: [Int64: [Int]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToArrayOfInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:z,1:0:a,13:z,2:10:z,2:20")
            if let dict: [Int64: [Int64]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToArrayOfStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:z,1:0:a,13:s,2:hi:s,2:yo")
            if let dict: [Int64: [String]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == ["hi","yo"])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToArrayOfFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:z,1:0:a,15:f,3:1.0:f,3:2.0")
            if let dict: [Int64: [Float]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToArrayOfDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:z,1:0:a,15:d,3:1.0:d,3:2.0")
            if let dict: [Int64: [Double]] = try subject.decode("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToArrayOfCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,52:z,1:0:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz")
            if let dict: [Int64: [TestCerealType]] = try subject.decodeCereal("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToArrayOfIdentifyingCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,68:z,1:0:a,57:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz")
            if let dict: [Int64: [MyBar]] = try subject.decodeCereal("hi") {
                guard let array = dict[0] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [MyBar(bar: "bar"), MyBar(bar: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64ToArrayOfProtocolIdentifyingCerealTypeDictionary() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,66:z,1:0:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz")
            if let dict: [Int64: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary("hi") {
                guard let array: [Fooable] = dict[0]?.CER_casted() else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertEqual(array.first?.foo, "bar")
                XCTAssertEqual(array.last?.foo, "baz")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [String: [XYZ]]

    func testDecoding_withStringToArrayOfBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,22:s,1:x:a,11:b,1:f:b,1:t")
            if let dict: [String: [Bool]] = try subject.decode("hi") {
                guard let array = dict["x"] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [false,true])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToArrayOfIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:s,1:x:a,13:i,2:10:i,2:20")
            if let dict: [String: [Int]] = try subject.decode("hi") {
                guard let array = dict["x"] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToArrayOfInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:s,1:x:a,13:z,2:10:z,2:20")
            if let dict: [String: [Int64]] = try subject.decode("hi") {
                guard let array = dict["x"] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToArrayOfStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:s,1:x:a,13:s,2:hi:s,2:yo")
            if let dict: [String: [String]] = try subject.decode("hi") {
                guard let array = dict["x"] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == ["hi","yo"])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToArrayOfFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:s,1:x:a,15:f,3:1.0:f,3:2.0")
            if let dict: [String: [Float]] = try subject.decode("hi") {
                guard let array = dict["x"] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToArrayOfDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:s,1:x:a,15:d,3:1.0:d,3:2.0")
            if let dict: [String: [Double]] = try subject.decode("hi") {
                guard let array = dict["x"] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToArrayOfCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,52:s,1:x:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz")
            if let dict: [String: [TestCerealType]] = try subject.decodeCereal("hi") {
                guard let array = dict["x"] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToArrayOfIdentifyingCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,68:s,1:x:a,57:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz")
            if let dict: [String: [MyBar]] = try subject.decodeCereal("hi") {
                guard let array = dict["x"] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [MyBar(bar: "bar"), MyBar(bar: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringToArrayOfProtocolIdentifyingCerealTypeDictionary() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,66:s,1:x:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz")
            if let dict: [String: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary("hi") {
                guard let array: [Fooable] = dict["x"]?.CER_casted() else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertEqual(array.first?.foo, "bar")
                XCTAssertEqual(array.last?.foo, "baz")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [Float: [XYZ]]

    func testDecoding_withFloatToArrayOfBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:f,3:0.1:a,11:b,1:t:b,1:t")
            if let dict: [Float: [Bool]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [true,true])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToArrayOfIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:f,3:0.1:a,13:i,2:10:i,2:20")
            if let dict: [Float: [Int]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToArrayOfInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:f,3:0.1:a,13:z,2:10:z,2:20")
            if let dict: [Float: [Int64]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToArrayOfStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:f,3:0.1:a,13:s,2:hi:s,2:yo")
            if let dict: [Float: [String]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == ["hi","yo"])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToArrayOfFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,28:f,3:0.1:a,15:f,3:1.0:f,3:2.0")
            if let dict: [Float: [Float]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToArrayOfDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,28:f,3:0.1:a,15:d,3:1.0:d,3:2.0")
            if let dict: [Float: [Double]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToArrayOfCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,54:f,3:0.1:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz")
            if let dict: [Float: [TestCerealType]] = try subject.decodeCereal("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToArrayOfIdentifyingCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,70:f,3:0.1:a,57:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz")
            if let dict: [Float: [MyBar]] = try subject.decodeCereal("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [MyBar(bar: "bar"), MyBar(bar: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatToArrayOfProtocolIdentifyingCerealTypeDictionary() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,68:f,3:0.1:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz")
            if let dict: [Float: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary("hi") {
                guard let array: [Fooable] = dict[0.1]?.CER_casted() else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertEqual(array.first?.foo, "bar")
                XCTAssertEqual(array.last?.foo, "baz")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [Double: [XYZ]]

    func testDecoding_withDoubleToArrayOfBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,24:d,3:0.1:a,11:b,1:f:b,1:f")
            if let dict: [Double: [Bool]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [false,false])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToArrayOfIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:d,3:0.1:a,13:i,2:10:i,2:20")
            if let dict: [Double: [Int]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToArrayOfInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:d,3:0.1:a,13:z,2:10:z,2:20")
            if let dict: [Double: [Int64]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToArrayOfStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,26:d,3:0.1:a,13:s,2:hi:s,2:yo")
            if let dict: [Double: [String]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == ["hi","yo"])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToArrayOfFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,28:d,3:0.1:a,15:f,3:1.0:f,3:2.0")
            if let dict: [Double: [Float]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToArrayOfDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,28:d,3:0.1:a,15:d,3:1.0:d,3:2.0")
            if let dict: [Double: [Double]] = try subject.decode("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToArrayOfCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,54:d,3:0.1:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz")
            if let dict: [Double: [TestCerealType]] = try subject.decodeCereal("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToArrayOfIdentifyingCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,70:d,3:0.1:a,57:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz")
            if let dict: [Double: [MyBar]] = try subject.decodeCereal("hi") {
                guard let array = dict[0.1] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [MyBar(bar: "bar"), MyBar(bar: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleToArrayOfProtocolIdentifyingCerealTypeDictionary() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,68:d,3:0.1:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz")
            if let dict: [Double: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary("hi") {
                guard let array: [Fooable] = dict[0.1]?.CER_casted() else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertEqual(array.first?.foo, "bar")
                XCTAssertEqual(array.last?.foo, "baz")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [CerealType: [XYZ]]

    func testDecoding_withCerealTypeToArrayOfBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,37:c,15:k,3:foo:s,3:bar:a,11:b,1:t:b,1:f")
            if let dict: [TestCerealType: [Bool]] = try subject.decodeCereal("hi") {
                guard let array = dict[TestCerealType(foo: "bar")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [true,false])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCerealTypeToArrayOfIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,39:c,15:k,3:foo:s,3:bar:a,13:i,2:10:i,2:20")
            if let dict: [TestCerealType: [Int]] = try subject.decodeCereal("hi") {
                guard let array = dict[TestCerealType(foo: "bar")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCerealTypeToArrayOfInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,39:c,15:k,3:foo:s,3:bar:a,13:z,2:10:z,2:20")
            if let dict: [TestCerealType: [Int64]] = try subject.decodeCereal("hi") {
                guard let array = dict[TestCerealType(foo: "bar")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCerealTypeToArrayOfStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,39:c,15:k,3:foo:s,3:bar:a,13:s,2:hi:s,2:yo")
            if let dict: [TestCerealType: [String]] = try subject.decodeCereal("hi") {
                guard let array = dict[TestCerealType(foo: "bar")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == ["hi","yo"])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCerealTypeToArrayOfFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,41:c,15:k,3:foo:s,3:bar:a,15:f,3:1.0:f,3:2.0")
            if let dict: [TestCerealType: [Float]] = try subject.decodeCereal("hi") {
                guard let array = dict[TestCerealType(foo: "bar")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCerealTypeToArrayOfDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,41:c,15:k,3:foo:s,3:bar:a,15:d,3:1.0:d,3:2.0")
            if let dict: [TestCerealType: [Double]] = try subject.decodeCereal("hi") {
                guard let array = dict[TestCerealType(foo: "bar")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCerealTypeToArrayOfCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,67:c,15:k,3:foo:s,3:bar:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz")
            if let dict: [TestCerealType: [TestCerealType]] = try subject.decodeCerealPair("hi") {
                guard let array = dict[TestCerealType(foo: "bar")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCerealTypeToArrayOfIdentifyingCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,83:c,15:k,3:foo:s,3:bar:a,57:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz")
            if let dict: [TestCerealType: [MyBar]] = try subject.decodeCerealPair("hi") {
                guard let array = dict[TestCerealType(foo: "bar")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [MyBar(bar: "bar"), MyBar(bar: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withCerealTypeToArrayOfProtocolIdentifyingCerealTypeDictionary() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,81:c,15:k,3:foo:s,3:bar:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz")
            if let dict: [TestCerealType: [IdentifyingCerealType]] = try subject.decodeCerealToIdentifyingCerealDictionary("hi") {
                guard let array: [Fooable] = dict[TestCerealType(foo: "bar")]?.CER_casted() else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertEqual(array.first?.foo, "bar")
                XCTAssertEqual(array.last?.foo, "baz")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [IdentifyingCerealType: [XYZ]]

    func testDecoding_withIdentifyingCerealTypeToArrayOfBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,45:p,23:5:MyBar:k,3:bar:s,3:baz:a,11:b,1:t:b,1:f")
            if let dict: [MyBar: [Bool]] = try subject.decodeCereal("hi") {
                guard let array = dict[MyBar(bar: "baz")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [true,false])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCerealTypeToArrayOfIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,47:p,23:5:MyBar:k,3:bar:s,3:baz:a,13:i,2:10:i,2:20")
            if let dict: [MyBar: [Int]] = try subject.decodeCereal("hi") {
                guard let array = dict[MyBar(bar: "baz")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCerealTypeToArrayOfInt64Dictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,47:p,23:5:MyBar:k,3:bar:s,3:baz:a,13:z,2:10:z,2:20")
            if let dict: [MyBar: [Int64]] = try subject.decodeCereal("hi") {
                guard let array = dict[MyBar(bar: "baz")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [10,20])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCerealTypeToArrayOfStringDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,47:p,23:5:MyBar:k,3:bar:s,3:baz:a,13:s,2:hi:s,2:yo")
            if let dict: [MyBar: [String]] = try subject.decodeCereal("hi") {
                guard let array = dict[MyBar(bar: "baz")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == ["hi","yo"])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCerealTypeToArrayOfFloatDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,49:p,23:5:MyBar:k,3:bar:s,3:baz:a,15:f,3:1.0:f,3:2.0")
            if let dict: [MyBar: [Float]] = try subject.decodeCereal("hi") {
                guard let array = dict[MyBar(bar: "baz")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCerealTypeToArrayOfDoubleDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,49:p,23:5:MyBar:k,3:bar:s,3:baz:a,15:d,3:1.0:d,3:2.0")
            if let dict: [MyBar: [Double]] = try subject.decodeCereal("hi") {
                guard let array = dict[MyBar(bar: "baz")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [1.0,2.0])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCerealTypeToArrayOfCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,75:p,23:5:MyBar:k,3:bar:s,3:baz:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz")
            if let dict: [MyBar: [TestCerealType]] = try subject.decodeCerealPair("hi") {
                guard let array = dict[MyBar(bar: "baz")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [TestCerealType(foo: "bar"), TestCerealType(foo: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCerealTypeToArrayOfIdentifyingCerealTypeDictionary() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,91:p,23:5:MyBar:k,3:bar:s,3:baz:a,57:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz")
            if let dict: [MyBar: [MyBar]] = try subject.decodeCerealPair("hi") {
                guard let array = dict[MyBar(bar: "baz")] else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertTrue(array == [MyBar(bar: "bar"), MyBar(bar: "baz")])
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCerealTypeToArrayOfProtocolIdentifyingCerealTypeDictionary() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,89:p,23:5:MyBar:k,3:bar:s,3:baz:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz")
            if let dict: [MyBar: [IdentifyingCerealType]] = try subject.decodeCerealToIdentifyingCerealDictionary("hi") {
                guard let array: [Fooable] = dict[MyBar(bar: "baz")]?.CER_casted() else {
                    XCTFail("Dictionary wasn't decoded correctly")
                    return
                }
                XCTAssertEqual(array.first?.foo, "bar")
                XCTAssertEqual(array.last?.foo, "baz")
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: Error

    func testDecodingDictionary_withUnencodedKey_returnsNil() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,15:f,4:3.14:i,2:10")
            let elements: [Float: Int]? = try subject.decode("bye")
            XCTAssertNil(elements)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingHeterogeneousDictionary_withUnencodedKey_returnsNil() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:m,72:i,1:0:f,4:3.14:i,1:1:d,3:1.3:i,1:2:s,4:roxy:i,1:3:i,2:47:i,1:4:z,5:12345")
            let elements: [Int: String]? = try subject.decode("bye")
            XCTAssertNil(elements)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }
}
