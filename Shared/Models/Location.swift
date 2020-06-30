//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct Location: Identifiable {
    var id = UUID()
    let title: String
    let locality: String
    let county: String

    var location: String {
        return "\(locality), \(county)"
    }
}

let stopsTestData = [
    Location(title: "Dyre Halses gate", locality: "Trondheim", county: "Trøndelag"),
    Location(title: "Solsiden", locality: "Trondheim", county: "Trøndelag")
]
