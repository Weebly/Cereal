//
//  AssertionHelpers.swift
//  Cereal
//
//  Created by James Richard on 8/12/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Foundation

extension String {
    func containsSubstring(substring: String) -> Bool {
        return rangeOfString(substring) != nil
    }
}
