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

    /// Compass bearings in human readable text. I.e. "North East", "South", and more.
    var bearing: String {
        get {
            if (_compassBearing > 23 && _compassBearing <= 67) {
                return NSLocalizedString("North East", comment: "Direction: North East")
            } else if (_compassBearing > 68 && _compassBearing <= 112) {
                return NSLocalizedString("East", comment: "Direction: East")
            } else if (_compassBearing > 113 && _compassBearing <= 167) {
                return NSLocalizedString("South East", comment: "Direction: South East")
            } else if (_compassBearing > 168 && _compassBearing <= 202) {
                return NSLocalizedString("South", comment: "Direction: South")
            } else if (_compassBearing > 203 && _compassBearing <= 247) {
                return NSLocalizedString("South West", comment: "Direction: South West")
            } else if (_compassBearing > 248 && _compassBearing <= 293) {
                return NSLocalizedString("West", comment: "Direction: West")
            } else if (_compassBearing > 294 && _compassBearing <= 337) {
                return NSLocalizedString("North West", comment: "Direction: North West")
            } else { // (_compassBearing >= 338 || _compassBearing <= 22)
                return NSLocalizedString("North", comment: "Direction: North")
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
