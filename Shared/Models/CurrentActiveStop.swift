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
    @Published var stop: Location? = nil
    @Published var isFavorite: Bool = false
}
