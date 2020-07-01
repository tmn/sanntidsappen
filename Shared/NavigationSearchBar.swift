//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct NavigationSearchBar: View {
    @ObservedObject var searchStore: SearchStore

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search", text: $searchStore.searchString, onEditingChanged: { _ in
                    searchStore.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                })

                Button(action: {
                    searchStore.searchString = ""
                    searchStore.searchResults = []
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(searchStore.searchString == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            .foregroundColor(.secondary)

            if searchStore.isSearchActive() {
                Button("Cancel") {
                    self.hideKeyboard()

                    searchStore.searchString = ""
                    searchStore.searchResults = []
                    searchStore.showCancelButton = false
                }
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(searchStore.isSearchActive())
    }
}
