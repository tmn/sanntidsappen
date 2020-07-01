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

/// A type to represent the feature list from EnTur data set.
struct Stops: Codable {
    let stops: [Stop]

    enum CodingKeys: String, CodingKey {
        case stops = "features"
    }
}

/// A type to represent the StopPlace object from EnTur data set.
struct Stop: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let locality: String
    let county: String
    let coordinates: [Double]

    enum StopKeys: String, CodingKey {
        case geometry, properties
    }

    enum GeometryKeys: String, CodingKey {
        case coordinates
    }

    enum PropertiesKeys: String, CodingKey {
        case id, name, locality, county
    }
}

extension Stop {
    func distanceToCurrentLocation(to location: CLLocation) -> Double {
        return HaversineDistance.distance(firstLocation: (coordinates[1], coordinates[0]), secondLocation: (location.coordinate.latitude, location.coordinate.longitude))
    }

    var location: String {
        return "\(locality), \(county)"
    }
}

extension Stop {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StopKeys.self)
        let geometryContainer = try container.nestedContainer(keyedBy: GeometryKeys.self, forKey: .geometry)
        let propertiesContainer = try container.nestedContainer(keyedBy: PropertiesKeys.self, forKey: .properties)

        id = try propertiesContainer.decode(String.self, forKey: .id)
        name = try propertiesContainer.decode(String.self, forKey: .name)
        locality = try propertiesContainer.decode(String.self, forKey: .locality)
        county = try propertiesContainer.decode(String.self, forKey: .county)
        coordinates = try geometryContainer.decode([Double].self, forKey: .coordinates)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StopKeys.self)
        var geometryContainer = container.nestedContainer(keyedBy: GeometryKeys.self, forKey: .geometry)
        var propertiesContainer = container.nestedContainer(keyedBy: PropertiesKeys.self, forKey: .properties)

        try propertiesContainer.encode(id, forKey: .id)
        try propertiesContainer.encode(name, forKey: .name)
        try propertiesContainer.encode(locality, forKey: .locality)
        try propertiesContainer.encode(county, forKey: .county)
        try geometryContainer.encode(coordinates, forKey: .coordinates)
    }
}

#if DEBUG
let stopTestData = [
    Stop(id: "NSR:StopPlace:43097", name: "Solbakken skole", locality: "Trondheim", county: "Trøndelag", coordinates: [10.523795, 63.402178]),
    Stop(id: "NSR:StopPlace:43125", name: "Solheim skole", locality: "Ørland", county: "Trøndelag", coordinates: [9.82678, 63.842615])
]
#endif
