//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation
import CoreLocation
import HaversineDistance


/// A type to represent a Feature from EnTur data set.
struct Feature: Codable {
    let features: [Stop]
}

/// A type to represent a Stop from the EnTur data set.
struct Stop: Codable {
    let geometry: Geometry
    let properties: Properties

    func distanceToCurrentLocation(to location: CLLocation) -> Double {
        return HaversineDistance.distance(firstLocation: (geometry.coordinates[1], geometry.coordinates[0]), secondLocation: (location.coordinate.latitude, location.coordinate.longitude))
    }
}

/// A type to represent a Geometry from the EnTur data set.
struct Geometry: Codable {
    let coordinates: [Double]
}

/// A type to represent Properties from the EnTur data set.
struct Properties: Codable {
    let id: String
    let name: String
    let locality: String
    let county: String
}
