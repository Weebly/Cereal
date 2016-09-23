//
//  AssertionHelpers.swift
//  Cereal
//
//  Created by James Richard on 8/12/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Foundation

extension String {
    func containsSubstring(_ substring: String) -> Bool {
        return range(of: substring) != nil
    }
}
