//
//  Gender.swift
//  Cereal
//
//  Created by James Richard on 9/29/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Cereal

enum Gender: Int {
    case Female
    case Male
}

extension Gender: CerealType {
    private struct Keys {
        static let root = "gender"
    }

    init(decoder: CerealDecoder) throws {
        self.init(rawValue: try decoder.decode(Keys.root) ?? Gender.Female.rawValue)!
    }

    func encodeWithCereal(inout cereal: CerealEncoder) throws {
        try cereal.encode(rawValue, forKey: Keys.root)
    }
}
