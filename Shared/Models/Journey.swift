//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

/// A type to represent a Journey from the EnTur data set.
struct Journey {

    /// A type containing the Jounrey data from the EnTur data set.
    struct Journey: Codable {
        let data: JourneyData
    }

    /// A type to represent a Journey.JourneyData from the EnTur data set.
    struct JourneyData: Codable {
        let serviceJourney: ServiceJourney
    }

    /// A type to represent a Journey.ServiceJourney from the EnTur data set.
    struct ServiceJourney: Codable {
        let estimatedCalls: [EstimatedCall]
    }

    /// A type to represent a Journey.EstimatedCall from the EnTur data set.
    struct EstimatedCall: Codable {
        let aimedDepartureTime: String
        let expectedDepartureTime: String
        let quay: Quay
    }

    /// A type to represent a Journey.Quay from the EnTur data set.
    struct Quay: Codable {
        let id: String
        let name: String
        let stopPlace: StopPlace
    }

    /// A type to represent a Journey.StopPlace from the EnTur data set.
    struct StopPlace: Codable {
        let description: String?
    }
}

