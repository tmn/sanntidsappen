//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2022 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct JourneyDetailRow: View {
    @Environment(\.colorScheme) var colorScheme

    let departure: Journey.Departure?
    let quayId: String

    var body: some View {
        HStack {
            Text(Timestamp.format(from: departure?.aimedDepartureTime ?? ""))
                .font(.subheadline)
                .foregroundColor(.accentColor)
                .frame(width: 50)

            ZStack {
                Rectangle()
                    .fill(Color.SA.LightGray)
                    .frame(width: 3, height: 55)
                if quayId == departure?.quay.id {
                    Circle()
                        .fill(Color.SA.Primary)
                        .frame(width: 15, height: 15)
                } else {
                    Circle()
                        .strokeBorder(Color.SA.BorderColor, lineWidth: 4)
                        .background(Circle().fill(Color.SA.LightGray))
                        .frame(width: 15, height: 15)
                }
            }

            Text(departure?.quay.name ?? "")

            Spacer()
        }
    }
}

struct JourneyDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        JourneyDetailRow(departure: Journey.Departure(
            aimedDepartureTime: "2022-11-07T21:39:00+0100",
            expectedDepartureTime: "2022-11-07T21:39:04+0100",
            quay: Journey.Quay(id: "NSR:Quay:1038", name: "Kongsvinger stasjon")), quayId: "NSR:Quay:1038")
    }
}
