//
//  SearchResultView.swift
//  iOS
//
//  Created by Tri Nguyen on 29/06/2020.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var searchStore: SearchStore

    var body: some View {
        List {
            ForEach(searchStore.searchResults) { stop in
                NavigationLink(destination: DepartureView(stop: Location(title: stop.properties.name, locality: stop.properties.locality, county: stop.properties.county))) {
                    StopCell(stop: Location(title: stop.properties.name, locality: stop.properties.locality, county: stop.properties.county))
                }
            }
            HStack {
                Spacer()
                Text("\(searchStore.searchResults.count) found")
                    .font(.subheadline)
                Spacer()
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        let searchStore: SearchStore = SearchStore()

        searchStore.searchResults = [
            Stop(geometry: Geometry(coordinates: [0.0]), properties: Properties(id: "2", name: "Solsiden", locality: "Trøndelag", county: "a")),
            Stop(geometry: Geometry(coordinates: [0.0]), properties: Properties(id: "2", name: "Solsiden", locality: "Trøndelag", county: "a"))
        ]

        return SearchResultView()
            .environmentObject(searchStore)
    }
}
