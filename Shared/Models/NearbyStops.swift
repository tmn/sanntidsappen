//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation
import Combine

class NearbyStops: ObservableObject {
    @Published var stops: [Stop] = []

    var locationHandler: LocationHandler? = nil {
        didSet {
            print("DID SET")
            fetchNearbyStops()
        }
    }
    
    private var workingItem: DispatchWorkItem?

    func fetchNearbyStops() {
        guard let location = locationHandler?.lastKnownLocation else {
            return
        }

        if let item = workingItem {
            item.cancel()
            workingItem = nil
        }

        workingItem = DispatchWorkItem { EnTurAPI.geocoder.getNearbyStops(latitude: location.latitude, longitude: location.longitude) { [weak self] res in

            switch res {
            case .success(let value):
                DispatchQueue.main.async {
                    self?.stops = value.stops
                }
            case .failure(_):
                break
            }

        }}

        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.120, execute: workingItem!)
    }
}
