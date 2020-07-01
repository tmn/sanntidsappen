//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct StopPlaceResponse: Codable {
    let id: String
    let name: String
    let departures: [Departure]

    enum StopInfoKeys: String, CodingKey {
        case data
    }

    enum StopDataKeys: String, CodingKey {
        case stopPlace
    }

    enum StopPlaceKeys: String, CodingKey {
        case id
        case name
        case departures = "estimatedCalls"
    }
}

extension StopPlaceResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StopInfoKeys.self)
        let stopDataContainer = try container.nestedContainer(keyedBy: StopDataKeys.self, forKey: .data)
        let stopPlaceContainer = try stopDataContainer.nestedContainer(keyedBy: StopPlaceKeys.self, forKey: .stopPlace)

        id = try stopPlaceContainer.decode(String.self, forKey: .id)
        name = try stopPlaceContainer.decode(String.self, forKey: .name)
        departures = try stopPlaceContainer.decode([Departure].self, forKey: .departures)
    }
}
