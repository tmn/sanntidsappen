//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation
import CoreLocation

struct Feature: Codable {
    let features: [Stop]
}

struct Stop: Codable {
    let geometry: Geometry
    let properties: Properties

    func distanceToCurrentLocation(to location: CLLocation) -> Double {
        return Haversine.haversineDistsance(firstLocation: (geometry.coordinates[1], geometry.coordinates[0]), secondLocation: (location.coordinate.latitude, location.coordinate.longitude))
    }
}

struct Geometry: Codable {
    let coordinates: [Double]
}

struct Properties: Codable {
    let id: String
    let name: String
    let locality: String
    let county: String
}
