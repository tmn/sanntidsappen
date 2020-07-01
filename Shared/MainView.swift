//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct MainView: View {
    @StateObject var currentActiveStop = CurrentActiveStop()
    @StateObject var searchStore = SearchStore()

    @State var stops: [Stop] = [stopTestData[0]]

    var body: some View {
        NavigationView {

            VStack {
                NavigationSearchBar(search: searchStore)

                if searchStore.isSearchActive() {
                    SearchResultView()
                } else {
                    MainViewContent(stops: $stops)
                }
            }
        }
        .environmentObject(searchStore)
        .environmentObject(currentActiveStop)
        .accentColor(Color.Sanntidsappen.Primary)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(stops: stopTestData)
    }
}

