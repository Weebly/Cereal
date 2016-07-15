//
//  CerealDecoderArrayTests.swift
//  Cereal
//
//  Created by James Richard on 8/15/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import XCTest
@testable import Cereal

class CerealDecoderArrayTests: XCTestCase {

    override func tearDown() {
        Cereal.clearRegisteredCerealTypes()
        super.tearDown()
    }

    func testDecoding_withBoolArray() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,59,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,30,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0])
            if let elements: [Bool] = try subject.decode("hi") {
                XCTAssertEqual(elements, [true,false,false])
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIntArray() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,80,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,51,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,80,0,0,0,0,0,0,0])
            if let elements: [Int] = try subject.decode("hi") {
                XCTAssertEqual(elements, [5,3,80])
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withInt64Array() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,80,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,51,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,53,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,13,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,41,3,0,0,0,0,0,0])
            if let elements: [Int64] = try subject.decode("hi") {
                XCTAssertEqual(elements, [53,13,809])
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withDoubleArray() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,80,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,51,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,21,64,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,42,64,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,33,64])
            if let elements: [Double] = try subject.decode("hi") {
                XCTAssertEqual(elements, [5.3,13,8.9])
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withFloatArray() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,68,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,39,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63,5,4,0,0,0,0,0,0,0,0,0,4,66,5,4,0,0,0,0,0,0,0,102,102,30,65])
            if let elements: [Float] = try subject.decode("hi") {
                XCTAssertEqual(elements, [1.3,33,9.9])
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withStringArray() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,67,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,38,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,116,104,101,1,5,0,0,0,0,0,0,0,98,114,111,119,110,1,3,0,0,0,0,0,0,0,102,111,120])
            if let elements: [String] = try subject.decode("hi") {
                XCTAssertEqual(elements, ["the","brown", "fox"])
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: Heterogeneous

    func testDecoding_withMixedArray() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,80,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,51,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,33,64])
            if let elements: [CerealRepresentable] = try subject.decode("hi") {
                XCTAssertEqual(elements[0] as? Int, 5)
                XCTAssertEqual(elements[1] as? Int, 3)
                XCTAssertEqual(elements[2] as? Double, 8.5)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withMixedArray_containingIdentifyingCereal() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,118,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,89,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let elements: [CerealRepresentable] = try subject.decode("hi") {
                let expected = TestIdentifyingCerealType(foo: "baz")
                XCTAssertEqual(elements[0] as? Int, 5)
                XCTAssertEqual(elements[1] as? Int, 3)
                XCTAssertEqual(elements[2] as? TestIdentifyingCerealType, expected)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: Custom

    func testDecoding_withCustomArray() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,113,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let elements: [TestCerealType] = try subject.decodeCereal("hi") {
                let first = TestCerealType(foo: "bar")
                let second = TestCerealType(foo: "baz")
                XCTAssertEqual(elements.first, first)
                XCTAssertEqual(elements.last, second)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withIdentifyingCerealArray() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,139,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122])
            if let elements: [Fooable] = try subject.decodeIdentifyingCerealArray("hi")?.CER_casted() {
                XCTAssertEqual(elements.first?.foo, "bar")
                XCTAssertEqual(elements.last?.foo, "baz")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: Of Dictionaries

    func testDecoding_withArrayOfDictionary_ofBoolToInt() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[Bool: Int]] = try subject.decode("hi") {
                guard let first: [Bool: Int] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Bool: Int] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[true], 1)
                XCTAssertEqual(first[false], 3)

                XCTAssertEqual(second[true], 5)
                XCTAssertEqual(second[false], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofBoolToInt64() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,1,3,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0])
            if let elements: [[Bool: Int64]] = try subject.decode("hi") {
                guard let first: [Bool: Int64] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Bool: Int64] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[true], 1)
                XCTAssertEqual(first[false], 3)

                XCTAssertEqual(second[false], 5)
                XCTAssertEqual(second[true], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofBoolToString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,147,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,118,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,42,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,9,6,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,98,10,42,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,100,9,6,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,99])
            if let elements: [[Bool: String]] = try subject.decode("hi") {
                guard let first: [Bool: String] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Bool: String] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[false], "a")
                XCTAssertEqual(first[true], "b")

                XCTAssertEqual(second[true], "c")
                XCTAssertEqual(second[false], "d")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofBoolToFloat() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,159,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,130,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,76,62,9,6,1,0,0,0,0,0,0,0,1,5,4,0,0,0,0,0,0,0,205,204,204,61,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,62,9,6,1,0,0,0,0,0,0,0,1,5,4,0,0,0,0,0,0,0,154,153,153,62])
            if let elements: [[Bool: Float]] = try subject.decode("hi") {
                guard let first: [Bool: Float] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Bool: Float] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[true], 0.1)
                XCTAssertEqual(first[false], 0.2)

                XCTAssertEqual(second[true], 0.3)
                XCTAssertEqual(second[false], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofBoolToDouble() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,9,6,1,0,0,0,0,0,0,0,1,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,9,6,1,0,0,0,0,0,0,0,1,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63])
            if let elements: [[Bool: Double]] = try subject.decode("hi") {
                guard let first: [Bool: Double] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Bool: Double] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[true], 0.1)
                XCTAssertEqual(first[false], 0.2)

                XCTAssertEqual(second[true], 0.3)
                XCTAssertEqual(second[false], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofBoolToCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,19,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,246,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,9,6,1,0,0,0,0,0,0,0,1,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,6,1,0,0,0,0,0,0,0,1,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Bool: TestCerealType]] = try subject.decodeCereal("hi") {
                guard let first: [Bool: TestCerealType] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Bool: TestCerealType] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                var expected = TestCerealType(foo: "bar")
                XCTAssertEqual(first[true], expected)
                expected.foo = "baz"
                XCTAssertEqual(first[false], expected)

                expected.foo = "foo"
                XCTAssertEqual(second[true], expected)
                expected.foo = "oof"
                XCTAssertEqual(second[false], expected)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofBoolToIdentifyingCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,75,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,46,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,134,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,9,6,1,0,0,0,0,0,0,0,1,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,10,134,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,9,6,1,0,0,0,0,0,0,0,1,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Bool: MyBar]] = try subject.decodeCereal("hi") {
                guard let first: [Bool: MyBar] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Bool: MyBar] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[true]?.bar, "bar")
                XCTAssertEqual(first[false]?.bar, "baz")

                XCTAssertEqual(second[true]?.bar, "foo")
                XCTAssertEqual(second[false]?.bar, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofBoolToProtocolIdentifyingCereal() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,71,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,42,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,132,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,9,6,1,0,0,0,0,0,0,0,1,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,132,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,6,1,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,6,1,0,0,0,0,0,0,0,1,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Bool: IdentifyingCerealType]] = try subject.decodeIdentifyingCerealArray("hi") {
                guard let first = elements.first as? [Bool: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second = elements.last as? [Bool: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[true]?.foo, "bar")
                XCTAssertEqual(first[false]?.foo, "baz")
                
                XCTAssertEqual(second[true]?.foo, "foo")
                XCTAssertEqual(second[false]?.foo, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [[Int: XYZ]]

    func testDecoding_withArrayOfDictionary_ofIntToBool() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1])
            if let elements: [[Int: Bool]] = try subject.decode("hi") {
                guard let first: [Int: Bool] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int: Bool] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], true)
                XCTAssertEqual(first[2], false)

                XCTAssertEqual(second[4], true)
                XCTAssertEqual(second[6], false)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIntToInt() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[Int: Int]] = try subject.decode("hi") {
                guard let first: [Int: Int] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int: Int] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], 1)
                XCTAssertEqual(first[2], 3)

                XCTAssertEqual(second[4], 5)
                XCTAssertEqual(second[6], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIntToInt64() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[Int: Int64]] = try subject.decode("hi") {
                guard let first: [Int: Int64] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int: Int64] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], 1)
                XCTAssertEqual(first[2], 3)

                XCTAssertEqual(second[4], 5)
                XCTAssertEqual(second[6], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIntToString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,98,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,100,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99])
            if let elements: [[Int: String]] = try subject.decode("hi") {
                guard let first: [Int: String] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int: String] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], "a")
                XCTAssertEqual(first[2], "b")

                XCTAssertEqual(second[4], "c")
                XCTAssertEqual(second[6], "d")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIntToFloat() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,187,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,158,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,76,62,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,61,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,62,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,154,153,153,62])
            if let elements: [[Int: Float]] = try subject.decode("hi") {
                guard let first: [Int: Float] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int: Float] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], 0.1)
                XCTAssertEqual(first[2], 0.2)

                XCTAssertEqual(second[4], 0.3)
                XCTAssertEqual(second[6], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIntToDouble() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63])
            if let elements: [[Int: Double]] = try subject.decode("hi") {
                guard let first: [Int: Double] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int: Double] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], 0.1)
                XCTAssertEqual(first[2], 0.2)

                XCTAssertEqual(second[4], 0.3)
                XCTAssertEqual(second[6], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIntToCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,47,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,18,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Int: TestCerealType]] = try subject.decodeCereal("hi") {
                guard let first: [Int: TestCerealType] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int: TestCerealType] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                var expected = TestCerealType(foo: "bar")
                XCTAssertEqual(first[0], expected)
                expected.foo = "baz"
                XCTAssertEqual(first[2], expected)

                expected.foo = "foo"
                XCTAssertEqual(second[4], expected)
                expected.foo = "oof"
                XCTAssertEqual(second[6], expected)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIntToIdentifyingCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,103,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,74,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Int: MyBar]] = try subject.decodeCereal("hi") {
                guard let first: [Int: MyBar] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int: MyBar] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0]?.bar, "bar")
                XCTAssertEqual(first[2]?.bar, "baz")

                XCTAssertEqual(second[4]?.bar, "foo")
                XCTAssertEqual(second[6]?.bar, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIntToProtocolIdentifyingCereal() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,99,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,70,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Int: IdentifyingCerealType]] = try subject.decodeIdentifyingCerealArray("hi") {
                guard let first = elements.first as? [Int: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second = elements.last as? [Int: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0]?.foo, "bar")
                XCTAssertEqual(first[2]?.foo, "baz")

                XCTAssertEqual(second[4]?.foo, "foo")
                XCTAssertEqual(second[6]?.foo, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [[Int64: XYZ]]

    func testDecoding_withArrayOfDictionary_ofInt64ToBool() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0])
            if let elements: [[Int64: Bool]] = try subject.decode("hi") {
                guard let first: [Int64: Bool] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int64: Bool] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], true)
                XCTAssertEqual(first[2], true)

                XCTAssertEqual(second[4], false)
                XCTAssertEqual(second[6], false)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofInt64ToInt() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[Int64: Int]] = try subject.decode("hi") {
                guard let first: [Int64: Int] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int64: Int] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], 1)
                XCTAssertEqual(first[2], 3)

                XCTAssertEqual(second[4], 5)
                XCTAssertEqual(second[6], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofInt64ToInt64() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[Int64: Int64]] = try subject.decode("hi") {
                guard let first: [Int64: Int64] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int64: Int64] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], 1)
                XCTAssertEqual(first[2], 3)

                XCTAssertEqual(second[4], 5)
                XCTAssertEqual(second[6], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofInt64ToString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,98,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,100,9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99])
            if let elements: [[Int64: String]] = try subject.decode("hi") {
                guard let first: [Int64: String] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int64: String] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], "a")
                XCTAssertEqual(first[2], "b")

                XCTAssertEqual(second[4], "c")
                XCTAssertEqual(second[6], "d")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofInt64ToFloat() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,187,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,158,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,76,62,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,61,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,62,9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,154,153,153,62])
            if let elements: [[Int64: Float]] = try subject.decode("hi") {
                guard let first: [Int64: Float] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int64: Float] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], 0.1)
                XCTAssertEqual(first[2], 0.2)

                XCTAssertEqual(second[4], 0.3)
                XCTAssertEqual(second[6], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofInt64ToDouble() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63])
            if let elements: [[Int64: Double]] = try subject.decode("hi") {
                guard let first: [Int64: Double] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int64: Double] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0], 0.1)
                XCTAssertEqual(first[2], 0.2)

                XCTAssertEqual(second[4], 0.3)
                XCTAssertEqual(second[6], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofInt64ToCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,47,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,18,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Int64: TestCerealType]] = try subject.decodeCereal("hi") {
                guard let first: [Int64: TestCerealType] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int64: TestCerealType] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                var expected = TestCerealType(foo: "bar")
                XCTAssertEqual(first[0], expected)
                expected.foo = "baz"
                XCTAssertEqual(first[2], expected)

                expected.foo = "foo"
                XCTAssertEqual(second[4], expected)
                expected.foo = "oof"
                XCTAssertEqual(second[6], expected)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofInt64ToIdentifyingCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,103,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,74,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Int64: MyBar]] = try subject.decodeCereal("hi") {
                guard let first: [Int64: MyBar] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Int64: MyBar] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0]?.bar, "bar")
                XCTAssertEqual(first[2]?.bar, "baz")

                XCTAssertEqual(second[4]?.bar, "foo")
                XCTAssertEqual(second[6]?.bar, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofInt64ToProtocolIdentifyingCereal() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,99,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,70,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,3,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,3,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Int64: IdentifyingCerealType]] = try subject.decodeIdentifyingCerealArray("hi") {
                guard let first = elements.first as? [Int64: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second = elements.last as? [Int64: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0]?.foo, "bar")
                XCTAssertEqual(first[2]?.foo, "baz")

                XCTAssertEqual(second[4]?.foo, "foo")
                XCTAssertEqual(second[6]?.foo, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [[String: XYZ]]

    func testDecoding_withArrayOfDictionary_ofStringToBool() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,147,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,118,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,42,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,98,6,1,0,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,97,6,1,0,0,0,0,0,0,0,0,10,42,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,100,6,1,0,0,0,0,0,0,0,1,9,1,1,0,0,0,0,0,0,0,99,6,1,0,0,0,0,0,0,0,1])
            if let elements: [[String: Bool]] = try subject.decode("hi") {
                guard let first: [String: Bool] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [String: Bool] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first["a"], false)
                XCTAssertEqual(first["b"], false)

                XCTAssertEqual(second["c"], true)
                XCTAssertEqual(second["d"], true)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofStringToInt() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,98,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,97,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,100,2,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,99,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[String: Int]] = try subject.decode("hi") {
                guard let first: [String: Int] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [String: Int] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first["a"], 1)
                XCTAssertEqual(first["b"], 3)

                XCTAssertEqual(second["c"], 5)
                XCTAssertEqual(second["d"], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofStringToInt64() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,98,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,97,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,100,3,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,99,3,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[String: Int64]] = try subject.decode("hi") {
                guard let first: [String: Int64] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [String: Int64] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first["a"], 1)
                XCTAssertEqual(first["b"], 3)

                XCTAssertEqual(second["c"], 5)
                XCTAssertEqual(second["d"], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofStringToString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,147,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,118,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,42,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,120,1,1,0,0,0,0,0,0,0,98,9,1,1,0,0,0,0,0,0,0,119,1,1,0,0,0,0,0,0,0,97,10,42,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,121,1,1,0,0,0,0,0,0,0,99,9,1,1,0,0,0,0,0,0,0,122,1,1,0,0,0,0,0,0,0,100])
            if let elements: [[String: String]] = try subject.decode("hi") {
                guard let first: [String: String] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [String: String] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first["w"], "a")
                XCTAssertEqual(first["x"], "b")

                XCTAssertEqual(second["y"], "c")
                XCTAssertEqual(second["z"], "d")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofStringToFloat() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,159,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,130,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,98,5,4,0,0,0,0,0,0,0,205,204,76,62,9,1,1,0,0,0,0,0,0,0,97,5,4,0,0,0,0,0,0,0,205,204,204,61,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,100,5,4,0,0,0,0,0,0,0,205,204,204,62,9,1,1,0,0,0,0,0,0,0,99,5,4,0,0,0,0,0,0,0,154,153,153,62])
            if let elements: [[String: Float]] = try subject.decode("hi") {
                guard let first: [String: Float] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [String: Float] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first["a"], 0.1)
                XCTAssertEqual(first["b"], 0.2)

                XCTAssertEqual(second["c"], 0.3)
                XCTAssertEqual(second["d"], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofStringToDouble() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,98,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,9,1,1,0,0,0,0,0,0,0,97,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,100,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,9,1,1,0,0,0,0,0,0,0,99,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63])
            if let elements: [[String: Double]] = try subject.decode("hi") {
                guard let first: [String: Double] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [String: Double] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first["a"], 0.1)
                XCTAssertEqual(first["b"], 0.2)

                XCTAssertEqual(second["c"], 0.3)
                XCTAssertEqual(second["d"], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofStringToCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,19,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,246,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,98,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,9,1,1,0,0,0,0,0,0,0,97,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,100,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,1,1,0,0,0,0,0,0,0,99,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[String: TestCerealType]] = try subject.decodeCereal("hi") {
                guard let first: [String: TestCerealType] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [String: TestCerealType] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                var expected = TestCerealType(foo: "bar")
                XCTAssertEqual(first["a"], expected)
                expected.foo = "baz"
                XCTAssertEqual(first["b"], expected)

                expected.foo = "foo"
                XCTAssertEqual(second["c"], expected)
                expected.foo = "oof"
                XCTAssertEqual(second["d"], expected)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofStringToIdentifyingCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,75,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,46,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,134,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,98,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,9,1,1,0,0,0,0,0,0,0,97,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,10,134,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,100,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,9,1,1,0,0,0,0,0,0,0,99,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[String: MyBar]] = try subject.decodeCereal("hi") {
                guard let first: [String: MyBar] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [String: MyBar] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first["a"]?.bar, "bar")
                XCTAssertEqual(first["b"]?.bar, "baz")

                XCTAssertEqual(second["c"]?.bar, "foo")
                XCTAssertEqual(second["d"]?.bar, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofStringToProtocolIdentifyingCereal() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,71,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,42,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,132,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,98,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,9,1,1,0,0,0,0,0,0,0,97,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,132,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,1,1,0,0,0,0,0,0,0,100,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,1,1,0,0,0,0,0,0,0,99,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[String: IdentifyingCerealType]] = try subject.decodeIdentifyingCerealArray("hi") {
                guard let first = elements.first as? [String: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second = elements.last as? [String: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first["a"]?.foo, "bar")
                XCTAssertEqual(first["b"]?.foo, "baz")

                XCTAssertEqual(second["c"]?.foo, "foo")
                XCTAssertEqual(second["d"]?.foo, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [[Float: XYZ]]

    func testDecoding_withArrayOfDictionary_ofFloatToBool() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,159,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,130,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,9,5,4,0,0,0,0,0,0,0,205,204,76,62,6,1,0,0,0,0,0,0,0,0,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,25,63,6,1,0,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,62,6,1,0,0,0,0,0,0,0,1])
            if let elements: [[Float: Bool]] = try subject.decode("hi") {
                guard let first: [Float: Bool] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Float: Bool] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], true)
                XCTAssertEqual(first[0.2], false)

                XCTAssertEqual(second[0.4], true)
                XCTAssertEqual(second[0.6], false)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofFloatToInt() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,187,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,158,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,76,62,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,25,63,2,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,62,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[Float: Int]] = try subject.decode("hi") {
                guard let first: [Float: Int] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Float: Int] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], 1)
                XCTAssertEqual(first[0.2], 3)

                XCTAssertEqual(second[0.4], 5)
                XCTAssertEqual(second[0.6], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofFloatToInt64() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,187,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,158,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,76,62,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,25,63,3,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,205,204,204,62,3,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[Float: Int64]] = try subject.decode("hi") {
                guard let first: [Float: Int64] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Float: Int64] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], 1)
                XCTAssertEqual(first[0.2], 3)

                XCTAssertEqual(second[0.4], 5)
                XCTAssertEqual(second[0.6], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofFloatToString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,159,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,130,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,9,5,4,0,0,0,0,0,0,0,205,204,76,62,1,1,0,0,0,0,0,0,0,98,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,25,63,1,1,0,0,0,0,0,0,0,100,9,5,4,0,0,0,0,0,0,0,205,204,204,62,1,1,0,0,0,0,0,0,0,99])
            if let elements: [[Float: String]] = try subject.decode("hi") {
                guard let first: [Float: String] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Float: String] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], "a")
                XCTAssertEqual(first[0.2], "b")

                XCTAssertEqual(second[0.4], "c")
                XCTAssertEqual(second[0.6], "d")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofFloatToFloat() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,171,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,142,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,54,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,61,9,5,4,0,0,0,0,0,0,0,205,204,76,62,5,4,0,0,0,0,0,0,0,205,204,76,62,10,54,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,25,63,5,4,0,0,0,0,0,0,0,205,204,204,62,9,5,4,0,0,0,0,0,0,0,205,204,204,62,5,4,0,0,0,0,0,0,0,154,153,153,62])
            if let elements: [[Float: Float]] = try subject.decode("hi") {
                guard let first: [Float: Float] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Float: Float] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], 0.1)
                XCTAssertEqual(first[0.2], 0.2)

                XCTAssertEqual(second[0.4], 0.3)
                XCTAssertEqual(second[0.6], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofFloatToDouble() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,187,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,158,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,9,5,4,0,0,0,0,0,0,0,205,204,76,62,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,25,63,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,9,5,4,0,0,0,0,0,0,0,205,204,204,62,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63])
            if let elements: [[Float: Double]] = try subject.decode("hi") {
                guard let first: [Float: Double] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Float: Double] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], 0.1)
                XCTAssertEqual(first[0.2], 0.2)

                XCTAssertEqual(second[0.4], 0.3)
                XCTAssertEqual(second[0.6], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofFloatToCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,31,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,2,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,9,5,4,0,0,0,0,0,0,0,205,204,76,62,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,25,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,5,4,0,0,0,0,0,0,0,205,204,204,62,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Float: TestCerealType]] = try subject.decodeCereal("hi") {
                guard let first: [Float: TestCerealType] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Float: TestCerealType] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                var expected = TestCerealType(foo: "bar")
                XCTAssertEqual(first[0.0], expected)
                expected.foo = "baz"
                XCTAssertEqual(first[0.2], expected)

                expected.foo = "foo"
                XCTAssertEqual(second[0.4], expected)
                expected.foo = "oof"
                XCTAssertEqual(second[0.6], expected)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofFloatToIdentifyingCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,87,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,58,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,140,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,9,5,4,0,0,0,0,0,0,0,205,204,76,62,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,140,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,25,63,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,9,5,4,0,0,0,0,0,0,0,205,204,204,62,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Float: MyBar]] = try subject.decodeCereal("hi") {
                guard let first: [Float: MyBar] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Float: MyBar] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0]?.bar, "bar")
                XCTAssertEqual(first[0.2]?.bar, "baz")

                XCTAssertEqual(second[0.4]?.bar, "foo")
                XCTAssertEqual(second[0.6]?.bar, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofFloatToProtocolIdentifyingCereal() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,83,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,54,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,9,5,4,0,0,0,0,0,0,0,205,204,76,62,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,5,4,0,0,0,0,0,0,0,154,153,25,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,5,4,0,0,0,0,0,0,0,205,204,204,62,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[Float: IdentifyingCerealType]] = try subject.decodeIdentifyingCerealArray("hi") {
                guard let first = elements.first as? [Float: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second = elements.last as? [Float: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0]?.foo, "bar")
                XCTAssertEqual(first[0.2]?.foo, "baz")

                XCTAssertEqual(second[0.4]?.foo, "foo")
                XCTAssertEqual(second[0.6]?.foo, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [[Double: XYZ]]

    func testDecoding_withArrayOfDictionary_ofDoubleToBool() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,6,1,0,0,0,0,0,0,0,1,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,6,1,0,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,6,1,0,0,0,0,0,0,0,0])
            if let elements: [[Double: Bool]] = try subject.decode("hi") {
                guard let first: [Double: Bool] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Double: Bool] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], true)
                XCTAssertEqual(first[0.2], true)

                XCTAssertEqual(second[0.4], false)
                XCTAssertEqual(second[0.6], false)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofDoubleToInt() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,2,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0])
            if let elements: [[Double: Int]] = try subject.decode("hi") {
                guard let first: [Double: Int] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Double: Int] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], 1)
                XCTAssertEqual(first[0.2], 3)

                XCTAssertEqual(second[0.4], 5)
                XCTAssertEqual(second[0.6], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofDoubleToInt64() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,3,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,3,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0])
            if let elements: [[Double: Int64]] = try subject.decode("hi") {
                guard let first: [Double: Int64] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Double: Int64] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], 1)
                XCTAssertEqual(first[0.2], 3)

                XCTAssertEqual(second[0.4], 5)
                XCTAssertEqual(second[0.6], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofDoubleToString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,175,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,1,1,0,0,0,0,0,0,0,98,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,1,1,0,0,0,0,0,0,0,99,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,1,1,0,0,0,0,0,0,0,100])
            if let elements: [[Double: String]] = try subject.decode("hi") {
                guard let first: [Double: String] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Double: String] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], "a")
                XCTAssertEqual(first[0.2], "b")

                XCTAssertEqual(second[0.4], "c")
                XCTAssertEqual(second[0.6], "d")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofDoubleToFloat() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,187,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,158,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,61,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,5,4,0,0,0,0,0,0,0,205,204,76,62,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,5,4,0,0,0,0,0,0,0,154,153,153,62,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,5,4,0,0,0,0,0,0,0,205,204,204,62])
            if let elements: [[Double: Float]] = try subject.decode("hi") {
                guard let first: [Double: Float] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Double: Float] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], 0.1)
                XCTAssertEqual(first[0.2], 0.2)

                XCTAssertEqual(second[0.4], 0.3)
                XCTAssertEqual(second[0.6], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofDoubleToDouble() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63])
            if let elements: [[Double: Double]] = try subject.decode("hi") {
                guard let first: [Double: Double] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Double: Double] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0], 0.1)
                XCTAssertEqual(first[0.2], 0.2)

                XCTAssertEqual(second[0.4], 0.3)
                XCTAssertEqual(second[0.6], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofDoubleToCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,47,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,18,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102])
            if let elements: [[Double: TestCerealType]] = try subject.decodeCereal("hi") {
                guard let first: [Double: TestCerealType] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Double: TestCerealType] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                var expected = TestCerealType(foo: "bar")
                XCTAssertEqual(first[0.0], expected)
                expected.foo = "baz"
                XCTAssertEqual(first[0.2], expected)

                expected.foo = "foo"
                XCTAssertEqual(second[0.4], expected)
                expected.foo = "oof"
                XCTAssertEqual(second[0.6], expected)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofDoubleToIdentifyingCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,103,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,74,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102])
            if let elements: [[Double: MyBar]] = try subject.decodeCereal("hi") {
                guard let first: [Double: MyBar] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [Double: MyBar] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0]?.bar, "bar")
                XCTAssertEqual(first[0.2]?.bar, "baz")

                XCTAssertEqual(second[0.4]?.bar, "foo")
                XCTAssertEqual(second[0.6]?.bar, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofDoubleToProtocolIdentifyingCereal() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,99,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,70,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102])
            if let elements: [[Double: IdentifyingCerealType]] = try subject.decodeIdentifyingCerealArray("hi") {
                guard let first = elements.first as? [Double: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second = elements.last as? [Double: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[0.0]?.foo, "bar")
                XCTAssertEqual(first[0.2]?.foo, "baz")

                XCTAssertEqual(second[0.4]?.foo, "foo")
                XCTAssertEqual(second[0.6]?.foo, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [[CerealType: XYZ]]

    func testDecoding_withArrayOfDictionary_ofCerealTypeToBool() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,19,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,246,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,6,1,0,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,6,1,0,0,0,0,0,0,0,1,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,6,1,0,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,6,1,0,0,0,0,0,0,0,1])
            if let elements: [[TestCerealType: Bool]] = try subject.decodeCereal("hi") {
                guard let first: [TestCerealType: Bool] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [TestCerealType: Bool] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[TestCerealType(foo: "bar")], true)
                XCTAssertEqual(first[TestCerealType(foo: "baz")], false)

                XCTAssertEqual(second[TestCerealType(foo: "foo")], true)
                XCTAssertEqual(second[TestCerealType(foo: "oof")], false)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofCerealTypeToInt() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,47,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,18,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,2,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[TestCerealType: Int]] = try subject.decodeCereal("hi") {
                guard let first: [TestCerealType: Int] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [TestCerealType: Int] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[TestCerealType(foo: "bar")], 1)
                XCTAssertEqual(first[TestCerealType(foo: "baz")], 3)

                XCTAssertEqual(second[TestCerealType(foo: "foo")], 5)
                XCTAssertEqual(second[TestCerealType(foo: "oof")], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofCerealTypeToInt64() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,47,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,18,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,3,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,3,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[TestCerealType: Int64]] = try subject.decodeCereal("hi") {
                guard let first: [TestCerealType: Int64] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [TestCerealType: Int64] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[TestCerealType(foo: "bar")], 1)
                XCTAssertEqual(first[TestCerealType(foo: "baz")], 3)

                XCTAssertEqual(second[TestCerealType(foo: "foo")], 5)
                XCTAssertEqual(second[TestCerealType(foo: "oof")], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofCerealTypeToString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,19,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,246,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,1,1,0,0,0,0,0,0,0,98,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,1,1,0,0,0,0,0,0,0,97,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,1,1,0,0,0,0,0,0,0,100,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,1,1,0,0,0,0,0,0,0,99])
            if let elements: [[TestCerealType: String]] = try subject.decodeCereal("hi") {
                guard let first: [TestCerealType: String] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [TestCerealType: String] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[TestCerealType(foo: "bar")], "a")
                XCTAssertEqual(first[TestCerealType(foo: "baz")], "b")

                XCTAssertEqual(second[TestCerealType(foo: "foo")], "c")
                XCTAssertEqual(second[TestCerealType(foo: "oof")], "d")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofCerealTypeToFloat() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,31,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,2,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,5,4,0,0,0,0,0,0,0,205,204,76,62,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,5,4,0,0,0,0,0,0,0,205,204,204,61,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,5,4,0,0,0,0,0,0,0,205,204,204,62,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,5,4,0,0,0,0,0,0,0,154,153,153,62])
            if let elements: [[TestCerealType: Float]] = try subject.decodeCereal("hi") {
                guard let first: [TestCerealType: Float] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [TestCerealType: Float] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[TestCerealType(foo: "bar")], 0.1)
                XCTAssertEqual(first[TestCerealType(foo: "baz")], 0.2)

                XCTAssertEqual(second[TestCerealType(foo: "foo")], 0.3)
                XCTAssertEqual(second[TestCerealType(foo: "oof")], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofCerealTypeToDouble() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,47,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,18,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63])
            if let elements: [[TestCerealType: Double]] = try subject.decodeCereal("hi") {
                guard let first: [TestCerealType: Double] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [TestCerealType: Double] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[TestCerealType(foo: "bar")], 0.1)
                XCTAssertEqual(first[TestCerealType(foo: "baz")], 0.2)

                XCTAssertEqual(second[TestCerealType(foo: "foo")], 0.3)
                XCTAssertEqual(second[TestCerealType(foo: "oof")], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofCerealToCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,147,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,118,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,170,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,10,170,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102])
            if let elements: [[TestCerealType: TestCerealType]] = try subject.decodeCerealPair("hi") {
                guard let first: [TestCerealType: TestCerealType] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [TestCerealType: TestCerealType] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                var expected = TestCerealType(foo: "bar")
                XCTAssertEqual(first[TestCerealType(foo: "oof")], expected)
                expected.foo = "baz"
                XCTAssertEqual(first[TestCerealType(foo: "foo")], expected)

                expected.foo = "foo"
                XCTAssertEqual(second[TestCerealType(foo: "baz")], expected)
                expected.foo = "oof"
                XCTAssertEqual(second[TestCerealType(foo: "bar")], expected)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofCerealTypeToIdentifyingCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,198,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,10,198,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[TestCerealType: MyBar]] = try subject.decodeCerealPair("hi") {
                guard let first: [TestCerealType: MyBar] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [TestCerealType: MyBar] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[TestCerealType(foo: "bar")]?.bar, "bar")
                XCTAssertEqual(first[TestCerealType(foo: "baz")]?.bar, "baz")

                XCTAssertEqual(second[TestCerealType(foo: "foo")]?.bar, "foo")
                XCTAssertEqual(second[TestCerealType(foo: "oof")]?.bar, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofCerealTypeToProtocolIdentifyingCereal() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,199,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,170,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,196,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,10,196,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102])
            if let elements: [[TestCerealType: IdentifyingCerealType]] = try subject.decodeCerealToIdentifyingCerealArray("hi") {
                guard let first = elements.first as? [TestCerealType: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second = elements.last as? [TestCerealType: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[TestCerealType(foo: "oof")]?.foo, "bar")
                XCTAssertEqual(first[TestCerealType(foo: "foo")]?.foo, "baz")

                XCTAssertEqual(second[TestCerealType(foo: "baz")]?.foo, "foo")
                XCTAssertEqual(second[TestCerealType(foo: "bar")]?.foo, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: [[IdentifyingCerealType: XYZ]]

    func testDecoding_withArrayOfDictionary_ofIdentifyingCerealTypeToBool() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,75,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,46,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,134,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,6,1,0,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,6,1,0,0,0,0,0,0,0,1,10,134,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,6,1,0,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,6,1,0,0,0,0,0,0,0,1])
            if let elements: [[MyBar: Bool]] = try subject.decodeCereal("hi") {
                guard let first: [MyBar: Bool] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [MyBar: Bool] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[MyBar(bar: "bar")], true)
                XCTAssertEqual(first[MyBar(bar: "baz")], false)

                XCTAssertEqual(second[MyBar(bar: "foo")], true)
                XCTAssertEqual(second[MyBar(bar: "oof")], false)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIdentifyingCerealTypeToInt() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,103,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,74,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,2,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[MyBar: Int]] = try subject.decodeCereal("hi") {
                guard let first: [MyBar: Int] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [MyBar: Int] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[MyBar(bar: "bar")], 1)
                XCTAssertEqual(first[MyBar(bar: "baz")], 3)

                XCTAssertEqual(second[MyBar(bar: "foo")], 5)
                XCTAssertEqual(second[MyBar(bar: "oof")], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIdentifyingCerealTypeToInt64() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,103,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,74,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,3,8,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,3,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0])
            if let elements: [[MyBar: Int64]] = try subject.decodeCereal("hi") {
                guard let first: [MyBar: Int64] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [MyBar: Int64] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[MyBar(bar: "bar")], 1)
                XCTAssertEqual(first[MyBar(bar: "baz")], 3)

                XCTAssertEqual(second[MyBar(bar: "foo")], 5)
                XCTAssertEqual(second[MyBar(bar: "oof")], 7)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIdentifyingCerealTypeToString() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,75,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,46,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,134,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,1,1,0,0,0,0,0,0,0,98,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,1,1,0,0,0,0,0,0,0,97,10,134,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,1,1,0,0,0,0,0,0,0,100,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,1,1,0,0,0,0,0,0,0,99])
            if let elements: [[MyBar: String]] = try subject.decodeCereal("hi") {
                guard let first: [MyBar: String] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [MyBar: String] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[MyBar(bar: "bar")], "a")
                XCTAssertEqual(first[MyBar(bar: "baz")], "b")

                XCTAssertEqual(second[MyBar(bar: "foo")], "c")
                XCTAssertEqual(second[MyBar(bar: "oof")], "d")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIdentifyingCerealTypeToFloat() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,87,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,58,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,140,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,5,4,0,0,0,0,0,0,0,205,204,76,62,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,5,4,0,0,0,0,0,0,0,205,204,204,61,10,140,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,5,4,0,0,0,0,0,0,0,205,204,204,62,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,5,4,0,0,0,0,0,0,0,154,153,153,62])
            if let elements: [[MyBar: Float]] = try subject.decodeCereal("hi") {
                guard let first: [MyBar: Float] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [MyBar: Float] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[MyBar(bar: "bar")], 0.1)
                XCTAssertEqual(first[MyBar(bar: "baz")], 0.2)

                XCTAssertEqual(second[MyBar(bar: "foo")], 0.3)
                XCTAssertEqual(second[MyBar(bar: "oof")], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIdentifyingCerealTypeToDouble() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,103,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,74,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,148,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,217,63,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,211,63])
            if let elements: [[MyBar: Double]] = try subject.decodeCereal("hi") {
                guard let first: [MyBar: Double] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [MyBar: Double] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[MyBar(bar: "bar")], 0.1)
                XCTAssertEqual(first[MyBar(bar: "baz")], 0.2)

                XCTAssertEqual(second[MyBar(bar: "foo")], 0.3)
                XCTAssertEqual(second[MyBar(bar: "oof")], 0.4)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIdentifyingCerealTypeToCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,203,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,174,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,198,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,10,198,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111])
            if let elements: [[MyBar: TestCerealType]] = try subject.decodeCerealPair("hi") {
                guard let first: [MyBar: TestCerealType] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [MyBar: TestCerealType] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                var expected = TestCerealType(foo: "bar")
                XCTAssertEqual(first[MyBar(bar: "bar")], expected)
                expected.foo = "baz"
                XCTAssertEqual(first[MyBar(bar: "baz")], expected)

                expected.foo = "foo"
                XCTAssertEqual(second[MyBar(bar: "foo")], expected)
                expected.foo = "oof"
                XCTAssertEqual(second[MyBar(bar: "oof")], expected)
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIdentifyingCerealTypeToIdentifyingCereal() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,3,2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,230,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,226,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,10,226,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102])
            if let elements: [[MyBar: MyBar]] = try subject.decodeCerealPair("hi") {
                guard let first: [MyBar: MyBar] = elements.first else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second: [MyBar: MyBar] = elements.last else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[MyBar(bar: "oof")]?.bar, "bar")
                XCTAssertEqual(first[MyBar(bar: "foo")]?.bar, "baz")

                XCTAssertEqual(second[MyBar(bar: "baz")]?.bar, "foo")
                XCTAssertEqual(second[MyBar(bar: "bar")]?.bar, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withArrayOfDictionary_ofIdentifyingCerealTypeToProtocolIdentifyingCereal() {
        Cereal.register(TestIdentifyingCerealType.self)
        do {
            let subject = try CerealDecoder(encodedBytes: [11,255,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,226,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,224,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,111,111,102,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,10,224,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,122,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,9,12,1,5,0,0,0,0,0,0,0,77,121,66,97,114,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102])
            if let elements: [[MyBar: IdentifyingCerealType]] = try subject.decodeCerealToIdentifyingCerealArray("hi") {
                guard let first = elements.first as? [MyBar: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                guard let second = elements.last as? [MyBar: Fooable] else {
                    XCTFail("Array wasn't decoded correctly")
                    return
                }

                XCTAssertEqual(first[MyBar(bar: "oof")]?.foo, "bar")
                XCTAssertEqual(first[MyBar(bar: "foo")]?.foo, "baz")

                XCTAssertEqual(second[MyBar(bar: "baz")]?.foo, "foo")
                XCTAssertEqual(second[MyBar(bar: "bar")]?.foo, "oof")
            } else {
                XCTFail("Array wasn't decoded correctly")
            }
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    // MARK: Error

    func testDecodingArray_withUnencodedKey_returnsNil() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,67,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,38,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,116,104,101,1,5,0,0,0,0,0,0,0,98,114,111,119,110,1,3,0,0,0,0,0,0,0,102,111,120])
            let elements: [String]? = try subject.decode("bye")
            XCTAssertNil(elements)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingHeterogeneousArray_withUnencodedKey_returnsNil() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,80,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,51,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,33,64])
            let elements: [CerealRepresentable]? = try subject.decode("bye")
            XCTAssertTrue(elements == nil)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withMixedArray_containingCereal_raisesError() {
        do {
            let subject = try CerealDecoder(encodedBytes: [11,88,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,2,0,0,0,0,0,0,0,104,105,10,59,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114])
            let elements: [CerealRepresentable]? = try subject.decode("hi")
            XCTFail("Request should of thrown, but got elements: \(elements)")
        } catch CerealError.InvalidEncoding {
            // If this block is hit the test is a success
        } catch let error {
            XCTFail("Decoding failed with unexpected error: \(error)")
        }
    }

}
