//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct DepartureView: View {
    var stop: Location

    @State var departures: [Departure] = []

    var body: some View {
        List {
            Section {
                ForEach(self.departures) { departure in
                    DepartureCell(departure: departure)
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct DepartureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepartureView(stop: stopsTestData[0], departures: departureTestData)
        }
    }
}
