//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Combine
import Foundation

class CurrentActiveStop: ObservableObject {
    @Published var departures: [Departure] = []
    @Published var isFavorite: Bool = false
    @Published var stop: Stop? = nil {
        didSet {
            if stop != nil {
                fetchDeparturesForStop()
            }
        }
    }

    private var workingItem: DispatchWorkItem?

    private func fetchDeparturesForStop() {
        if let item = workingItem {
            item.cancel()
            workingItem = nil
        }

        workingItem = DispatchWorkItem { EnTurAPI.journeyPlanner.getStopPlace(for: self.stop!) { [weak self] res in
            switch res {
            case .success(let value):
                DispatchQueue.main.async {
                    self?.departures = value.departures
                }
            case .failure(_):
                break
            }
        }}

        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.120, execute: workingItem!)
    }
}
