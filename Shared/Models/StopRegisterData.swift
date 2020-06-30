//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

/// A type to represent StopRegisterData from the EnTur data set.
struct StopRegisterData: Codable {
    let data: StopRegisterStopPlace?
}

/// A type to represent StopRegisterStopPlace from the EnTur data set.
struct StopRegisterStopPlace: Codable {
    let stopPlace: [StopRegisterStopPlaceData]
}

/// A type to represent StopRegisterStopPlaceData from the EnTur data set.
struct StopRegisterStopPlaceData: Codable {
    let id: String
    let quays: [StopRegisterQuay]
}

/// A type to represent StopRegisterQuay from the EnTur data set.
struct StopRegisterQuay: Codable {
    let id: String
    let compassBearing: Double
}
