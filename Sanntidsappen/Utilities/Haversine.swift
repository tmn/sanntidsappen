//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct Haversine {

    static let EARTH_RADIUS_METER = 637100.0

    static func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }

    static func haversineDistsance(firstLocation: (lat: Double, lon: Double), secondLocation: (lat: Double, lon: Double)) -> Double {
        let φ1 = Haversine.degreesToRadians(degrees: firstLocation.lat)
        let φ2 = Haversine.degreesToRadians(degrees: secondLocation.lat)
        let Δφ = Haversine.degreesToRadians(degrees: secondLocation.lat - firstLocation.lat)
        let Δλ = Haversine.degreesToRadians(degrees: secondLocation.lon - firstLocation.lon)

        let a = sin(Δφ/2) * sin(Δφ/2) + cos(φ1) * cos(φ2) * sin(Δλ/2) * sin(Δλ/2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = Haversine.EARTH_RADIUS_METER * c

        return distance
    }

}
