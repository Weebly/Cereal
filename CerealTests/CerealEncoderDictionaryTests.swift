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

    // MARK: [NSDate: XXX]

    func testToString_withNSDateToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: true, second: false], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,29:"))
            XCTAssertTrue(result.containsSubstring("T,4:10.0:b,1:t"))
            XCTAssertTrue(result.containsSubstring("T,4:20.0:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSDateToIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 15.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 25.0)
            try subject.encode([first: 1, second: 3], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,29:"))
            XCTAssertTrue(result.containsSubstring("T,4:15.0:i,1:1"))
            XCTAssertTrue(result.containsSubstring("T,4:25.0:i,1:3"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSDateToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: 1, second: 123456789012345678] as [NSDate: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,47:"))
            XCTAssertTrue(result.containsSubstring("T,4:10.0:z,1:1"))
            XCTAssertTrue(result.containsSubstring("T,4:20.0:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSDateToStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: "hello", second: "world"], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,37:"))
            XCTAssertTrue(result.containsSubstring("T,4:10.0:s,5:hello"))
            XCTAssertTrue(result.containsSubstring("T,4:20.0:s,5:world"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSDateToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: 1.3, second: 3.14] as [NSDate: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,34:"))
            XCTAssertTrue(result.containsSubstring("T,4:10.0:f,3:1.3"))
            XCTAssertTrue(result.containsSubstring("T,4:20.0:f,4:3.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSDateToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([first: 2.3, second: 1.14], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,34:"))
            XCTAssertTrue(result.containsSubstring("T,4:10.0:d,3:2.3"))
            XCTAssertTrue(result.containsSubstring("T,4:20.0:d,4:1.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSDateToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let secondKey = NSDate(timeIntervalSinceReferenceDate: 20.0)
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,59:"))
            XCTAssertTrue(result.containsSubstring("T,4:10.0:c,15:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("T,4:20.0:c,15:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSDateToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let secondKey = NSDate(timeIntervalSinceReferenceDate: 20.0)
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,73:"))
            XCTAssertTrue(result.containsSubstring("T,4:10.0:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("T,4:20.0:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSDateToProtocoledIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let secondKey = NSDate(timeIntervalSinceReferenceDate: 20.0)
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,73:"))
            XCTAssertTrue(result.containsSubstring("T,4:10.0:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("T,4:20.0:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    // MARK: [NSURL: XXX]
    
    func testToString_withNSURLToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSURL(string: "http://test.com")!
            let second = NSURL(string: "http://test1.com")!
            try subject.encode([first: true, second: false], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,54:"))
            XCTAssertTrue(result.containsSubstring("u,15:http://test.com:b,1:t"))
            XCTAssertTrue(result.containsSubstring("u,16:http://test1.com:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSURLToIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSURL(string: "http://test.com")!
            let second = NSURL(string: "http://test1.com")!
            try subject.encode([first: 1, second: 3], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,54:"))
            XCTAssertTrue(result.containsSubstring("u,15:http://test.com:i,1:1"))
            XCTAssertTrue(result.containsSubstring("u,16:http://test1.com:i,1:3"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    func testToString_withNSURLToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSURL(string: "http://test.com")!
            let second = NSURL(string: "http://test1.com")!
            try subject.encode([first: 1, second: 123456789012345678] as [NSURL: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,72:"))
            XCTAssertTrue(result.containsSubstring("u,15:http://test.com:z,1:1"))
            XCTAssertTrue(result.containsSubstring("u,16:http://test1.com:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    func testToString_withNSURLToStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSURL(string: "http://test.com")!
            let second = NSURL(string: "http://test1.com")!
            try subject.encode([first: "hello", second: "world"], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,62:"))
            XCTAssertTrue(result.containsSubstring("u,15:http://test.com:s,5:hello"))
            XCTAssertTrue(result.containsSubstring("u,16:http://test1.com:s,5:world"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSURLToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSURL(string: "http://test.com")!
            let second = NSURL(string: "http://test1.com")!
            try subject.encode([first: 1.3, second: 3.14] as [NSURL: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,59:"))
            XCTAssertTrue(result.containsSubstring("u,15:http://test.com:f,3:1.3"))
            XCTAssertTrue(result.containsSubstring("u,16:http://test1.com:f,4:3.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    func testToString_withNSURLToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSURL(string: "http://test.com")!
            let second = NSURL(string: "http://test1.com")!
            try subject.encode([first: 2.3, second: 1.14], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,59:"))
            XCTAssertTrue(result.containsSubstring("u,15:http://test.com:d,3:2.3"))
            XCTAssertTrue(result.containsSubstring("u,16:http://test1.com:d,4:1.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSURLToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = NSURL(string: "http://test.com")!
            let secondKey = NSURL(string: "http://test1.com")!
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,84:"))
            XCTAssertTrue(result.containsSubstring("u,15:http://test.com:c,15:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("u,16:http://test1.com:c,15:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withNSURLToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = NSURL(string: "http://test.com")!
            let secondKey = NSURL(string: "http://test1.com")!
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,98:"))
            XCTAssertTrue(result.containsSubstring("u,15:http://test.com:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("u,16:http://test1.com:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
    
    func testToString_withNSURLToProtocoledIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = NSURL(string: "http://test.com")!
            let secondKey = NSURL(string: "http://test1.com")!
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,98:"))
            XCTAssertTrue(result.containsSubstring("u,15:http://test.com:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("u,16:http://test1.com:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Bool: XXX]

    func testToString_withBoolToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([false: true, true: false], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,23:"))
            XCTAssertTrue(result.containsSubstring("b,1:f:b,1:t"))
            XCTAssertTrue(result.containsSubstring("b,1:t:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: 1, false: 3], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,23:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:i,1:1"))
            XCTAssertTrue(result.containsSubstring("b,1:f:i,1:3"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: 1, false: 123456789012345678] as [Bool: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,41:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:z,1:1"))
            XCTAssertTrue(result.containsSubstring("b,1:f:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([false: "hello", true: "world"], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,31:"))
            XCTAssertTrue(result.containsSubstring("b,1:f:s,5:hello"))
            XCTAssertTrue(result.containsSubstring("b,1:t:s,5:world"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([false: 1.3, true: 3.14] as [Bool: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,28:"))
            XCTAssertTrue(result.containsSubstring("b,1:f:f,3:1.3"))
            XCTAssertTrue(result.containsSubstring("b,1:t:f,4:3.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: 2.3, false: 1.14], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,28:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:d,3:2.3"))
            XCTAssertTrue(result.containsSubstring("b,1:f:d,4:1.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToNSDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([true: first, false: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,29:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:T,4:10.0"))
            XCTAssertTrue(result.containsSubstring("b,1:f:T,4:20.0"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([true: first, false: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,53:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:c,15:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("b,1:f:c,15:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([true: first, false: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,67:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("b,1:f:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToProtocoledIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([true: first, false: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,67:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("b,1:f:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int: XXX]

    func testToString_withIntToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: true, 2: false], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,23:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:b,1:t"))
            XCTAssertTrue(result.containsSubstring("i,1:2:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1, 2: 3], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,23:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:i,1:1"))
            XCTAssertTrue(result.containsSubstring("i,1:2:i,1:3"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1, 2: 123456789012345678] as [Int: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,41:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:z,1:1"))
            XCTAssertTrue(result.containsSubstring("i,1:2:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: "hello", 1: "world"], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,31:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:s,5:hello"))
            XCTAssertTrue(result.containsSubstring("i,1:1:s,5:world"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1.3, 1: 3.14] as [Int: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,28:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:f,3:1.3"))
            XCTAssertTrue(result.containsSubstring("i,1:1:f,4:3.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 2.3, 1: 1.14], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,28:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:d,3:2.3"))
            XCTAssertTrue(result.containsSubstring("i,1:1:d,4:1.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToNSDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([0: first, 1: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,29:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:T,4:10.0"))
            XCTAssertTrue(result.containsSubstring("i,1:1:T,4:20.0"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([0: first, 1: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,53:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:c,15:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("i,1:1:c,15:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([0: first, 1: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,67:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("i,1:1:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToProtocoledIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encodeIdentifyingItems([0: first, 1: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,67:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("i,1:1:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int64: XXX]

    func testToString_withInt64ToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: true, 123456789012345678: false] as [Int64: Bool], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,41:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:b,1:t"))
            XCTAssertTrue(result.containsSubstring("z,18:123456789012345678:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1, 123456789012345678: 3] as [Int64: Int], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,41:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:i,1:1"))
            XCTAssertTrue(result.containsSubstring("z,18:123456789012345678:i,1:3"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 123456789012345678, 123456789012345678: 3] as [Int64: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,59:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:z,18:123456789012345678"))
            XCTAssertTrue(result.containsSubstring("z,18:123456789012345678:z,1:3"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: "hi", 123456789012345678: "!"] as [Int64: String], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,42:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:s,2:hi"))
            XCTAssertTrue(result.containsSubstring("z,18:123456789012345678:s,1:!"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 1.6, 123456789012345678: 3.1] as [Int64: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:f,3:1.6"))
            XCTAssertTrue(result.containsSubstring("z,18:123456789012345678:f,3:3.1"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 8.6, 123456789012345678: 9.4] as [Int64: Double], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:d,3:8.6"))
            XCTAssertTrue(result.containsSubstring("z,18:123456789012345678:d,3:9.4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToNSDateDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: 8.6, 123456789012345678: 9.4] as [Int64: Double], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:d,3:8.6"))
            XCTAssertTrue(result.containsSubstring("z,18:123456789012345678:d,3:9.4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let data: [Int64: TestCerealType] = [0: first, 123456789012345678: second]
            try subject.encode(data, forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,71:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:c,15:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("z,18:123456789012345678:c,15:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([0: first, 123456789012345678: second] as [Int64: TestIdentifyingCerealType], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,85:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("z,18:123456789012345678:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [String: XXX]

    func testToString_withStringToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": true, "bar": true], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,27:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:b,1:t"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:b,1:t"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": 1, "bar": 2], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,27:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:i,1:1"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:i,1:2"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": 123456789012345678, "bar": 2] as [String: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:z,18:123456789012345678"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:z,1:2"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": "brown", "bar": "fox"], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:s,5:brown"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:s,3:fox"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": 53.31, "bar": 9.7] as [String: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:f,5:53.31"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:f,3:9.7"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": 99.99, "bar": 3.7], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:d,5:99.99"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:d,3:3.7"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToNSDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode(["foo": first, "bar": second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:T,4:10.0"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:T,4:20.0"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode(["foo": first, "bar": second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,57:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:c,15:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:c,15:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode(["a": first, "b": second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,67:"))
            XCTAssertTrue(result.containsSubstring("s,1:a:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("s,1:b:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Float: XXX]

    func testToString_withFloatToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: false, 1.1: false] as [Float: Bool], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,27:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.0:b,1:f"))
            XCTAssertTrue(result.containsSubstring("f,3:1.1:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 123, 1.1: 456] as [Float: Int], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,31:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.0:i,3:123"))
            XCTAssertTrue(result.containsSubstring("f,3:1.1:i,3:456"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 123456789012345678, 1.1: 456] as [Float: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,47:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.0:z,18:123456789012345678"))
            XCTAssertTrue(result.containsSubstring("f,3:1.1:z,3:456"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: "123", 1.1: "456"] as [Float: String], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,31:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.0:s,3:123"))
            XCTAssertTrue(result.containsSubstring("f,3:1.1:s,3:456"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 1.23, 1.1: 45.6] as [Float: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.0:f,4:1.23"))
            XCTAssertTrue(result.containsSubstring("f,3:1.1:f,4:45.6"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 1.23, 1.1: 45.6] as [Float: Double], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.0:d,4:1.23"))
            XCTAssertTrue(result.containsSubstring("f,3:1.1:d,4:45.6"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToNSDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 11.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 19.0)
            try subject.encode([1.0: first, 1.1: second] as [Float: NSDate], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.0:T,4:11.0"))
            XCTAssertTrue(result.containsSubstring("f,3:1.1:T,4:19.0"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([1.2: first, 1.4: second] as [Float: TestCerealType], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,57:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.2:c,15:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("f,3:1.4:c,15:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([1.2: first, 1.4: second] as [Float: TestIdentifyingCerealType], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,71:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.2:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("f,3:1.4:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Double: XXX]

    func testToString_withDoubleToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: false, 1.1: true], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,27:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.0:b,1:f"))
            XCTAssertTrue(result.containsSubstring("d,3:1.1:b,1:t"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 123, 1.1: 456], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,31:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.0:i,3:123"))
            XCTAssertTrue(result.containsSubstring("d,3:1.1:i,3:456"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 123456789012345678, 1.1: 456] as [Double: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,47:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.0:z,18:123456789012345678"))
            XCTAssertTrue(result.containsSubstring("d,3:1.1:z,3:456"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: "123", 1.1: "456"], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,31:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.0:s,3:123"))
            XCTAssertTrue(result.containsSubstring("d,3:1.1:s,3:456"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 1.23, 1.1: 45.6] as [Double: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.0:f,4:1.23"))
            XCTAssertTrue(result.containsSubstring("d,3:1.1:f,4:45.6"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.0: 1.23, 1.1: 45.6], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.0:d,4:1.23"))
            XCTAssertTrue(result.containsSubstring("d,3:1.1:d,4:45.6"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToNSDateDictionary() {
        do {
            var subject = CerealEncoder()
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([1.0: first, 1.1: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,33:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.0:T,4:10.0"))
            XCTAssertTrue(result.containsSubstring("d,3:1.1:T,4:20.0"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([1.2: first, 1.4: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,57:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.2:c,15:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("d,3:1.4:c,15:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([1.2: first, 1.4: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,71:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.2:p,22:4:tict:k,3:foo:s,3:bar"))
            XCTAssertTrue(result.containsSubstring("d,3:1.4:p,22:4:tict:k,3:foo:s,3:baz"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [CerealType: XXX]

    func testToString_withCerealToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: true, second: false], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,53:"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:bar:b,1:t"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:baz:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: 5, second: 6], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,53:"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:bar:i,1:5"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:baz:i,1:6"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: 1, second: 123456789012345678] as [TestCerealType: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,71:"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:bar:z,1:1"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:baz:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: "foo", second: "oof"], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,57:"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:bar:s,3:foo"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:baz:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: 5.3, second: 9.1] as [TestCerealType: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,57:"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:bar:f,3:5.3"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:baz:f,3:9.1"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            try subject.encode([first: 5.3, second: 9.1], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,57:"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:bar:d,3:5.3"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:baz:d,3:9.1"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToNSDateDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestCerealType(foo: "bar")
            let secondKey = TestCerealType(foo: "baz")
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,59:"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:bar:T,4:10.0"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:baz:T,4:20.0"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([first: third, second: fourth], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,83:"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:foo"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:baz:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([first: third, second: fourth], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,97:"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:foo"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:baz:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [IdentifyingCerealType: XXX]

    func testToString_withIdentifyingCerealToBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: true, second: true], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,67:"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:bar:b,1:t"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:baz:b,1:t"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: 5, second: 6], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,67:"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:bar:i,1:5"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:baz:i,1:6"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: 1, second: 123456789012345678] as [TestIdentifyingCerealType: Int64], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,85:"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:bar:z,1:1"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:baz:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: "foo", second: "oof"], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,71:"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:bar:s,3:foo"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:baz:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: 5.3, second: 9.1] as [TestIdentifyingCerealType: Float], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,71:"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:bar:f,3:5.3"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:baz:f,3:9.1"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            try subject.encode([first: 5.3, second: 9.1], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,71:"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:bar:d,3:5.3"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:baz:d,3:9.1"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToNSDateDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestIdentifyingCerealType(foo: "bar")
            let secondKey = TestIdentifyingCerealType(foo: "baz")
            let first = NSDate(timeIntervalSinceReferenceDate: 10.0)
            let second = NSDate(timeIntervalSinceReferenceDate: 20.0)
            try subject.encode([firstKey: first, secondKey: second], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,73:"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:bar:T,4:10.0"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:baz:T,4:20.0"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([first: third, second: fourth], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,97:"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:foo"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:baz:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([first: third, second: fourth], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,111:"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:foo"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:baz:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [RawRepresentable: XXX]

    func testToString_withStringEnumToIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([TestEnum.TestCase1: 1, TestEnum.TestCase2: 2], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,39:"))
            XCTAssertTrue(result.containsSubstring("s,9:TestCase1:i,1:1"))
            XCTAssertTrue(result.containsSubstring("s,9:TestCase2:i,1:2"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntOptionSetToIntDictionary() {
        do {
            let options1: TestSetType = [TestSetType.FirstOption, TestSetType.SecondOption]
            let options2: TestSetType = [TestSetType.ThirdOption]
            let saveDict: [TestSetType: Int] = [options1: 1, options2: 2]

            var subject = CerealEncoder()
            try subject.encode(saveDict, forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,23:"))
            XCTAssertTrue(result.containsSubstring("i,1:3:i,1:1"))
            XCTAssertTrue(result.containsSubstring("i,1:4:i,1:2"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: - Dictionaries of Arrays

    // MARK: [Bool: [XXX]]

    func testToString_withBoolToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: [true, false], false: [true, true]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:a,11:b,1:t:b,1:f"))
            XCTAssertTrue(result.containsSubstring("b,1:f:a,11:b,1:t:b,1:t"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: [1, 2], false: [3, 4]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:a,11:i,1:1:i,1:2"))
            XCTAssertTrue(result.containsSubstring("b,1:f:a,11:i,1:3:i,1:4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([false: [1, 2], true: [3, 123456789012345678]] as [Bool: [Int64]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,63:"))
            XCTAssertTrue(result.containsSubstring("b,1:f:a,11:z,1:1:z,1:2"))
            XCTAssertTrue(result.containsSubstring("b,1:t:a,29:z,1:3:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: ["a", "b"], false: ["c", "d"]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:a,11:s,1:a:s,1:b"))
            XCTAssertTrue(result.containsSubstring("b,1:f:a,11:s,1:c:s,1:d"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: [1.3, 1.4], false: [3.14, 4.14]] as [Bool: [Float]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,55:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:a,15:f,3:1.3:f,3:1.4"))
            XCTAssertTrue(result.containsSubstring("b,1:f:a,17:f,4:3.14:f,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([true: [1.3, 1.4], false: [3.14, 4.14]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,55:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:a,15:d,3:1.3:d,3:1.4"))
            XCTAssertTrue(result.containsSubstring("b,1:f:a,17:d,4:3.14:d,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([true: [first, second], false: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,105:"))
            XCTAssertTrue(result.containsSubstring("b,1:t:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("b,1:f:a,41:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withBoolToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([false: [first, second], true: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,133:"))
            XCTAssertTrue(result.containsSubstring("b,1:f:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("b,1:t:a,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int: [XXX]]

    func testToString_withIntToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [true, false], 2: [true, true]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:a,11:b,1:t:b,1:f"))
            XCTAssertTrue(result.containsSubstring("i,1:2:a,11:b,1:t:b,1:t"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1, 2], 2: [3, 4]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:a,11:i,1:1:i,1:2"))
            XCTAssertTrue(result.containsSubstring("i,1:2:a,11:i,1:3:i,1:4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1, 2], 2: [3, 123456789012345678]] as [Int: [Int64]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,63:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:a,11:z,1:1:z,1:2"))
            XCTAssertTrue(result.containsSubstring("i,1:2:a,29:z,1:3:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: ["a", "b"], 1: ["c", "d"]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:a,11:s,1:a:s,1:b"))
            XCTAssertTrue(result.containsSubstring("i,1:1:a,11:s,1:c:s,1:d"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1.3, 1.4], 1: [3.14, 4.14]] as [Int: [Float]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,55:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:a,15:f,3:1.3:f,3:1.4"))
            XCTAssertTrue(result.containsSubstring("i,1:1:a,17:f,4:3.14:f,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1.3, 1.4], 1: [3.14, 4.14]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,55:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:a,15:d,3:1.3:d,3:1.4"))
            XCTAssertTrue(result.containsSubstring("i,1:1:a,17:d,4:3.14:d,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([0: [first, second], 1: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,105:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("i,1:1:a,41:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIntToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([0: [first, second], 1: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,133:"))
            XCTAssertTrue(result.containsSubstring("i,1:0:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("i,1:1:a,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Int64: [XXX]]

    func testToString_withInt64ToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [false, false], 2: [true, true]] as [Int64: [Bool]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:a,11:b,1:f:b,1:f"))
            XCTAssertTrue(result.containsSubstring("z,1:2:a,11:b,1:t:b,1:t"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1, 2], 2: [3, 4]] as [Int64: [Int]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:a,11:i,1:1:i,1:2"))
            XCTAssertTrue(result.containsSubstring("z,1:2:a,11:i,1:3:i,1:4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1, 2], 2: [3, 123456789012345678]] as [Int64: [Int64]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,63:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:a,11:z,1:1:z,1:2"))
            XCTAssertTrue(result.containsSubstring("z,1:2:a,29:z,1:3:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: ["a", "b"], 1: ["c", "d"]] as [Int64: [String]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:a,11:s,1:a:s,1:b"))
            XCTAssertTrue(result.containsSubstring("z,1:1:a,11:s,1:c:s,1:d"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1.3, 1.4], 1: [3.14, 4.14]] as [Int64: [Float]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,55:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:a,15:f,3:1.3:f,3:1.4"))
            XCTAssertTrue(result.containsSubstring("z,1:1:a,17:f,4:3.14:f,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0: [1.3, 1.4], 1: [3.14, 4.14]] as [Int64: [Double]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,55:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:a,15:d,3:1.3:d,3:1.4"))
            XCTAssertTrue(result.containsSubstring("z,1:1:a,17:d,4:3.14:d,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([0: [first, second], 1: [third, fourth]] as [Int64: [TestCerealType]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,105:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("z,1:1:a,41:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withInt64ToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([0: [first, second], 1: [third, fourth]] as [Int64: [TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,133:"))
            XCTAssertTrue(result.containsSubstring("z,1:0:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("z,1:1:a,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [String: [XXX]]

    func testToString_withStringToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": [true, false], "bar": [false, true]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,49:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:a,11:b,1:t:b,1:f"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:a,11:b,1:f:b,1:t"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["foo": [1, 2], "bar": [3, 4]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,49:"))
            XCTAssertTrue(result.containsSubstring("s,3:foo:a,11:i,1:1:i,1:2"))
            XCTAssertTrue(result.containsSubstring("s,3:bar:a,11:i,1:3:i,1:4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["a": [1, 2], "b": [3, 123456789012345678]] as [String: [Int64]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,63:"))
            XCTAssertTrue(result.containsSubstring("s,1:a:a,11:z,1:1:z,1:2"))
            XCTAssertTrue(result.containsSubstring("s,1:b:a,29:z,1:3:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["x": ["a", "b"], "y": ["c", "d"]] as [String: [String]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,45:"))
            XCTAssertTrue(result.containsSubstring("s,1:x:a,11:s,1:a:s,1:b"))
            XCTAssertTrue(result.containsSubstring("s,1:y:a,11:s,1:c:s,1:d"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["g": [1.3, 1.4], "h": [3.14, 4.14]] as [String: [Float]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,55:"))
            XCTAssertTrue(result.containsSubstring("s,1:g:a,15:f,3:1.3:f,3:1.4"))
            XCTAssertTrue(result.containsSubstring("s,1:h:a,17:f,4:3.14:f,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode(["a": [1.3, 1.4], "z": [3.14, 4.14]] as [String: [Double]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,55:"))
            XCTAssertTrue(result.containsSubstring("s,1:a:a,15:d,3:1.3:d,3:1.4"))
            XCTAssertTrue(result.containsSubstring("s,1:z:a,17:d,4:3.14:d,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode(["a": [first, second], "j": [third, fourth]] as [String: [TestCerealType]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,105:"))
            XCTAssertTrue(result.containsSubstring("s,1:a:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("s,1:j:a,41:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withStringToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode(["x": [first, second], "y": [third, fourth]] as [String: [TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,133:"))
            XCTAssertTrue(result.containsSubstring("s,1:x:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("s,1:y:a,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Float: [XXX]]

    func testToString_withFloatToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [true, false], 0.2: [true, false]] as [Float: [Bool]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,49:"))
            XCTAssertTrue(result.containsSubstring("f,3:0.1:a,11:b,1:t:b,1:f"))
            XCTAssertTrue(result.containsSubstring("f,3:0.2:a,11:b,1:t:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [1, 2], 0.2: [3, 4]] as [Float: [Int]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,49:"))
            XCTAssertTrue(result.containsSubstring("f,3:0.1:a,11:i,1:1:i,1:2"))
            XCTAssertTrue(result.containsSubstring("f,3:0.2:a,11:i,1:3:i,1:4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [1, 2], 0.2: [3, 123456789012345678]] as [Float: [Int64]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,67:"))
            XCTAssertTrue(result.containsSubstring("f,3:0.1:a,11:z,1:1:z,1:2"))
            XCTAssertTrue(result.containsSubstring("f,3:0.2:a,29:z,1:3:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.1: ["a", "b"], 1.2: ["c", "d"]] as [Float: [String]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,49:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.1:a,11:s,1:a:s,1:b"))
            XCTAssertTrue(result.containsSubstring("f,3:1.2:a,11:s,1:c:s,1:d"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([5.1: [1.3, 1.4], 7.25: [3.14, 4.14]] as [Float: [Float]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,60:"))
            XCTAssertTrue(result.containsSubstring("f,3:5.1:a,15:f,3:1.3:f,3:1.4"))
            XCTAssertTrue(result.containsSubstring("f,4:7.25:a,17:f,4:3.14:f,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.5: [1.3, 1.4], 1.2: [3.14, 4.14]] as [Float: [Double]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,59:"))
            XCTAssertTrue(result.containsSubstring("f,3:1.5:a,15:d,3:1.3:d,3:1.4"))
            XCTAssertTrue(result.containsSubstring("f,3:1.2:a,17:d,4:3.14:d,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([9.1: [first, second], 9.2: [third, fourth]] as [Float: [TestCerealType]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,109:"))
            XCTAssertTrue(result.containsSubstring("f,3:9.1:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("f,3:9.2:a,41:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withFloatToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([0.5: [first, second], 0.6: [third, fourth]] as [Float: [TestIdentifyingCerealType]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,137:"))
            XCTAssertTrue(result.containsSubstring("f,3:0.5:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("f,3:0.6:a,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [Double: [XXX]]

    func testToString_withDoubleToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [true, false], 0.2: [true, false]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,49:"))
            XCTAssertTrue(result.containsSubstring("d,3:0.1:a,11:b,1:t:b,1:f"))
            XCTAssertTrue(result.containsSubstring("d,3:0.2:a,11:b,1:t:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [1, 2], 0.2: [3, 4]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,49:"))
            XCTAssertTrue(result.containsSubstring("d,3:0.1:a,11:i,1:1:i,1:2"))
            XCTAssertTrue(result.containsSubstring("d,3:0.2:a,11:i,1:3:i,1:4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([0.1: [1, 2], 0.2: [3, 123456789012345678]] as [Double: [Int64]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,67:"))
            XCTAssertTrue(result.containsSubstring("d,3:0.1:a,11:z,1:1:z,1:2"))
            XCTAssertTrue(result.containsSubstring("d,3:0.2:a,29:z,1:3:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.1: ["a", "b"], 1.2: ["c", "d"]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,49:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.1:a,11:s,1:a:s,1:b"))
            XCTAssertTrue(result.containsSubstring("d,3:1.2:a,11:s,1:c:s,1:d"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([5.1: [1.3, 1.4], 7.25: [3.14, 4.14]] as [Double: [Float]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,60:"))
            XCTAssertTrue(result.containsSubstring("d,3:5.1:a,15:f,3:1.3:f,3:1.4"))
            XCTAssertTrue(result.containsSubstring("d,4:7.25:a,17:f,4:3.14:f,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            try subject.encode([1.5: [1.3, 1.4], 1.2: [3.14, 4.14]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,59:"))
            XCTAssertTrue(result.containsSubstring("d,3:1.5:a,15:d,3:1.3:d,3:1.4"))
            XCTAssertTrue(result.containsSubstring("d,3:1.2:a,17:d,4:3.14:d,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([9.1: [first, second], 9.2: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,109:"))
            XCTAssertTrue(result.containsSubstring("d,3:9.1:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("d,3:9.2:a,41:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withDoubleToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([0.5: [first, second], 0.6: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,137:"))
            XCTAssertTrue(result.containsSubstring("d,3:0.5:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("d,3:0.6:a,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [CerealType: [XXX]]

    func testToString_withCerealToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [true, false], second: [true, false]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,74:"))
            XCTAssertTrue(result.containsSubstring("c,14:k,3:foo:s,2:hi:a,11:b,1:t:b,1:f"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:foo:a,11:b,1:t:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [1, 2], second: [3, 4]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,74:"))
            XCTAssertTrue(result.containsSubstring("c,14:k,3:foo:s,2:hi:a,11:i,1:1:i,1:2"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:foo:a,11:i,1:3:i,1:4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [1, 2], second: [3, 123456789012345678]] as [TestCerealType: [Int64]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,92:"))
            XCTAssertTrue(result.containsSubstring("c,14:k,3:foo:s,2:hi:a,11:z,1:1:z,1:2"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:foo:a,29:z,1:3:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: ["a", "b"], second: ["c", "d"]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,74:"))
            XCTAssertTrue(result.containsSubstring("c,14:k,3:foo:s,2:hi:a,11:s,1:a:s,1:b"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:foo:a,11:s,1:c:s,1:d"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [1.3, 1.4], second: [3.14, 4.14]] as [TestCerealType: [Float]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,84:"))
            XCTAssertTrue(result.containsSubstring("c,14:k,3:foo:s,2:hi:a,15:f,3:1.3:f,3:1.4"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:foo:a,17:f,4:3.14:f,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestCerealType(foo: "hi")
            let second = TestCerealType(foo: "foo")
            try subject.encode([first: [1.3, 1.4], second: [3.14, 4.14]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,84:"))
            XCTAssertTrue(result.containsSubstring("c,14:k,3:foo:s,2:hi:a,15:d,3:1.3:d,3:1.4"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:foo:a,17:d,4:3.14:d,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestCerealType(foo: "hi")
            let secondKey = TestCerealType(foo: "foo")
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([firstKey: [first, second], secondKey: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,134:"))
            XCTAssertTrue(result.containsSubstring("c,14:k,3:foo:s,2:hi:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:foo:a,41:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withCerealToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestCerealType(foo: "hi")
            let secondKey = TestCerealType(foo: "foo")
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([firstKey: [first, second], secondKey: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,162:"))
            XCTAssertTrue(result.containsSubstring("c,14:k,3:foo:s,2:hi:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("c,15:k,3:foo:s,3:foo:a,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    // MARK: [IdentifyingCerealType: [XXX]]

    func testToString_withIdentifyingCerealToArrayOfBoolDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [true, true], second: [false, false]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,88:"))
            XCTAssertTrue(result.containsSubstring("p,21:4:tict:k,3:foo:s,2:hi:a,11:b,1:t:b,1:t"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:foo:a,11:b,1:f:b,1:f"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToArrayOfIntDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [1, 2], second: [3, 4]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,88:"))
            XCTAssertTrue(result.containsSubstring("p,21:4:tict:k,3:foo:s,2:hi:a,11:i,1:1:i,1:2"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:foo:a,11:i,1:3:i,1:4"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToArrayOfInt64Dictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [1, 2], second: [3, 123456789012345678]] as [TestIdentifyingCerealType: [Int64]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,106:"))
            XCTAssertTrue(result.containsSubstring("p,21:4:tict:k,3:foo:s,2:hi:a,11:z,1:1:z,1:2"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:foo:a,29:z,1:3:z,18:123456789012345678"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToArrayOfStringDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: ["a", "b"], second: ["c", "d"]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,88:"))
            XCTAssertTrue(result.containsSubstring("p,21:4:tict:k,3:foo:s,2:hi:a,11:s,1:a:s,1:b"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:foo:a,11:s,1:c:s,1:d"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToArrayOfFloatDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [1.3, 1.4], second: [3.14, 4.14]] as [TestIdentifyingCerealType: [Float]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,98:"))
            XCTAssertTrue(result.containsSubstring("p,21:4:tict:k,3:foo:s,2:hi:a,15:f,3:1.3:f,3:1.4"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:foo:a,17:f,4:3.14:f,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToArrayOfDoubleDictionary() {
        do {
            var subject = CerealEncoder()
            let first = TestIdentifyingCerealType(foo: "hi")
            let second = TestIdentifyingCerealType(foo: "foo")
            try subject.encode([first: [1.3, 1.4], second: [3.14, 4.14]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,98:"))
            XCTAssertTrue(result.containsSubstring("p,21:4:tict:k,3:foo:s,2:hi:a,15:d,3:1.3:d,3:1.4"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:foo:a,17:d,4:3.14:d,4:4.14"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToArrayOfCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestIdentifyingCerealType(foo: "hi")
            let secondKey = TestIdentifyingCerealType(foo: "foo")
            let first = TestCerealType(foo: "bar")
            let second = TestCerealType(foo: "baz")
            let third = TestCerealType(foo: "foo")
            let fourth = TestCerealType(foo: "oof")
            try subject.encode([firstKey: [first, second], secondKey: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,148:"))
            XCTAssertTrue(result.containsSubstring("p,21:4:tict:k,3:foo:s,2:hi:a,41:c,15:k,3:foo:s,3:bar:c,15:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:foo:a,41:c,15:k,3:foo:s,3:foo:c,15:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }

    func testToString_withIdentifyingCerealToArrayOfIdentifyingCerealDictionary() {
        do {
            var subject = CerealEncoder()
            let firstKey = TestIdentifyingCerealType(foo: "hi")
            let secondKey = TestIdentifyingCerealType(foo: "foo")
            let first = TestIdentifyingCerealType(foo: "bar")
            let second = TestIdentifyingCerealType(foo: "baz")
            let third = TestIdentifyingCerealType(foo: "foo")
            let fourth = TestIdentifyingCerealType(foo: "oof")
            try subject.encode([firstKey: [first, second], secondKey: [third, fourth]], forKey: "wat")
            let result = subject.toString()
            XCTAssertTrue(result.hasPrefix("k,3:wat:m,176:"))
            XCTAssertTrue(result.containsSubstring("p,21:4:tict:k,3:foo:s,2:hi:a,55:p,22:4:tict:k,3:foo:s,3:bar:p,22:4:tict:k,3:foo:s,3:baz"))
            XCTAssertTrue(result.containsSubstring("p,22:4:tict:k,3:foo:s,3:foo:a,55:p,22:4:tict:k,3:foo:s,3:foo:p,22:4:tict:k,3:foo:s,3:oof"))
        } catch let error {
            XCTFail("Encoding failed due to error: \(error)")
        }
    }
}
