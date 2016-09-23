//
//  Vehicles.swift
//  Cereal
//
//  Created by James Richard on 9/30/15.
//  Copyright © 2015 Weebly. All rights reserved.
//

import Cereal

protocol Vehicle: IdentifyingCerealType {
    var make: String { get }
    var model: String { get }
    var description: String { get }
}

private struct SharedKeys {
    static let make = "make"
    static let model = "model"
}

enum VehicleError: Error {
    case missingData
}

struct Car: Vehicle {
    fileprivate struct Keys {
        static let cylinders = "cylinders"
    }

    let make: String
    let model: String
    let cylinders: Int

    var description: String {
        return "\(model) by \(make) w/ \(cylinders) cylinders"
    }

    static let initializationIdentifier = "car"

    init(decoder: CerealDecoder) throws {
        guard let make: String = try decoder.decode(key: SharedKeys.make) else { throw VehicleError.missingData }
        self.make = make

        guard let model: String = try decoder.decode(key: SharedKeys.model) else { throw VehicleError.missingData }
        self.model = model

        guard let cylinders: Int = try decoder.decode(key: Keys.cylinders) else { throw VehicleError.missingData }
        self.cylinders = cylinders
    }

    init(make: String, model: String, cylinders: Int) {
        self.make = make
        self.model = model
        self.cylinders = cylinders
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(make, forKey: SharedKeys.make)
        try cereal.encode(model, forKey: SharedKeys.model)
        try cereal.encode(cylinders, forKey: Keys.cylinders)
    }
}

struct Train: Vehicle {
    fileprivate struct Keys {
        static let cars = "cars"
    }

    let make: String
    let model: String
    var cars: Int

    var description: String {
        return "\(model) by \(make) pulling \(cars) cars"
    }

    static let initializationIdentifier = "train"

    init(decoder: CerealDecoder) throws {
        guard let make: String = try decoder.decode(key: SharedKeys.make) else { throw VehicleError.missingData }
        self.make = make

        guard let model: String = try decoder.decode(key: SharedKeys.model) else { throw VehicleError.missingData }
        self.model = model

        guard let cars: Int = try decoder.decode(key: Keys.cars) else { throw VehicleError.missingData }
        self.cars = cars
    }

    init(make: String, model: String, cars: Int = 0) {
        self.make = make
        self.model = model
        self.cars = cars
    }

    func encodeWithCereal(_ cereal: inout CerealEncoder) throws {
        try cereal.encode(make, forKey: SharedKeys.make)
        try cereal.encode(model, forKey: SharedKeys.model)
        try cereal.encode(cars, forKey: Keys.cars)
    }
}
