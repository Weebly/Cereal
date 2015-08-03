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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,17:b,1:t:b,1:f:b,1:f")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,18:i,1:5:i,1:3:i,2:80")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,21:z,2:53:z,2:13:z,3:809")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,22:d,3:5.3:d,2:13:d,3:8.9")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,22:f,3:1.3:f,2:33:f,3:9.9")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,25:s,3:the:s,5:brown:s,3:fox")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,19:i,1:5:i,1:3:d,3:8.5")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,39:i,1:5:i,1:3:p,22:4:tict:k,3:foo:s,3:baz")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:b,1:t:i,1:1:b,1:f:i,1:3:m,23:b,1:t:i,1:5:b,1:f:i,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:b,1:t:z,1:1:b,1:f:z,1:3:m,23:b,1:f:z,1:5:b,1:t:z,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:b,1:f:s,1:a:b,1:t:s,1:b:m,23:b,1:t:s,1:c:b,1:f:s,1:d")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:b,1:t:f,3:0.1:b,1:f:f,3:0.2:m,27:b,1:t:f,3:0.3:b,1:f:f,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:b,1:t:d,3:0.1:b,1:f:d,3:0.2:m,27:b,1:t:d,3:0.3:b,1:f:d,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,117:m,53:b,1:t:c,15:k,3:foo:s,3:bar:b,1:f:c,15:k,3:foo:s,3:baz:m,53:b,1:t:c,15:k,3:foo:s,3:foo:b,1:f:c,15:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,149:m,69:b,1:t:p,23:5:MyBar:k,3:bar:s,3:bar:b,1:f:p,23:5:MyBar:k,3:bar:s,3:baz:m,69:b,1:t:p,23:5:MyBar:k,3:bar:s,3:foo:b,1:f:p,23:5:MyBar:k,3:bar:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,145:m,67:b,1:t:p,22:4:tict:k,3:foo:s,3:bar:b,1:f:p,22:4:tict:k,3:foo:s,3:baz:m,67:b,1:t:p,22:4:tict:k,3:foo:s,3:foo:b,1:f:p,22:4:tict:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:i,1:0:b,1:t:i,1:2:b,1:f:m,23:i,1:4:b,1:t:i,1:6:b,1:f")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:i,1:0:i,1:1:i,1:2:i,1:3:m,23:i,1:4:i,1:5:i,1:6:i,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:i,1:0:z,1:1:i,1:2:z,1:3:m,23:i,1:4:z,1:5:i,1:6:z,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:i,1:0:s,1:a:i,1:2:s,1:b:m,23:i,1:4:s,1:c:i,1:6:s,1:d")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:i,1:0:f,3:0.1:i,1:2:f,3:0.2:m,27:i,1:4:f,3:0.3:i,1:6:f,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:i,1:0:d,3:0.1:i,1:2:d,3:0.2:m,27:i,1:4:d,3:0.3:i,1:6:d,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,117:m,53:i,1:0:c,15:k,3:foo:s,3:bar:i,1:2:c,15:k,3:foo:s,3:baz:m,53:i,1:4:c,15:k,3:foo:s,3:foo:i,1:6:c,15:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,149:m,69:i,1:0:p,23:5:MyBar:k,3:bar:s,3:bar:i,1:2:p,23:5:MyBar:k,3:bar:s,3:baz:m,69:i,1:4:p,23:5:MyBar:k,3:bar:s,3:foo:i,1:6:p,23:5:MyBar:k,3:bar:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,145:m,67:i,1:0:p,22:4:tict:k,3:foo:s,3:bar:i,1:2:p,22:4:tict:k,3:foo:s,3:baz:m,67:i,1:4:p,22:4:tict:k,3:foo:s,3:foo:i,1:6:p,22:4:tict:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:z,1:0:b,1:t:z,1:2:b,1:t:m,23:z,1:4:b,1:f:z,1:6:b,1:f")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:z,1:0:i,1:1:z,1:2:i,1:3:m,23:z,1:4:i,1:5:z,1:6:i,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:z,1:0:z,1:1:z,1:2:z,1:3:m,23:z,1:4:z,1:5:z,1:6:z,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:z,1:0:s,1:a:z,1:2:s,1:b:m,23:z,1:4:s,1:c:z,1:6:s,1:d")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:z,1:0:f,3:0.1:z,1:2:f,3:0.2:m,27:z,1:4:f,3:0.3:z,1:6:f,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:z,1:0:d,3:0.1:z,1:2:d,3:0.2:m,27:z,1:4:d,3:0.3:z,1:6:d,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,117:m,53:z,1:0:c,15:k,3:foo:s,3:bar:z,1:2:c,15:k,3:foo:s,3:baz:m,53:z,1:4:c,15:k,3:foo:s,3:foo:z,1:6:c,15:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,149:m,69:z,1:0:p,23:5:MyBar:k,3:bar:s,3:bar:z,1:2:p,23:5:MyBar:k,3:bar:s,3:baz:m,69:z,1:4:p,23:5:MyBar:k,3:bar:s,3:foo:z,1:6:p,23:5:MyBar:k,3:bar:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,145:m,67:z,1:0:p,22:4:tict:k,3:foo:s,3:bar:z,1:2:p,22:4:tict:k,3:foo:s,3:baz:m,67:z,1:4:p,22:4:tict:k,3:foo:s,3:foo:z,1:6:p,22:4:tict:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:s,1:a:b,1:f:s,1:b:b,1:f:m,23:s,1:c:b,1:t:s,1:d:b,1:t")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:s,1:a:i,1:1:s,1:b:i,1:3:m,23:s,1:c:i,1:5:s,1:d:i,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:s,1:a:z,1:1:s,1:b:z,1:3:m,23:s,1:c:z,1:5:s,1:d:z,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,57:m,23:s,1:w:s,1:a:s,1:x:s,1:b:m,23:s,1:y:s,1:c:s,1:z:s,1:d")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:s,1:a:f,3:0.1:s,1:b:f,3:0.2:m,27:s,1:c:f,3:0.3:s,1:d:f,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:s,1:a:d,3:0.1:s,1:b:d,3:0.2:m,27:s,1:c:d,3:0.3:s,1:d:d,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,117:m,53:s,1:a:c,15:k,3:foo:s,3:bar:s,1:b:c,15:k,3:foo:s,3:baz:m,53:s,1:c:c,15:k,3:foo:s,3:foo:s,1:d:c,15:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,149:m,69:s,1:a:p,23:5:MyBar:k,3:bar:s,3:bar:s,1:b:p,23:5:MyBar:k,3:bar:s,3:baz:m,69:s,1:c:p,23:5:MyBar:k,3:bar:s,3:foo:s,1:d:p,23:5:MyBar:k,3:bar:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,145:m,67:s,1:a:p,22:4:tict:k,3:foo:s,3:bar:s,1:b:p,22:4:tict:k,3:foo:s,3:baz:m,67:s,1:c:p,22:4:tict:k,3:foo:s,3:foo:s,1:d:p,22:4:tict:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:f,3:0.0:b,1:t:f,3:0.2:b,1:f:m,27:f,3:0.4:b,1:t:f,3:0.6:b,1:f")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:f,3:0.0:i,1:1:f,3:0.2:i,1:3:m,27:f,3:0.4:i,1:5:f,3:0.6:i,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:f,3:0.0:z,1:1:f,3:0.2:z,1:3:m,27:f,3:0.4:z,1:5:f,3:0.6:z,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:f,3:0.0:s,1:a:f,3:0.2:s,1:b:m,27:f,3:0.4:s,1:c:f,3:0.6:s,1:d")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,73:m,31:f,3:0.0:f,3:0.1:f,3:0.2:f,3:0.2:m,31:f,3:0.4:f,3:0.3:f,3:0.6:f,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,73:m,31:f,3:0.0:d,3:0.1:f,3:0.2:d,3:0.2:m,31:f,3:0.4:d,3:0.3:f,3:0.6:d,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,125:m,57:f,3:0.0:c,15:k,3:foo:s,3:bar:f,3:0.2:c,15:k,3:foo:s,3:baz:m,57:f,3:0.4:c,15:k,3:foo:s,3:foo:f,3:0.6:c,15:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,157:m,73:f,3:0.0:p,23:5:MyBar:k,3:bar:s,3:bar:f,3:0.2:p,23:5:MyBar:k,3:bar:s,3:baz:m,73:f,3:0.4:p,23:5:MyBar:k,3:bar:s,3:foo:f,3:0.6:p,23:5:MyBar:k,3:bar:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,153:m,71:f,3:0.0:p,22:4:tict:k,3:foo:s,3:bar:f,3:0.2:p,22:4:tict:k,3:foo:s,3:baz:m,71:f,3:0.4:p,22:4:tict:k,3:foo:s,3:foo:f,3:0.6:p,22:4:tict:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:d,3:0.0:b,1:t:d,3:0.2:b,1:t:m,27:d,3:0.4:b,1:f:d,3:0.6:b,1:f")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:d,3:0.0:i,1:1:d,3:0.2:i,1:3:m,27:d,3:0.4:i,1:5:d,3:0.6:i,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:d,3:0.0:z,1:1:d,3:0.2:z,1:3:m,27:d,3:0.4:z,1:5:d,3:0.6:z,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,65:m,27:d,3:0.0:s,1:a:d,3:0.2:s,1:b:m,27:d,3:0.4:s,1:c:d,3:0.6:s,1:d")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,73:m,31:d,3:0.0:f,3:0.1:d,3:0.2:f,3:0.2:m,31:d,3:0.4:f,3:0.3:d,3:0.6:f,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,73:m,31:d,3:0.0:d,3:0.1:d,3:0.2:d,3:0.2:m,31:d,3:0.4:d,3:0.3:d,3:0.6:d,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,125:m,57:d,3:0.0:c,15:k,3:foo:s,3:bar:d,3:0.2:c,15:k,3:foo:s,3:baz:m,57:d,3:0.4:c,15:k,3:foo:s,3:foo:d,3:0.6:c,15:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,157:m,73:d,3:0.0:p,23:5:MyBar:k,3:bar:s,3:bar:d,3:0.2:p,23:5:MyBar:k,3:bar:s,3:baz:m,73:d,3:0.4:p,23:5:MyBar:k,3:bar:s,3:foo:d,3:0.6:p,23:5:MyBar:k,3:bar:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,153:m,71:d,3:0.0:p,22:4:tict:k,3:foo:s,3:bar:d,3:0.2:p,22:4:tict:k,3:foo:s,3:baz:m,71:d,3:0.4:p,22:4:tict:k,3:foo:s,3:foo:d,3:0.6:p,22:4:tict:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,117:m,53:c,15:k,3:foo:s,3:bar:b,1:t:c,15:k,3:foo:s,3:baz:b,1:f:m,53:c,15:k,3:foo:s,3:foo:b,1:t:c,15:k,3:foo:s,3:oof:b,1:f")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,117:m,53:c,15:k,3:foo:s,3:bar:i,1:1:c,15:k,3:foo:s,3:baz:i,1:3:m,53:c,15:k,3:foo:s,3:foo:i,1:5:c,15:k,3:foo:s,3:oof:i,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,117:m,53:c,15:k,3:foo:s,3:bar:z,1:1:c,15:k,3:foo:s,3:baz:z,1:3:m,53:c,15:k,3:foo:s,3:foo:z,1:5:c,15:k,3:foo:s,3:oof:z,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,117:m,53:c,15:k,3:foo:s,3:bar:s,1:a:c,15:k,3:foo:s,3:baz:s,1:b:m,53:c,15:k,3:foo:s,3:foo:s,1:c:c,15:k,3:foo:s,3:oof:s,1:d")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,125:m,57:c,15:k,3:foo:s,3:bar:f,3:0.1:c,15:k,3:foo:s,3:baz:f,3:0.2:m,57:c,15:k,3:foo:s,3:foo:f,3:0.3:c,15:k,3:foo:s,3:oof:f,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,125:m,57:c,15:k,3:foo:s,3:bar:d,3:0.1:c,15:k,3:foo:s,3:baz:d,3:0.2:m,57:c,15:k,3:foo:s,3:foo:d,3:0.3:c,15:k,3:foo:s,3:oof:d,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,177:m,83:c,15:k,3:foo:s,3:oof:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:baz:m,83:c,15:k,3:foo:s,3:baz:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,209:m,99:c,15:k,3:foo:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:bar:c,15:k,3:foo:s,3:baz:p,23:5:MyBar:k,3:bar:s,3:baz:m,99:c,15:k,3:foo:s,3:foo:p,23:5:MyBar:k,3:bar:s,3:foo:c,15:k,3:foo:s,3:oof:p,23:5:MyBar:k,3:bar:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,205:m,97:c,15:k,3:foo:s,3:oof:p,22:4:tict:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:baz:m,97:c,15:k,3:foo:s,3:baz:p,22:4:tict:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,149:m,69:p,23:5:MyBar:k,3:bar:s,3:bar:b,1:t:p,23:5:MyBar:k,3:bar:s,3:baz:b,1:f:m,69:p,23:5:MyBar:k,3:bar:s,3:foo:b,1:t:p,23:5:MyBar:k,3:bar:s,3:oof:b,1:f")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,149:m,69:p,23:5:MyBar:k,3:bar:s,3:bar:i,1:1:p,23:5:MyBar:k,3:bar:s,3:baz:i,1:3:m,69:p,23:5:MyBar:k,3:bar:s,3:foo:i,1:5:p,23:5:MyBar:k,3:bar:s,3:oof:i,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,149:m,69:p,23:5:MyBar:k,3:bar:s,3:bar:z,1:1:p,23:5:MyBar:k,3:bar:s,3:baz:z,1:3:m,69:p,23:5:MyBar:k,3:bar:s,3:foo:z,1:5:p,23:5:MyBar:k,3:bar:s,3:oof:z,1:7")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,149:m,69:p,23:5:MyBar:k,3:bar:s,3:bar:s,1:a:p,23:5:MyBar:k,3:bar:s,3:baz:s,1:b:m,69:p,23:5:MyBar:k,3:bar:s,3:foo:s,1:c:p,23:5:MyBar:k,3:bar:s,3:oof:s,1:d")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,157:m,73:p,23:5:MyBar:k,3:bar:s,3:bar:f,3:0.1:p,23:5:MyBar:k,3:bar:s,3:baz:f,3:0.2:m,73:p,23:5:MyBar:k,3:bar:s,3:foo:f,3:0.3:p,23:5:MyBar:k,3:bar:s,3:oof:f,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,157:m,73:p,23:5:MyBar:k,3:bar:s,3:bar:d,3:0.1:p,23:5:MyBar:k,3:bar:s,3:baz:d,3:0.2:m,73:p,23:5:MyBar:k,3:bar:s,3:foo:d,3:0.3:p,23:5:MyBar:k,3:bar:s,3:oof:d,3:0.4")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,209:m,99:p,23:5:MyBar:k,3:bar:s,3:bar:c,15:k,3:foo:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:baz:c,15:k,3:foo:s,3:baz:m,99:p,23:5:MyBar:k,3:bar:s,3:foo:c,15:k,3:foo:s,3:foo:p,23:5:MyBar:k,3:bar:s,3:oof:c,15:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,243:m,115:p,23:5:MyBar:k,3:bar:s,3:oof:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:foo:p,23:5:MyBar:k,3:bar:s,3:baz:m,115:p,23:5:MyBar:k,3:bar:s,3:baz:p,23:5:MyBar:k,3:bar:s,3:foo:p,23:5:MyBar:k,3:bar:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,239:m,113:p,23:5:MyBar:k,3:bar:s,3:oof:p,22:4:tict:k,3:foo:s,3:bar:p,23:5:MyBar:k,3:bar:s,3:foo:p,22:4:tict:k,3:foo:s,3:baz:m,113:p,23:5:MyBar:k,3:bar:s,3:baz:p,22:4:tict:k,3:foo:s,3:foo:p,23:5:MyBar:k,3:bar:s,3:bar:p,22:4:tict:k,3:foo:s,3:oof")
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
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,25:s,3:the:s,5:brown:s,3:fox")
            let elements: [String]? = try subject.decode("bye")
            XCTAssertNil(elements)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecodingHeterogeneousArray_withUnencodedKey_returnsNil() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,19:i,1:5:i,1:3:d,3:8.5")
            let elements: [CerealRepresentable]? = try subject.decode("bye")
            XCTAssertTrue(elements == nil)
        } catch let error {
            XCTFail("Decoding failed due to error: \(error)")
        }
    }

    func testDecoding_withMixedArray_containingCereal_raisesError() {
        do {
            let subject = try CerealDecoder(encodedString: "k,2:hi:a,19:i,1:5:i,1:3:c,15:k,3:foo:s,3:bar")
            let elements: [CerealRepresentable]? = try subject.decode("hi")
            XCTFail("Request should of thrown, but got elements: \(elements)")
        } catch CerealError.InvalidEncoding {
            // If this block is hit the test is a success
        } catch let error {
            XCTFail("Decoding failed with unexpected error: \(error)")
        }
    }
}
