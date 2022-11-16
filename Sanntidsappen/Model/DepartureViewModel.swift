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

struct DepartureListItem: Hashable {
    let quayId: String
    let departures: [Departure]

    func hash(into hasher: inout Hasher) {
        hasher.combine(quayId)
    }

    static func == (lhs: DepartureListItem, rhs: DepartureListItem) -> Bool {
        return lhs.quayId == rhs.quayId
    }
}

class DepartureViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded
        case error
    }

    @Published private(set) var state = State.idle
    @Published private(set) var departures = [DepartureListItem]() // Dictionary<String, [Departure]>()
    @Published private(set) var quays: [String: [StopRegister.Quay]]?

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

            let departures: [DepartureListItem] = Dictionary(grouping: stopPlace.departures, by: { $0.quay.id })
                .map { (key: String, value: [Departure]) in DepartureListItem(quayId: key, departures: value) }
                .sorted(by: { $0.departures[0].quay.publicCode < $1.departures[0].quay.publicCode })

            if departures.count == 0 {
                state = .error
                return
            }

            let quayInfo = try? await EnTurAPI.stopRegister.getQuayInformation(for: stop)

            if let quayInfo {
                quays = Dictionary(grouping: quayInfo.stopPlaces[0].quays, by: { $0.id })
            }

            self.state = .loaded
            self.departures = departures
        }
    }
}
