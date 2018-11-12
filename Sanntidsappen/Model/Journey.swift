//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct Journey {

    struct Journey: Codable {
        let data: JourneyData
    }

    struct JourneyData: Codable {
        let serviceJourney: ServiceJourney
    }

    struct ServiceJourney: Codable {
        let estimatedCalls: [EstimatedCall]
    }

    struct EstimatedCall: Codable {
        let aimedDepartureTime: String
        let expectedDepartureTime: String
        let quay: Quay
    }

    struct Quay: Codable {
        let id: String
        let name: String
        let stopPlace: StopPlace
    }

    struct StopPlace: Codable {
        let description: String?
    }
}

