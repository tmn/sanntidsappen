//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2022 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct DepartureDetail: View {
    @ObservedObject var viewModel: DepartureViewModel = DepartureViewModel()
    @State private var hasDepartures: Bool = true
    let stop: Stop

    var body: some View {
        switch viewModel.state {
        case .idle:
            Text("Loading ...")
                .task {
                    await viewModel.loadData(stop: stop)
                }
        case .loading:
            Text("Loading ...")
        case .error:
            VStack(alignment: .leading) {
                Text("No departures for current stop")
                    .font(.headline)
                Text("The current stop didn't return any departures at this time. Please try again later, or try another stop nearby.   ")
                    .font(.subheadline)
            }
        case .loaded:
            List {
                ForEach(viewModel.departures, id: \.self) { _departure in
                    Section {
                        ForEach(_departure.departures) { departure in
                            NavigationLink {
                                JourneyDetail(departure: departure)
                            } label: {
                                DepartureRow(departure: departure)
                            }
                        }
                    } header: {
                        VStack(alignment: .leading) {
                            if let compassBearing = viewModel.quays?[_departure.quayId]?[0].compassBearing {
                                Text("\(CompassDirection(bearing: String(format: "%.0f", compassBearing)).bearing)")
                                    .font(.footnote)
                            }

                            Text("Platform \(_departure.departures[0].quay.publicCode )")
                                .font(.headline)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(stop.name)
            .refreshable {
                await viewModel.loadData(stop: stop)
            }
        }

    }
}

struct DepartureDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        NavigationView {
            DepartureDetail(
                // departures: Dictionary(grouping: modelData.stopPlace.departures, by: { $0.quay.publicCode }),
//                departures: [:],
                stop: Stop(id: "", name: "", locality: "", county: "", coordinates: [0.0, 0.0])
            )
        }
        .environmentObject(modelData)
    }
}
