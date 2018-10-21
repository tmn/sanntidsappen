//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct StopRegisterData: Codable {
    let data: StopRegisterStopPlace?
}

struct StopRegisterStopPlace: Codable {
    let stopPlace: [StopRegisterStopPlaceData]
}

struct StopRegisterStopPlaceData: Codable {
    let id: String
    let quays: [StopRegisterQuay]
}

struct StopRegisterQuay: Codable {
    let id: String
    let compassBearing: Double
}
