//
//  Gender.swift
//  Cereal
//
//  Created by James Richard on 9/29/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Cereal

enum Gender: Int {
    case female
    case male
}

extension Gender: CerealType {
    fileprivate struct Keys {
        static let root = "gender"
    }

    init(decoder: CerealDecoder) throws {
        self.init(rawValue: try decoder.decode(key: Keys.root) ?? Gender.female.rawValue)!
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(rawValue, forKey: Keys.root)
    }
}
