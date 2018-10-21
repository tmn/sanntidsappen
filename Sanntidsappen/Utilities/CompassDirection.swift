//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct CompassDirection {
    private var _compassBearing: Double = 0

    var bearing: String {
        get {
            if (_compassBearing > 23 && _compassBearing <= 67) {
                return "North East"
            } else if (_compassBearing > 68 && _compassBearing <= 112) {
                return "East"
            } else if (_compassBearing > 113 && _compassBearing <= 167) {
                return "South East"
            } else if (_compassBearing > 168 && _compassBearing <= 202) {
                return "South"
            } else if (_compassBearing > 203 && _compassBearing <= 247) {
                return "South West"
            } else if (_compassBearing > 248 && _compassBearing <= 293) {
                return "West"
            } else if (_compassBearing > 294 && _compassBearing <= 337) {
                return "North West"
            } else { // (_compassBearing >= 338 || _compassBearing <= 22)
                return "North"
            }
        }
        set {
            _compassBearing = Double(newValue) ?? 0
        }
    }

    init (bearing: String) {
        self.bearing = bearing
    }


}

