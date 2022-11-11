//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2022 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation
import Combine

class DepartureViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded
        case error
    }

    @Published private(set) var state = State.idle
    @Published private(set) var departures = Dictionary<String, [Departure]>()

    private var loadTask: Task<Void, Never>?

    @MainActor
    func loadData(stop: Stop) async {
        if state != .loaded {
            state = .loading
        }

        loadTask?.cancel()

        loadTask = Task {
            guard let stopPlace = try? await EnTurAPI.journeyPlanner.getStopPlace(for: stop) else {
                state = .error
                return
            }

            let departures = Dictionary(grouping: stopPlace.departures, by: { $0.quay.publicCode })

            if departures.count == 0 {
                state = .error
                return
            }

            self.state = .loaded
            self.departures = departures
        }
    }
}
