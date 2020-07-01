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

class SearchStore: ObservableObject {
    @Published var searchString: String = "" {
        didSet {
            if searchString.count >= 2 {
                performSearch()
            }
        }
    }
    @Published var showCancelButton: Bool = false
    @Published var searchResults: [Stop] = []

    private var workingItem: DispatchWorkItem?

    func isSearchActive() -> Bool {
        return showCancelButton || searchString.count > 0
    }

    private func performSearch() {
        if let item = workingItem {
            item.cancel()
            workingItem = nil
        }

        workingItem = DispatchWorkItem { EnTurAPI.geocoder.getAutocompleteBusStop(searchQuery: self.searchString) { [weak self] res in
            switch res {
            case .success(let value):
                DispatchQueue.main.async {
                    self?.searchResults = value.stops
                }
            case .failure(_):
                break
            }
        }}

        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.120, execute: workingItem!)
    }
}
