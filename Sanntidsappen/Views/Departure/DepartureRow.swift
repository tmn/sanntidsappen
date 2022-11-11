//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2022 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct DepartureRow: View {
    let departure: Departure

    var body: some View {
        HStack {
            Text(departure.lineCode)
                .foregroundColor(.accentColor)
                .font(.system(size: 19))
                .frame(width: 50)

            VStack (alignment: .leading) {
                Text(departure.destination)
                    .font(.system(size: 17, weight: .medium))
                HStack(spacing: 6) {
                    Text("Aimed time:")
                    Text(Timestamp.getAimedTimeLabel(aimedTime: departure.aimedArrivalTime, expectedTime: departure.expectedArrivalTime).string)
                        .strikethrough(Timestamp.isDelayed(aimedTime: departure.aimedArrivalTime, expectedTime: departure.expectedArrivalTime))

                    if Timestamp.isDelayed(aimedTime: departure.aimedArrivalTime, expectedTime: departure.expectedArrivalTime) {
                        Text("(\(Timestamp.getNewTimeLabel(aimedTime: departure.aimedArrivalTime, expectedTime: departure.expectedArrivalTime)))")
                            .foregroundColor(.accentColor)
                    }
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }

            Spacer()
            Text(Timestamp.formatExpectedTimeLabel(expectedArrivalTime: departure.expectedArrivalTime, isRealtime: departure.realtime))
                .frame(width: 50, alignment: .trailing)
                .font(.subheadline)
        }
        .padding(.top, 1)
        .padding(.bottom, 1)
    }
}

struct DepartureRow_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        DepartureRow(departure: modelData.stopPlace.departures[0])
            .environmentObject(modelData)
    }
}
