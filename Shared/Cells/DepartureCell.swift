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
            Text(departure.lineCode)
                .foregroundColor(Color.Sanntidsappen.Primary)
                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

            VStack (alignment: .leading) {
                Text("\(departure.destination)")
                    .font(.subheadline)
                HStack {
                    Text("Aimed time: \(departure.aimedTime, formatter: Departure.departureDateFormatter)")
                        .foregroundColor(Color.gray)

                    if departure.expectedTime.timeIntervalSince(departure.aimedTime) > 60 {
                        Text("(\(departure.expectedTime, formatter: Departure.departureDateFormatter))")
                            .foregroundColor(Color.Sanntidsappen.Primary)
                    }
                }
                .font(.footnote)
            }

            Spacer()

            switch departure.expectedTime.timeIntervalSince(Date())/60 {
            case ..<1:
                Text("Now")
                    .font(.subheadline)
            case ..<11:
                if departure.realtime {
                    Text("\(String(format: "%.0f", departure.expectedTime.timeIntervalSince(Date())/60)) min")
                        .font(.subheadline)
                } else {
                    Text("ca \(String(format: "%.0f", departure.expectedTime.timeIntervalSince(Date())/60)) min")
                        .font(.subheadline)
                }
            default:
                Text("\(departure.expectedTime, formatter: Departure.departureDateFormatter)")
                    .font(.subheadline)
                    .layoutPriority(1)
                    .padding(.leading, 10)
            }
        }
    }
}

struct DepartureCell_Previews: PreviewProvider {
    static var previews: some View {
        DepartureCell(departure: departureTestData[0])
    }
}
