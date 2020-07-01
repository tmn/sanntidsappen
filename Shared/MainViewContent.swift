//
//  MainViewContent.swift
//  iOS
//
//  Created by Tri Nguyen on 29/06/2020.
//

import SwiftUI
import CoreLocation

struct MainViewContent: View {
    @EnvironmentObject var searchStore: SearchStore
    @EnvironmentObject var currentActiveStop: CurrentActiveStop

    @ObservedObject var locationHandler: LocationHandler = LocationHandler()
    @ObservedObject var nearbyStops: NearbyStops = NearbyStops()

    init() {
        nearbyStops.locationHandler = locationHandler
    }

    var body: some View {
        List {
            Section(header: Text("Recent")) {
                ForEach(nearbyStops.stops) { stop in
                    SearchResultCell(store: searchStore, title: stop.name)
                }
            }

            Section(header: Text("Nearby")) {
                ForEach(nearbyStops.stops) { stop in
                    NavigationLink(destination: DepartureView(), tag: stop, selection: $currentActiveStop.stop) {
                        StopCell(stop: stop)
                    }.onDisappear {
                        locationHandler.stop()
                    }.onAppear {
                        locationHandler.stop()
                    }
                }.onReceive(locationHandler.objectWillChange) { _ in
                    print("Location changed: \(locationHandler.lastKnownLocation?.latitude)")
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Sanntidsappen")
    }
}

struct MainViewContent_Previews: PreviewProvider {
    static var previews: some View {
        MainViewContent()
            .environmentObject(SearchStore())
            .environmentObject(CurrentActiveStop())
    }
}
