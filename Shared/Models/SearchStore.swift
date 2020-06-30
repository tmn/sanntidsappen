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
    @Published var searchString: String = ""
    @Published var showCancelButton: Bool = false
    @Published var searchResults: [Stop] = []

    private var workingItem: DispatchWorkItem?

    func isSearchActive() -> Bool {
        return showCancelButton || searchString.count > 0
    }

    func performSearch() {
        print("PERFORM SAERCH")
        if let item = workingItem {
            item.cancel()
            workingItem = nil
        }

        workingItem = DispatchWorkItem { [self] in EnTurAPI.geocoder.getAutocompleteBusStop(searchQuery: searchString) { [weak self] res in
            switch res {
            case .success(let value):
                print("SEARCHING", value)
                self?.searchResults = value.features
            case .failure(let error):
                print("ERROR: \(error)")
            }

            }}

        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.120, execute: workingItem!)
    }
}
