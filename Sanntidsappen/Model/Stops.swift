//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

/// A type to represent the feature list from EnTur data set.
struct Stops: Codable {
    let stops: [Stop]

    enum CodingKeys: String, CodingKey {
        case stops = "features"
    }
}
