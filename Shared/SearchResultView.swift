//
//  SearchResultView.swift
//  iOS
//
//  Created by Tri Nguyen on 29/06/2020.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var searchStore: SearchStore
    @EnvironmentObject var currentActiveStop: CurrentActiveStop

    var body: some View {
        List {
            ForEach(searchStore.searchResults) { stop in
                NavigationLink(destination: DepartureView(), tag: stop, selection: $currentActiveStop.stop) {
                    StopCell(stop: stop)
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
        searchStore.searchResults = stopTestData

        let currentActiveStop: CurrentActiveStop = CurrentActiveStop()
        currentActiveStop.stop = stopTestData[0]

        return SearchResultView()
            .environmentObject(searchStore)
            .environmentObject(currentActiveStop)
    }
}
