//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct SearchResultCell: View {
    @ObservedObject var store: SearchStore

    var title: String

    var body: some View {
        Button(action: {
            store.searchString = title
        }) {
            Text(title)
                .foregroundColor(Color.Sanntidsappen.Primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
