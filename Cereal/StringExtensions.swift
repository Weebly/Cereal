//
//  StringExtensions.swift
//  Cereal
//
//  Created by James Richard on 7/24/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

extension String {
    func firstOccuranceOfString(_ scanString: String, fromIndex: Index) -> Index? {
        return range(of: scanString, options: [], range: fromIndex ..< endIndex, locale: nil)?.lowerBound
    }
}
