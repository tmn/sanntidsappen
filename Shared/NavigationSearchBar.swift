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
    @ObservedObject var search: SearchStore

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search", text: $search.searchString, onEditingChanged: { _ in
                    search.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                })

                Button(action: {
                    search.searchString = ""
                    search.searchResults = []
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(search.searchString == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            .foregroundColor(.secondary)

            if search.isSearchActive() {
                Button("Cancel") {
                    self.hideKeyboard()

                    search.searchString = ""
                    search.searchResults = []
                    search.showCancelButton = false
                }
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(search.isSearchActive())
    }
}
