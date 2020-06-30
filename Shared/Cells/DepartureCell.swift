//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2020 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct DepartureCell: View {
    var departure: Departure

    var body: some View {
        HStack {
            Text(departure.line)
                .foregroundColor(Color.Sanntidsappen.Primary)
                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

            VStack (alignment: .leading) {
                Text("\(departure.title)")
                Text("Aimed time: 20:20 (20:24)")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
            .layoutPriority(1)

            Spacer()

            Text("6 min")
        }
    }
}

struct DepartureCell_Previews: PreviewProvider {
    static var previews: some View {
        DepartureCell(departure: Departure(line: "5", title: "Test"))
    }
}
