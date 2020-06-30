//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct StopCell: View {
    var stop: Location
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(stop.title)
                .foregroundColor(Color.Sanntidsappen.Primary)

            Text(stop.location)
                .font(.subheadline)
                .foregroundColor(Color.gray)
        }
        .frame(minWidth: 0, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, alignment: .leading)
    }
}

struct StopCell_Previews: PreviewProvider {
    static var previews: some View {
        StopCell(
            stop: stopsTestData[0]
        )
    }
}
