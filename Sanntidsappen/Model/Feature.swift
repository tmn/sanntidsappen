//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct Feature: Codable {
    let features: [Stop]
}

struct Stop: Codable {
    let geometry: Geometry
    let properties: Properties
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
