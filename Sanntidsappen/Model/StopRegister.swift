//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

/// A type to represent StopRegister from the EnTur data set.
struct StopRegister: Codable {
    var id: UUID = UUID()
    let stopPlaces: [StopPlace]

    /// A type to represent Quay in StopRegister from the EnTur data set.
    struct Quay: Codable {
        let id: String
        let compassBearing: Double?
    }

    struct StopPlace: Codable {
        let id: String
        let quays: [Quay]
    }
}

extension StopRegister {
    enum StopPlaceKeys: String, CodingKey {
        case stopPlace
    }
}

extension StopRegister {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataContainerKeys.self)
        let stopPlaceContainer = try container.nestedContainer(keyedBy: StopPlaceKeys.self, forKey: .data)

        stopPlaces = try stopPlaceContainer.decode([StopPlace].self, forKey: .stopPlace)
    }
}
