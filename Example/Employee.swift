//
//  Employee.swift
//  Cereal
//
//  Created by James Richard on 9/29/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Cereal

struct Employee {
    var name = ""
    var age = 18
    var gender: Gender = .Female

    init() { }
}

extension Employee: CerealType {
    private struct Keys {
        static let name = "name"
        static let age = "age"
        static let gender = "gender"
    }

    init(cereal: CerealDecoder) throws {
        name = try cereal.decode(Keys.name) ?? ""
        age = try cereal.decode(Keys.age) ?? 0
        gender = try cereal.decodeCereal(Keys.gender) ?? .Female
    }

    func encodeWithCereal(inout cereal: CerealEncoder) throws {
        try cereal.encode(name, forKey: Keys.name)
        try cereal.encode(age, forKey: Keys.age)
        try cereal.encode(gender, forKey: Keys.gender)
    }
}
/*
extension Employee: Equatable { }

func == (lhs: Employee, rhs: Employee) -> Bool {
    return lhs.name == rhs.name && lhs.age == rhs.age && lhs.gender = rhs.gender
}
*/