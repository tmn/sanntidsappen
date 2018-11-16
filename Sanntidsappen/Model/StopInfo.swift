//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct StopInfo: Codable {
    let data: StopData
}

struct StopData: Codable {
    let stopPlace: StopPlace
}

struct StopPlace: Codable {
    let id: String
    let name: String
    let estimatedCalls: [EstimatedCall]
}

struct EstimatedCall: Codable {
    let realtime: Bool
    let aimedArrivalTime: String
    let expectedArrivalTime: String
    let date: String
    let forBoarding: Bool
    let destinationDisplay: DestinationDisplay
    let quay: Quay
    let serviceJourney: ServiceJourney
}

struct DestinationDisplay: Codable {
    let frontText: String
}

struct Quay: Codable, Hashable {
    let id: String
    let name: String
    let publicCode: String
    let description: String?

    var hashValue: Int {
        return id.hashValue
    }

    static func == (lhs: Quay, rhs: Quay) -> Bool {
        return lhs.publicCode == rhs.publicCode && lhs.id == rhs.id
    }
}

struct ServiceJourney: Codable {
    let id: String
    let journeyPattern: JourneyPattern
}

struct JourneyPattern: Codable {
    let line: Line
}

struct Line: Codable {
    let publicCode: String
    let transportMode: String
}
