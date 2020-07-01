//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

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
