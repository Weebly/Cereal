//
//  StringExtensions.swift
//  Cereal
//
//  Created by James Richard on 7/24/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

extension String {
    func firstOccuranceOfString(scanString: String, fromIndex: Index) -> Index? {
        return rangeOfString(scanString, options: [], range: fromIndex ..< endIndex, locale: nil)?.startIndex
    }
}
