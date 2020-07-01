//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct Departure: Codable, Identifiable {
    var id: UUID = UUID()

    /// Indicates if the current Departure is using realtime data or not.
    let realtime: Bool

    /// Arrival time according to the time table.
    let aimedArrivalTime: String

    /// The current expected time. This one may deviate from the aimed
    /// time if the current departure is ahead of time table, or if it is late.
    let expectedArrivalTime: String

    /// Date for the current Departure.
    let date: String

    /// Indicates wether the current Departure is open for boarding.
    let forBoarding: Bool

    /// The destination of the current Departure.
    let destination: String

    /// The Quay information for the current Departure.
    let quay: Quay

    /// The Journey ID of the current Departure.
    let journeyId: String

    /// Line ID of the current Departure.
    let lineId: String

    /// Line number/name/information for the current Departure.
    let lineCode: String

    /// Line Name of the current Departure.
    let lineName: String

    /// Transport mode of the current Departure.
    let transportMode: String


    var aimedTime: Date {
        let dateFormatter = ISO8601DateFormatter()
        let aimedTimeDate = dateFormatter.date(from: aimedArrivalTime)!

        return aimedTimeDate
    }

    var expectedTime: Date {
        let dateFormatter = ISO8601DateFormatter()
        let expectedTimeDate = dateFormatter.date(from: expectedArrivalTime)!

        return expectedTimeDate
    }

    enum DepartureKeys: String, CodingKey {
        case realtime
        case aimedArrivalTime
        case expectedArrivalTime
        case date
        case forBoarding
        case destinationDisplay
        case quay
        case serviceJourney
    }

    enum DestinationDisplayKeys: String, CodingKey {
        case frontText
    }

    enum ServiceJourneyKeys: String, CodingKey {
        case journeyId = "id"
        case journeyPattern
    }

    enum JourneyPatternKeys: String, CodingKey {
        case line
    }

    enum LineKeys: String, CodingKey {
        case lineId = "id"
        case lineCode = "publicCode"
        case lineName = "name"
        case transportMode
    }
}

extension Departure {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DepartureKeys.self)
        let destinationDisplayContainer = try container.nestedContainer(keyedBy: DestinationDisplayKeys.self, forKey: .destinationDisplay)
        let serviceJourneyContainer = try container.nestedContainer(keyedBy: ServiceJourneyKeys.self, forKey: .serviceJourney)
        let journeyPatternContainer = try serviceJourneyContainer.nestedContainer(keyedBy: JourneyPatternKeys.self, forKey: .journeyPattern)
        let lineContainer = try journeyPatternContainer.nestedContainer(keyedBy: LineKeys.self, forKey: .line)

        realtime = try container.decode(Bool.self, forKey: .realtime)
        aimedArrivalTime = try container.decode(String.self, forKey: .aimedArrivalTime)
        expectedArrivalTime = try container.decode(String.self, forKey: .expectedArrivalTime)
        date = try container.decode(String.self, forKey: .date)
        forBoarding = try container.decode(Bool.self, forKey: .realtime)
        destination = try destinationDisplayContainer.decode(String.self, forKey: .frontText)
        quay = try container.decode(Quay.self, forKey: .quay)
        journeyId = try serviceJourneyContainer.decode(String.self, forKey: .journeyId)
        lineId = try lineContainer.decode(String.self, forKey: .lineId)
        lineCode = try lineContainer.decode(String.self, forKey: .lineCode)
        lineName = try lineContainer.decode(String.self, forKey: .lineName)
        transportMode = try lineContainer.decode(String.self, forKey: .transportMode)
    }
}


extension Departure {
    static let departureDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

//extension Departure {
//    func getAimedTimeLabel() -> String {
//        let dateFormatter = ISO8601DateFormatter()
//        let aimedTimeDate = dateFormatter.date(from: aimedArrivalTime)!
//
//        return String(format: NSLocalizedString("Aimed time: %@", comment: "Aimed departure time"), Self.departureDateFormatter.string(from: aimedTimeDate))
//    }
//}


#if DEBUG
let departureTestData = [
    Departure(realtime: true, aimedArrivalTime: "2020-07-01T17:57:00+0200", expectedArrivalTime: "2020-07-01T17:57:00+0200", date: "2020-07-01", forBoarding: true, destination: "Voss", quay: Quay(id: "NSR:Quay:901", name: "Bergen stasjon", publicCode: "1", description: nil), journeyId: "NSB:ServiceJourney:1-1530-2662-202006302108", lineId: "NSB:Line:43", lineCode: "43", lineName: "Vossabanen", transportMode: "rail"),

    Departure(realtime: true, aimedArrivalTime: "2020-07-01T18:34:00+0200", expectedArrivalTime: "2020-07-01T18:34:00+0200", date: "2020-07-01", forBoarding: true, destination: "Arna", quay: Quay(id: "NSR:Quay:905", name: "Bergen stasjon", publicCode: "3", description: nil), journeyId: "NSB:ServiceJourney:1-1031-1828-202006302108", lineId: "NSB:Line:45", lineCode: "45", lineName: "Vossabanen", transportMode: "rail")
]
#endif
