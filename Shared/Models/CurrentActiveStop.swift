//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Combine

class CurrentActiveStop: ObservableObject {
    @Published var stop: Stop? = nil {
        didSet {
            if stop != nil {
                getDeparturesForStopLocation()
            }
        }
    }
    @Published var isFavorite: Bool = false
    @Published var departures: [Departure] = []

    private func getDeparturesForStopLocation() {

    }
}
