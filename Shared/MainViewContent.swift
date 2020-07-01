//
//  MainViewContent.swift
//  iOS
//
//  Created by Tri Nguyen on 29/06/2020.
//

import SwiftUI

struct MainViewContent: View {
    @Binding var stops: [Stop]
    @EnvironmentObject var searchStore: SearchStore
    @EnvironmentObject var currentActiveStop: CurrentActiveStop

    var body: some View {
        List {
            Section(header: Text("Recent")) {
                ForEach(stops) { stop in
                    SearchResultCell(search: searchStore, title: stop.name)
                }
            }

            Section(header: Text("Nearby")) {
                ForEach(stops) { stop in
                    NavigationLink(destination: DepartureView(), tag: stop, selection: $currentActiveStop.stop) {
                        StopCell(stop: stop)
                    }
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
