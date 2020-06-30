//
//  MainViewContent.swift
//  iOS
//
//  Created by Tri Nguyen on 29/06/2020.
//

import SwiftUI

struct MainViewContent: View {
    @Binding var stops: [Location]
    @EnvironmentObject var searchStore: SearchStore

    var body: some View {
        List {
            Section(header: Text("Recent")) {
                ForEach(stops) { stop in
                    SearchResultCell(search: searchStore, title: stop.title)
                }
            }

            Section(header: Text("Nearby")) {
                ForEach(stops) { stop in
                    NavigationLink(destination: DepartureView(stop: stop)) {
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
        MainViewContent(stops: .constant(stopsTestData))
    }
}
