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
    let departure: Journey.Departure?

    var body: some View {
        HStack {
            Text(Timestamp.format(from: departure?.aimedDepartureTime ?? ""))
                .foregroundColor(.accentColor)

            Circle()
                .strokeBorder(.white, lineWidth: 2)
                .background(Circle().fill(Color.accentColor))
                .frame(width: 15, height: 15)

            Text(departure?.quay.name ?? "")
            Spacer()
        }
    }
}

struct JourneyDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        JourneyDetailRow(departure: nil)
    }
}
