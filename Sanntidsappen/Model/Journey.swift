//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct Journey: Codable, Identifiable, Equatable {
    static func == (lhs: Journey, rhs: Journey) -> Bool {
        return lhs.id == rhs.id
    }

    var id: UUID = UUID()
    let departures: [Departure]

    struct Departure: Codable {
        let aimedDepartureTime: String
        let expectedDepartureTime: String
        let quay: Quay
    }

    struct Quay: Codable {
        let id: String
        let name: String
    }
}

extension Journey {
    enum JourneyDataKeys: String, CodingKey {
        case serviceJourney
    }

    enum ServiceJourneyKeys: String, CodingKey {
        case departures = "estimatedCalls"
    }
}

extension Journey {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataContainerKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: JourneyDataKeys.self, forKey: .data)
        let serviceJourneyContainer = try dataContainer.nestedContainer(keyedBy: ServiceJourneyKeys.self, forKey: .serviceJourney)

        departures = try serviceJourneyContainer.decode([Departure].self, forKey: .departures)
    }
}
