//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct Departure: Identifiable {
    var id = UUID()
    let line: String
    let title: String
}

let departureTestData = [
    Departure(line: "4", title: "Ranheism"),
    Departure(line: "N15", title: "Solsiden"),
    Departure(line: "N14", title: "Strindheim"),
    Departure(line: "4", title: "Ranheim"),
    Departure(line: "N15", title: "Solsiden"),
    Departure(line: "N14", title: "Strindheim")
]
