//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

/// A type to represent StopInfo from the EnTur data set.
struct StopInfo: Codable {
    let data: StopData
}

/// A type to represent StopData from the EnTur data set.
struct StopData: Codable {
    let stopPlace: StopPlace
}

/// A type to represent StopPlace from the EnTur data set.
struct StopPlace: Codable {
    let id: String
    let name: String
    let estimatedCalls: [EstimatedCall]
}

/// A type to represent EstimatedCall from the EnTur data set.
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

/// A type to represent DestinationDisplay from the EnTur data set.
struct DestinationDisplay: Codable {
    let frontText: String
}

/// A type to represent Quay from the EnTur data set.
struct Quay: Codable, Hashable, Comparable {
    let id: String
    let name: String
    let publicCode: String
    let description: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Quay, rhs: Quay) -> Bool {
        if lhs.publicCode.isEmpty {
            return lhs.id.split(separator: ":").last ?? "" == rhs.id.split(separator: ":").last ?? ""
        } else {
            return lhs.publicCode == rhs.publicCode
        }
    }

    static func < (lhs: Quay, rhs: Quay) -> Bool {
        if lhs.publicCode.isEmpty {
            return lhs.id.split(separator: ":").last ?? "" < rhs.id.split(separator: ":").last ?? ""
        } else {
            return lhs.publicCode < rhs.publicCode
        }
    }
}

/// A type to represent ServiceJourney from the EnTur data set.
struct ServiceJourney: Codable {
    let id: String
    let journeyPattern: JourneyPattern
}

/// A type to represent JourneyPattern from the EnTur data set.
struct JourneyPattern: Codable {
    let line: Line
}

/// A type to represent Line from the EnTur data set.
struct Line: Codable {
    let publicCode: String
    let transportMode: String
}
