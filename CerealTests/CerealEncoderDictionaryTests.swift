//
//  CerealEncoderDictionaryTests.swift
//  Cereal
//
//  Created by James Richard on 8/24/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import XCTest
@testable import Cereal

class CerealEncoderDictionaryTests: XCTestCase {
    override func tearDown() {
        Cereal.clearRegisteredCerealTypes()
        super.tearDown()
    }

    // MARK: [Date: XXX]

    func testToBytes_withDateToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: true, second: false], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64,6,1,0,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64,6,1,0,0,0,0,0,0,0,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateToIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 15.0)
            let second = Date(timeIntervalSinceReferenceDate: 25.0)
            try subject.encode([first: 1, second: 3], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,46,64,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,57,64,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: 1, second: 123456789012345678] as [Date: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64,3,8,0,0,0,0,0,0,0,1 ,0  ,0 ,0,  0, 0,  0,  0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateToStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: "hello", second: "world"], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,94,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,64,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64,1,5,0,0,0,0,0,0,0,119,111,114,108,100]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64,1,5,0,0,0,0,0,0,0,104,101,108,108,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: 1.3, second: 3.14] as [Date: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64,5,4,0,0,0,0,0,0,0,195,245,72, 64]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64,5,4,0,0,0,0,0,0,0,102,102,166,63]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: 2.3, second: 1.14], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64,4,8,0,0,0,0,0,0,0,61,10,215,163,112,61,242,63]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,2,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = Date(timeIntervalSinceReferenceDate: 10.0)
            let secondKey = Date(timeIntervalSinceReferenceDate: 20.0)
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,150,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = Date(timeIntervalSinceReferenceDate: 10.0)
            let secondKey = Date(timeIntervalSinceReferenceDate: 20.0)
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDateToProtocoledIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = Date(timeIntervalSinceReferenceDate: 10.0)
            let secondKey = Date(timeIntervalSinceReferenceDate: 20.0)
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    // MARK: [URL: XXX]
    
    func testToBytes_withURLToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = URL(string: "http://test.com")!
            let second = URL(string: "http://test1.com")!
            try subject.encode([first: true, second: false], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,101,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,71,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,6,1,0,0,0,0,0,0,0,1]))
            XCTAssertTrue(result.containsSubArray([9,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,6,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withURLToIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = URL(string: "http://test.com")!
            let second = URL(string: "http://test1.com")!
            try subject.encode([first: 1, second: 3], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,115,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,85,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    func testToBytes_withURLToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = URL(string: "http://test.com")!
            let second = URL(string: "http://test1.com")!
            try subject.encode([first: 1, second: 123456789012345678] as [URL: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,115,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,85,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    func testToBytes_withURLToStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = URL(string: "http://test.com")!
            let second = URL(string: "http://test1.com")!
            try subject.encode([first: "hello", second: "world"], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,109,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,79,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,1,5,0,0,0,0,0,0,0,104,101,108,108,111]))
            XCTAssertTrue(result.containsSubArray([9,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,1,5,0,0,0,0,0,0,0,119,111,114,108,100]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withURLToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = URL(string: "http://test.com")!
            let second = URL(string: "http://test1.com")!
            try subject.encode([first: 1.3, second: 3.14] as [URL: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,107,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,77,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,5,4,0,0,0,0,0,0,0,102,102,166,63]))
            XCTAssertTrue(result.containsSubArray([9,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,5,4,0,0,0,0,0,0,0,195,245,72,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    func testToBytes_withURLToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = URL(string: "http://test.com")!
            let second = URL(string: "http://test1.com")!
            try subject.encode([first: 2.3, second: 1.14], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,115,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,85,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,2,64]))
            XCTAssertTrue(result.containsSubArray([9,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,4,8,0,0,0,0,0,0,0,61,10,215,163,112,61,242,63]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withURLToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = URL(string: "http://test.com")!
            let secondKey = URL(string: "http://test1.com")!
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,165,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,135,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
            XCTAssertTrue(result.containsSubArray([9,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withURLToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = URL(string: "http://test.com")!
            let secondKey = URL(string: "http://test1.com")!
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,191,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,161,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,
                                                   0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
            XCTAssertTrue(result.containsSubArray([9,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,
                                                   0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    func testToBytes_withURLToProtocoledIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = URL(string: "http://test.com")!
            let secondKey = URL(string: "http://test1.com")!
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,191,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,161,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,8,15,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,46,99,111,109,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,
                                                   0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
            XCTAssertTrue(result.containsSubArray([9,8,16,0,0,0,0,0,0,0,104,116,116,112,58,47,47,116,101,115,116,49,46,99,111,109,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,
                                                   0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Bool: XXX]

    func testToBytes_withBoolToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([false: true, true: false], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,72,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,42,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: 1, false: 3], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: 1, false: 123456789012345678] as [Bool: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([false: "hello", true: "world"], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,80,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,50,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,1,5,0,0,0,0,0,0,0,104,101,108,108,111]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,1,5,0,0,0,0,0,0,0,119,111,114,108,100]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([false: 1.3, true: 3.14] as [Bool: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,78,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,5,4,0,0,0,0,0,0,0,195,245,72,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: 2.3, false: 1.14], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,61,10,215,163,112,61,242,63]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,2,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([true: first, false: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([true: first, false: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,136,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([true: first, false: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,162,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,132,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToProtocoledIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([true: first, false: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,162,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,132,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int: XXX]

    func testToBytes_withIntToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: true, 2: false], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1, 2: 3], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1, 2: 123456789012345678] as [Int: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: "hello", 1: "world"], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,94,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,64,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,5,0,0,0,0,0,0,0,104,101,108,108,111]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,5,0,0,0,0,0,0,0,119,111,114,108,100]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1.3, 1: 3.14] as [Int: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 2.3, 1: 1.14], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,2,64]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,61,10,215,163,112,61,242,63]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([0: first, 1: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([0: first, 1: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,150,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([0: first, 1: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToProtocoledIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([0: first, 1: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int64: XXX]

    func testToBytes_withInt64ToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: true, 123456789012345678: false] as [Int64: Bool], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1,6,1,0,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1, 123456789012345678: 3] as [Int64: Int], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 123456789012345678, 123456789012345678: 3] as [Int64: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: "hi", 123456789012345678: "!"] as [Int64: String], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,87,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,57,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1,1,1,0,0,0,0,0,0,0,33]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0,104,105]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1.6, 123456789012345678: 3.1] as [Int64: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1,5,4,0,0,0,0,0,0,0,102,102,70,64]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,205,204,204,63]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 8.6, 123456789012345678: 9.4] as [Int64: Double], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,34,64]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,33,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToDateDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 8.6, 123456789012345678: 9.4] as [Int64: Double], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,34,64]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,33,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let data: [Int64: TestCerealType] = [0: first, 123456789012345678: second]
            try subject.encode(data, forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,150,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([0: first, 123456789012345678: second] as [Int64: TestIdentifyingCerealType], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,
                                                   0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,
                                                   0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [String: XXX]

    func testToBytes_withStringToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": true, "bar": true], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,76,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,46,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,6,1,0,0,0,0,0,0,0,1]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,6,1,0,0,0,0,0,0,0,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": 1, "bar": 2], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,90,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,60,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": 123456789012345678, "bar": 2] as [String: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,90,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,60,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": "brown", "bar": "fox"], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,82,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,52,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,120]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,1,5,0,0,0,0,0,0,0,98,114,111,119,110]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": 53.31, "bar": 9.7] as [String: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,82,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,52,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,5,4,0,0,0,0,0,0,0,51,51,27,65]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,5,4,0,0,0,0,0,0,0,113,61,85,66]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": 99.99, "bar": 3.7], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,90,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,60,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,13,64]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,4,8,0,0,0,0,0,0,0,143,194,245,40,92,255,88,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode(["foo": first, "bar": second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,90,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,60,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode(["foo": first, "bar": second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode(["a": first, "b": second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,162,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,132,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,98,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,09,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,97,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Float: XXX]

    func testToBytes_withFloatToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: false, 1.1: false] as [Float: Bool], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,78,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,48,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,128,63,6,1,0,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,140,63,6,1,0,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 123, 1.1: 456] as [Float: Int], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,128,63,2,8,0,0,0,0,0,0,0,123,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,140,63,2,8,0,0,0,0,0,0,0,200,1,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 123456789012345678, 1.1: 456] as [Float: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,128,63,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,140,63,3,8,0,0,0,0,0,0,0,200,1,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: "123", 1.1: "456"] as [Float: String], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,82,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,52,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,128,63,1,3,0,0,0,0,0,0,0,49,50,51]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,140,63,1,3,0,0,0,0,0,0,0,52,53,54]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 1.23, 1.1: 45.6] as [Float: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,84,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,54,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,128,63,5,4,0,0,0,0,0,0,0,164,112,157,63]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,140,63,5,4,0,0,0,0,0,0,0,102,102,54,66]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 1.23, 1.1: 45.6] as [Float: Double], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,128,63,4,8,0,0,0,0,0,0,0,174,71,225,122,20,174,243,63]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,140,63,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,70,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 11.0)
            let second = Date(timeIntervalSinceReferenceDate: 19.0)
            try subject.encode([1.0: first, 1.1: second] as [Float: Date], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,128,63,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,38,64]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,140,63,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,51,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([1.2: first, 1.4: second] as [Float: TestCerealType], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,142,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,51,51,179,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,154,153,153,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([1.2: first, 1.4: second] as [Float: TestIdentifyingCerealType], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,51,51,179,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,154,153,153,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Double: XXX]

    func testToBytes_withDoubleToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: false, 1.1: true], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,86,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,56,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,6,1,0,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,241,63,6,1,0,0,0,0,0,0,0,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 123, 1.1: 456], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,2,8,0,0,0,0,0,0,0,123,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,241,63,2,8,0,0,0,0,0,0,0,200,1,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 123456789012345678, 1.1: 456] as [Double: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,241,63,3,8,0,0,0,0,0,0,0,200,1,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: "123", 1.1: "456"], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,90,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,60,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,1,3,0,0,0,0,0,0,0,49,50,51]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,241,63,1,3,0,0,0,0,0,0,0,52,53,54]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 1.23, 1.1: 45.6] as [Double: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,92,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,62,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,5,4,0,0,0,0,0,0,0,164,112,157,63]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,241,63,5,4,0,0,0,0,0,0,0,102,102,54,66]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 1.23, 1.1: 45.6], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,4,8,0,0,0,0,0,0,0,174,71,225,122,20,174,243,63]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,241,63,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,70,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([1.0: first, 1.1: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,240,63,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,241,63,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([1.2: first, 1.4: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,150,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,243,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([1.2: first, 1.4: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,243,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [CerealType: XXX]

    func testToBytes_withCerealToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: true, second: false], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,136,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,106,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,6,1,0,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,6,1,0,0,0,0,0,0,0,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: 5, second: 6], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,150,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: 1, second: 123456789012345678] as [TestCerealType: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,150,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: "foo", second: "oof"], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,1,3,0,0,0,0,0,0,0,111,111,102]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: 5.3, second: 9.1] as [TestCerealType: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,142,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,112,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,5,4,0,0,0,0,0,0,0,154,153,17,65]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,5,4,0,0,0,0,0,0,0,154,153,169,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: 5.3, second: 9.1], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,150,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,34,64]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,21,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToDateDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestCerealType(foo: "bar")
            let secondKey = TestCerealType(foo: "baz")
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,150,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,120,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([first: third, second: fourth], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,200,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,170,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([first: third, second: fourth], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,226,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,196,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,
                                                   12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,
                                                   12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [IdentifyingCerealType: XXX]

    func testToBytes_withIdentifyingCerealToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: true, second: true], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,162,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,132,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,6,1,0,0,0,0,0,0,0,1]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,6,1,0,0,0,0,0,0,0,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: 5, second: 6], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,2,8,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,2,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: 1, second: 123456789012345678] as [TestIdentifyingCerealType: Int64], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: "foo", second: "oof"], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,166,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,136,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,1,3,0,0,0,0,0,0,0,111,111,102]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,1,3,0,0,0,0,0,0,0,102,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: 5.3, second: 9.1] as [TestIdentifyingCerealType: Float], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,5,4,0,0,0,0,0,0,0,154,153,17,65]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,5,4,0,0,0,0,0,0,0,154,153,169,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: 5.3, second: 9.1], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,34,64]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,21,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToDateDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestIdentifyingCerealType(foo: "bar")
            let secondKey = TestIdentifyingCerealType(foo: "baz")
            let first = Date(timeIntervalSinceReferenceDate: 10.0)
            let second = Date(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,176,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,146,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,52,64]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,36,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([first: third, second: fourth], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,226,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,196,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([first: third, second: fourth], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,252,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,222,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [RawRepresentable: XXX]

    func testToBytes_withStringEnumToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([TestEnum.testCase1: 1, TestEnum.testCase2: 2], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,102,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,72,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,9,0,0,0,0,0,0,0,84,101,115,116,67,97,115,101,49,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,9,0,0,0,0,0,0,0,84,101,115,116,67,97,115,101,50,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntOptionSetToIntDictionary() {
        do {
            let options1: TestSetType = [TestSetType.FirstOption, TestSetType.SecondOption]
            let options2: TestSetType = [TestSetType.ThirdOption]
            let saveDict: [TestSetType: Int] = [options1: 1, options2: 2]

            var subject = CerealEncoder()
            try subject.encode(saveDict, forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,100,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,70,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - Dictionaries of Arrays

    // MARK: [Bool: [XXX]]

    func testToBytes_withBoolToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: [true, false], false: [true, true]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,126,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,96,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,1]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: [1, 2], false: [3, 4]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,154,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,124,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([false: [1, 2], true: [3, 123456789012345678]] as [Bool: [Int64]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,154,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,124,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: ["a", "b"], false: ["c", "d"]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,126,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,96,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99,1,1,0,0,0,0,0,0,0,100]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,1,1,0,0,0,0,0,0,0,98]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: [1.3, 1.4], false: [3.14, 4.14]] as [Bool: [Float]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,138,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,108,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,5,4,0,0,0,0,0,0,0,225,122,132,64]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63,5,4,0,0,0,0,0,0,0,51,51,179,63]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: [1.3, 1.4], false: [3.14, 4.14]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,154,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,124,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,4,8,0,0,0,0,0,0,0,143,194,245,40,92,143,16,64]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([true: [first, second], false: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,254,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,224,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withBoolToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([false: [first, second], true: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,50,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,20,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,0,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,6,1,0,0,0,0,0,0,0,1,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int: [XXX]]

    func testToBytes_withIntToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [true, false], 2: [true, true]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,1]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1, 2], 2: [3, 4]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1, 2], 2: [3, 123456789012345678]] as [Int: [Int64]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,
                                                   3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: ["a", "b"], 1: ["c", "d"]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,1,1,0,0,0,0,0,0,0,98]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99,1,1,0,0,0,0,0,0,0,100]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1.3, 1.4], 1: [3.14, 4.14]] as [Int: [Float]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,152,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,122,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63,5,4,0,0,0,0,0,0,0,51,51,179,63]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,5,4,0,0,0,0,0,0,0,225,122,132,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1.3, 1.4], 1: [3.14, 4.14]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,
                                                   204,204,244,63,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,31,133,235,81,
                                                   184,30,9,64,4,8,0,0,0,0,0,0,0,143,194,245,40,92,143,16,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([0: [first, second], 1: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,12,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,238,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIntToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([0: [first, second], 1: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,64,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,34,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int64: [XXX]]

    func testToBytes_withInt64ToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [false, false], 2: [true, true]] as [Int64: [Bool]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,1]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1, 2], 2: [3, 4]] as [Int64: [Int]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1, 2], 2: [3, 123456789012345678]] as [Int64: [Int64]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75
                                                   ,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: ["a", "b"], 1: ["c", "d"]] as [Int64: [String]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,1,1,0,0,0,0,0,0,0,98]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99,1,1,0,0,0,0,0,0,0,100]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1.3, 1.4], 1: [3.14, 4.14]] as [Int64: [Float]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,152,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,122,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63,5,4,0,0,0,0,0,0,0,51,51,179,63]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,5,4,0,0,0,0,0,0,0,225,122,132,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1.3, 1.4], 1: [3.14, 4.14]] as [Int64: [Double]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,
                                                   4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,4,8,
                                                   0,0,0,0,0,0,0,143,194,245,40,92,143,16,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([0: [first, second], 1: [third, fourth]] as [Int64: [TestCerealType]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,12,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,238,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withInt64ToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([0: [first, second], 1: [third, fourth]] as [Int64: [TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,64,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,34,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [String: [XXX]]

    func testToBytes_withStringToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": [true, false], "bar": [false, true]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,130,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,100,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": [1, 2], "bar": [3, 4]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,158,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,128,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,98,97,114,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,3,0,0,0,0,0,0,0,102,111,111,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["a": [1, 2], "b": [3, 123456789012345678]] as [String: [Int64]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,154,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,124,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,98,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,97,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["x": ["a", "b"], "y": ["c", "d"]] as [String: [String]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,126,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,96,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,121,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99,1,1,0,0,0,0,0,0,0,100]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,120,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,1,1,0,0,0,0,0,0,0,98]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["g": [1.3, 1.4], "h": [3.14, 4.14]] as [String: [Float]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,138,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,108,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,104,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,5,4,0,0,0,0,0,0,0,225,122,132,64]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,103,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63,5,4,0,0,0,0,0,0,0,51,51,179,63]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["a": [1.3, 1.4], "z": [3.14, 4.14]] as [String: [Double]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,154,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,124,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,122,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,4,8,0,0,0,0,0,0,0,143,194,245,40,92,143,16,64]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,97,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode(["a": [first, second], "j": [third, fourth]] as [String: [TestCerealType]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,254,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,224,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,97,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,
                                                   0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,106,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,
                                                   0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withStringToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode(["x": [first, second], "y": [third, fourth]] as [String: [TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,50,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,20,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,121,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
            XCTAssertTrue(result.containsSubArray([9,1,1,0,0,0,0,0,0,0,120,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Float: [XXX]]

    func testToBytes_withFloatToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [true, false], 0.2: [true, false]] as [Float: [Bool]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,132,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,102,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,76,62,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [1, 2], 0.2: [3, 4]] as [Float: [Int]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,160,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,130,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,76,62,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [1, 2], 0.2: [3, 123456789012345678]] as [Float: [Int64]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,160,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,130,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,204,61,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,76,62,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,
                                                   78,243,48,166,75,155,182,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.1: ["a", "b"], 1.2: ["c", "d"]] as [Float: [String]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,132,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,102,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,205,204,140,63,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,1,1,0,0,0,0,0,0,0,98]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,154,153,153,63,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99,1,1,0,0,0,0,0,0,0,100]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([5.1: [1.3, 1.4], 7.25: [3.14, 4.14]] as [Float: [Float]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,144,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,114,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,51,51,163,64,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63,5,4,0,0,0,0,0,0,0,51,51,179,63]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,232,64,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,5,4,0,0,0,0,0,0,0,225,122,132,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.5: [1.3, 1.4], 1.2: [3.14, 4.14]] as [Float: [Double]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,160,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,130,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,192,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,154,153,153,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,4,8,0,0,0,0,0,0,0,143,194,245,40,92,143,16,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([9.1: [first, second], 9.2: [third, fourth]] as [Float: [TestCerealType]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,4,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,230,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,154,153,17,65,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,51,51,19,65,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withFloatToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([0.5: [first, second], 0.6: [third, fourth]] as [Float: [TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,56,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,26,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,0,0,0,63,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,5,4,0,0,0,0,0,0,0,154,153,25,63,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Double: [XXX]]

    func testToBytes_withDoubleToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [true, false], 0.2: [true, false]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [1, 2], 0.2: [3, 4]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,
                                                   2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [1, 2], 0.2: [3, 123456789012345678]] as [Double: [Int64]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,185,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,
                                                   1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,201,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,
                                                   3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182,1]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.1: ["a", "b"], 1.2: ["c", "d"]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,140,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,243,63,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99,1,1,0,0,0,0,0,0,0,100]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,154,153,153,153,153,153,241,63,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,1,1,0,0,0,0,0,0,0,98]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([5.1: [1.3, 1.4], 7.25: [3.14, 4.14]] as [Double: [Float]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,152,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,122,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,20,64,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63,5,4,0,0,0,0,0,0,0,51,51,179,63]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,29,64,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,5,4,0,0,0,0,0,0,0,225,122,132,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.5: [1.3, 1.4], 1.2: [3.14, 4.14]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,168,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,138,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,248,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,243,63,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,4,8,0,0,0,0,0,0,0,143,194,245,40,92,143,16,64]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([9.1: [first, second], 9.2: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,12,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,238,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,34,64,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,34,64,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withDoubleToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([0.5: [first, second], 0.6: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,64,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,34,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,51,51,51,51,51,51,227,63,10,110,0,0,0,0,0,0,0,
                2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111,102]))
            XCTAssertTrue(result.containsSubArray([9,4,8,0,0,0,0,0,0,0,0,0,0,0,0,0,224,63,10,110,0,0,0,0,0,0,0,
                2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [CerealType: [XXX]]

    func testToBytes_withCerealToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [true, false], second: [true, false]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,189,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,159,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [1, 2], second: [3, 4]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,217,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,187,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [1, 2], second: [3, 123456789012345678]] as [TestCerealType: [Int64]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,217,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,187,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: ["a", "b"], second: ["c", "d"]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,189,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,159,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,1,1,0,0,0,0,0,0,0,98]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99,1,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [1.3, 1.4], second: [3.14, 4.14]] as [TestCerealType: [Float]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,201,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,171,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,26,0,0,0,0,0,0,0,
                                                   2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63,5,4,0,0,0,0,0,0,0,51,51,179,63]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,26,0,0,0,0,0,0,0,
                                                   2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,5,4,0,0,0,0,0,0,0,225,122,132]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [1.3, 1.4], second: [3.14, 4.14]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,217,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,187,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,34,0,0,0,0,0,0,0,
                                                   2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,4,8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,34,0,0,0,0,0,0,0,
                                                   2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,4,8,0,0,0,0,0,0,0,143,194,245,40,92,143,16]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestCerealType(foo: "hi")
            let secondKey = TestCerealType(foo: "foo")
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([firstKey: [first, second], secondKey: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,61,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,31,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,
                                                   11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,
                                                   11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withCerealToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestCerealType(foo: "hi")
            let secondKey = TestCerealType(foo: "foo")
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([firstKey: [first, second], secondKey: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,113,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,83,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,11,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,110,0,0,0,0,0,0,0,
                                                   2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,110,0,0,0,0,0,0,0,
                                                   2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                                                   9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [IdentifyingCerealType: [XXX]]

    func testToBytes_withIdentifyingCerealToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [true, true], second: [false, false]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,215,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,185,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,1,6,1,0,0,0,0,0,0,0,1]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0,0,6,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [1, 2], second: [3, 4]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,243,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,213,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,8,0,0,0,0,0,0,0,4,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [1, 2], second: [3, 123456789012345678]] as [TestIdentifyingCerealType: [Int64]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,243,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,213,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,8,0,0,0,0,0,0,0,78,243,48,166,75,155,182]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: ["a", "b"], second: ["c", "d"]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,215,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,185,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,97,1,1,0,0,0,0,0,0,0,98]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,20,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,99,1,1,0,0,0,0,0,0,0]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [1.3, 1.4], second: [3.14, 4.14]] as [TestIdentifyingCerealType: [Float]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,227,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,197,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,102,102,166,63,5,4,0,0,0,0,0,0,0,51,51,179,63]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,26,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,5,4,0,0,0,0,0,0,0,195,245,72,64,5,4,0,0,0,0,0,0,0,225,122,132]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [1.3, 1.4], second: [3.14, 4.14]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,243,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,213,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,205,204,204,204,204,204,244,63,4,
                8,0,0,0,0,0,0,0,102,102,102,102,102,102,246,63]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,34,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,4,8,0,0,0,0,0,0,0,31,133,235,81,184,30,9,64,4,
                8,0,0,0,0,0,0,0,143,194,245,40,92,143,16]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestIdentifyingCerealType(foo: "hi")
            let secondKey = TestIdentifyingCerealType(foo: "foo")
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([firstKey: [first, second], secondKey: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,87,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,57,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,84,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,11,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToBytes_withIdentifyingCerealToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestIdentifyingCerealType(foo: "hi")
            let secondKey = TestIdentifyingCerealType(foo: "foo")
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([firstKey: [first, second], secondKey: [third, fourth]], forKey: "wat")
            let result = subject.toBytes()
            XCTAssertTrue(result.hasArrayPrefix([11,139,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9,1,3,0,0,0,0,0,0,0,119,97,116,10,109,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,24,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,2,0,0,0,0,0,0,0,104,105,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,114,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,98,97,122]))
            XCTAssertTrue(result.containsSubArray([9,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,10,110,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,102,111,111,12,1,4,0,0,0,0,0,0,0,116,105,99,116,25,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
                9,1,3,0,0,0,0,0,0,0,102,111,111,1,3,0,0,0,0,0,0,0,111,111]))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
}
