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
            let subject = try CerealDecoder(encodedBytes: [11,50,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,21,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0])
            if let dict: [Bool: Bool] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes:
                [11,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0])
            if let dict: [Bool: Int] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,52,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,23,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,102,111,111])
            if let dict: [Bool: String] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1])
            if let dict: [Bool: Int64] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,15,64])
            if let dict: [Bool: Double] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,53,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64])
            if let dict: [Bool: Float] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1])
            if let dict: [Int: Bool] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0])
            if let dict: [Int: Int] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,30,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,102,111,111])
            if let dict: [Int: String] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1])
            if let dict: [Int: Int64] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,15,64])
            if let dict: [Int: Double] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64])
            if let dict: [Int: Float] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1])
            if let dict: [Int64: Bool] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0])
            if let dict: [Int64: Int] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,30,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,102,111,111])
            if let dict: [Int64: String] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1])
            if let dict: [Int64: Int64] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,15,64])
            if let dict: [Int64: Double] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64])
            if let dict: [Int64: Float] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,54,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,104,101,108,108,111,6,1,0,0,0,0,0,0,0,1])
            if let dict: [String: Bool] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,61,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,104,101,108,108,111,2,8,0,0,0,0,0,0,0,123,0,0,0,0,0,0,0])
            if let dict: [String: Int] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,61,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,104,101,108,108,111,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1])
            if let dict: [String: Int64] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,58,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,29,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,104,101,108,108,111,1,5,0,0,0,0,0,0,0,119,111,114,108,100])
            if let dict: [String: String] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,104,101,108,108,111,5,4,0,0,0,0,0,0,0,248,83,3,63])
            if let dict: [String: Float] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,61,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,32,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,5,0,0,0,0,0,0,0,104,101,108,108,111,4,8,0,0,0,0,0,0,0,45,178,157,239,167,6,35,64])
            if let dict: [String: Double] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,53,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,195,245,72,64,6,1,0,0,0,0,0,0,0,0])
            if let dict: [Float: Bool] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,195,245,72,64,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0])
            if let dict: [Float: Int] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,55,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,26,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,195,245,72,64,1,3,0,0,0,0,0,0,0,102,111,111])
            if let dict: [Float: String] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,195,245,72,64,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1])
            if let dict: [Float: Int64] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,195,245,72,64,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,15,64])
            if let dict: [Float: Double] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,56,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,27,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,195,245,72,64,5,4,0,0,0,0,0,0,0,102,102,30,65])
            if let dict: [Float: Float] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,28,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,6,1,0,0,0,0,0,0,0,1])
            if let dict: [Double: Bool] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0])
            if let dict: [Double: Int] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,30,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,1,3,0,0,0,0,0,0,0,102,111,111])
            if let dict: [Double: String] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1])
            if let dict: [Double: Int64] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,64,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,15,64])
            if let dict: [Double: Double] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,5,4,0,0,0,0,0,0,0,102,102,30,65])
            if let dict: [Double: Float] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,81,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,52,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,9,6,1,0,0,0,0,0,0,0,1,5,4,0,0,0,0,0,0,0,195,245,72,64])
            if let dict: [Bool: CerealRepresentable] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,196,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,
                10,
                167,0,0,0,0,0,0,0,
                5,0,0,0,0,0,0,0,
                    9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,
                    9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,
                    9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,4,0,0,0,0,0,0,0,114,111,120,121,
                    9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,47,0,0,0,0,0,0,0,
                    9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,57,48,0,0,0,0,0,0])
            if let dict: [Int: CerealRepresentable] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,196,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,
                10,
                167,0,0,0,0,0,0,0,
                5,0,0,0,0,0,0,0,
                9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,
                9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,
                9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,4,0,0,0,0,0,0,0,114,111,120,121,
                9,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,47,0,0,0,0,0,0,0,
                9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,57,48,0,0,0,0,0,0])
            if let dict: [Int64: CerealRepresentable] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,153,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,
                10,
                132,0,0,0,0,0,0,0,
                5,0,0,0,0,0,0,0,
                    9,1,1,0,0,0,0,0,0,0,97,5,4,0,0,0,0,0,0,0,195,245,72,64,
                    9,1,1,0,0,0,0,0,0,0,98,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,
                    9,1,1,0,0,0,0,0,0,0,99,1,4,0,0,0,0,0,0,0,114,111,120,121,
                    9,1,1,0,0,0,0,0,0,0,100,2,8,0,0,0,0,0,0,0,47,0,0,0,0,0,0,0,
                    9,1,1,0,0,0,0,0,0,0,101,3,8,0,0,0,0,0,0,0,57,48,0,0,0,0,0,0])
            if let dict: [String: CerealRepresentable] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,
                10,
                147,0,0,0,0,0,0,0,
                5,0,0,0,0,0,0,0,
                    9,5,4,0,0,0,0,0,0,0,205,204,204,61,5,4,0,0,0,0,0,0,0,195,245,72,64,
                    9,5,4,0,0,0,0,0,0,0,205,204,140,63,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,
                    9,5,4,0,0,0,0,0,0,0,154,153,153,63,1,4,0,0,0,0,0,0,0,114,111,120,121,
                    9,5,4,0,0,0,0,0,0,0,102,102,166,63,2,8,0,0,0,0,0,0,0,47,0,0,0,0,0,0,0,
                    9,5,4,0,0,0,0,0,0,0,51,51,179,63,3,8,0,0,0,0,0,0,0,57,48,0,0,0,0,0,0])
            if let dict: [Float: CerealRepresentable] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,196,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,
                10,
                167,0,0,0,0,0,0,0,
                5,0,0,0,0,0,0,0,

                9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,5,4,0,0,0,0,0,0,0,195,245,72,64,
                9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,241,63,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,
                9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,243,63,1,4,0,0,0,0,0,0,0,114,111,120,121,
                9,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,2,8,0,0,0,0,0,0,0,47,0,0,0,0,0,0,0,
                9,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63,3,8,0,0,0,0,0,0,0,57,48,0,0,0,0,0,0])
            if let dict: [Double: CerealRepresentable] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114])
            if let result: [Int: TestCerealType] = try subject.decodeCereal(key: "test") {
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
            let subject = try CerealDecoder(encodedBytes: [11,84,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,10,53,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,6,1,0,0,0,0,0,0,0,1])
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Bool] = try subject.decodeCereal(key: "test") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Int] = try subject.decodeCereal(key: "test") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1])
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Int64] = try subject.decodeCereal(key: "test") {
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
            let subject = try CerealDecoder(encodedBytes: [11,88,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,10,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,1,5,0,0,0,0,0,0,0,104,101,108,108,111])
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: String] = try subject.decodeCereal(key: "test") {
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
            let subject = try CerealDecoder(encodedBytes: [11,87,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,10,56,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,5,4,0,0,0,0,0,0,0,102,230,246,66])
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Float] = try subject.decodeCereal(key: "test") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,10,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,4,8,0,0,0,0,0,0,0,113,61,10,215,163,176,40,64])
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: Double] = try subject.decodeCereal(key: "test") {
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
            let subject = try CerealDecoder(encodedBytes: [11,116,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,4,0,0,0,0,0,0,0,116,101,115,116,10,85,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114])
            let key = TestCerealType(foo: "baz")
            if let result: [TestCerealType: TestCerealType] = try subject.decodeCerealPair(key: "test") {
                XCTAssertEqual(result[key]?.foo, "bar")
            } else {
                XCTFail("Expected key was not found")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [RawRepresentable: XYZ]
    func testDecoding_withStringEnumToIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,66,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,36,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,9,0,0,0,0,0,0,0,84,101,115,116,67,97,115,101,49,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0])
            if let dict: [TestEnum: Int] = try subject.decode(key: "wat") {
                XCTAssertEqual(dict[.testCase1], 1)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntOptionSetToIntDictionary() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,65,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,35,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0])
            if let dict: [TestSetType: Int] = try subject.decode(key: "wat") {
                let testOptions: TestSetType = [TestSetType.FirstOption, TestSetType.SecondOption]
                XCTAssertEqual(dict[testOptions], 1)
            } else {
                XCTFail("Dictionary wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - [ABC: [XYZ]] -

    // MARK: [Bool: [XYZ]]

    func testDecoding_withBoolToArrayOfBoolDictionary() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,77,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,48,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0])
            if let dict: [Bool: [Bool]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,62,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Bool: [Int]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,62,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Bool: [Int64]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,79,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,50,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,10,22,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,104,105,1,2,0,0,0,0,0,0,0,121,111])
            if let dict: [Bool: [String]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,83,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,54,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,0,0,128,63,5,4,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Bool: [Float]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,62,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Bool: [Double]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,141,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,112,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Bool: [TestCerealType]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,169,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Bool: [MyBar]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,167,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,138,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Bool: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,84,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,55,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0])
            if let dict: [Int: [Bool]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Int: [Int]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Int: [Int64]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,22,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,104,105,1,2,0,0,0,0,0,0,0,121,111])
            if let dict: [Int: [String]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,90,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,61,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,0,0,128,63,5,4,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Int: [Float]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Int: [Double]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,148,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,119,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Int: [TestCerealType]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,147,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Int: [MyBar]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,174,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,145,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Int: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,84,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,55,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0])
            if let dict: [Int64: [Bool]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Int64: [Int]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Int64: [Int64]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,22,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,104,105,1,2,0,0,0,0,0,0,0,121,111])
            if let dict: [Int64: [String]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,90,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,61,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,0,0,128,63,5,4,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Int64: [Float]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Int64: [Double]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,148,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,119,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Int64: [TestCerealType]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,147,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Int64: [MyBar]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,174,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,145,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Int64: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,77,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,48,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1])
            if let dict: [String: [Bool]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,62,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [String: [Int]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,62,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [String: [Int64]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,79,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,50,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,10,22,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,104,105,1,2,0,0,0,0,0,0,0,121,111])
            if let dict: [String: [String]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,83,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,54,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,0,0,128,63,5,4,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [String: [Float]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,91,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,62,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [String: [Double]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,141,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,112,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [String: [TestCerealType]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,169,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [String: [MyBar]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,167,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,138,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [String: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,80,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,51,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,1])
            if let dict: [Float: [Bool]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,94,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,65,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Float: [Int]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,94,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,65,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Float: [Int64]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,82,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,53,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,22,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,104,105,1,2,0,0,0,0,0,0,0,121,111])
            if let dict: [Float: [String]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,0,0,128,63,5,4,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Float: [Float]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,94,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,65,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Float: [Double]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,144,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,115,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Float: [TestCerealType]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,172,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,143,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Float: [MyBar]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,170,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,141,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Float: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,84,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,55,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0])
            if let dict: [Double: [Bool]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Double: [Int]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [Double: [Int64]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,57,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,22,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,104,105,1,2,0,0,0,0,0,0,0,121,111])
            if let dict: [Double: [String]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,90,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,61,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,0,0,128,63,5,4,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Double: [Float]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,98,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,69,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [Double: [Double]] = try subject.decode(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,148,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,119,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Double: [TestCerealType]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,147,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Double: [MyBar]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,174,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,145,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [Double: [IdentifyingCerealType]] = try subject.decodeIdentifyingCerealDictionary(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,109,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,80,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0])
            if let dict: [TestCerealType: [Bool]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,123,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,94,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [TestCerealType: [Int]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,123,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,94,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [TestCerealType: [Int64]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,111,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,82,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,22,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,104,105,1,2,0,0,0,0,0,0,0,121,111])
            if let dict: [TestCerealType: [String]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,115,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,0,0,128,63,5,4,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [TestCerealType: [Float]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,123,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,94,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [TestCerealType: [Double]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,173,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,144,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [TestCerealType: [TestCerealType]] = try subject.decodeCerealPair(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,201,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,172,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [TestCerealType: [MyBar]] = try subject.decodeCerealPair(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,199,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,170,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [TestCerealType: [IdentifyingCerealType]] = try subject.decodeCerealToIdentifyingCerealDictionary(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,123,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,94,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0])
            if let dict: [MyBar: [Bool]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,137,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,108,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [MyBar: [Int]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,137,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,108,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0])
            if let dict: [MyBar: [Int64]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,125,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,96,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,22,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,104,105,1,2,0,0,0,0,0,0,0,121,111])
            if let dict: [MyBar: [String]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,129,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,0,0,128,63,5,4,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [MyBar: [Float]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,137,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,108,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64])
            if let dict: [MyBar: [Double]] = try subject.decodeCereal(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,187,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,158,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [MyBar: [TestCerealType]] = try subject.decodeCerealPair(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,215,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,186,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [MyBar: [MyBar]] = try subject.decodeCerealPair(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,213,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,184,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let dict: [MyBar: [IdentifyingCerealType]] = try subject.decodeCerealToIdentifyingCerealDictionary(key: "hi") {
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
            let subject = try CerealDecoder(encodedBytes: [11,60,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,31,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,195,245,72,64,2,8,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0])
            let elements: [Float: Int]? = try subject.decode(key: "bye")
            XCTAssertNil(elements)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingHeterogeneousDictionary_withUnencodedKey_returnsNil() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,196,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,167,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,4,0,0,0,0,0,0,0,114,111,120,121,9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,47,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,57,48,0,0,0,0,0,0])
            let elements: [Int: String]? = try subject.decode(key: "bye")
            XCTAssertNil(elements)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

}
