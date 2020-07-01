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
    @EnvironmentObject var currentActiveStop: CurrentActiveStop

    var body: some View {
        List {
            Section {
                ForEach(currentActiveStop.departures) { departure in
                    DepartureCell(departure: departure)
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct DepartureView_Previews: PreviewProvider {
    static var previews: some View {
        let currentActiveStop: CurrentActiveStop = CurrentActiveStop()
        currentActiveStop.stop = stopTestData[0]

        return NavigationView {
            DepartureView()
        }
        .environmentObject(currentActiveStop)
    }
}
