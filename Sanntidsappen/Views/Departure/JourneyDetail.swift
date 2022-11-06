//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2022 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct JourneyDetail: View {
    weak var navigationController: UINavigationController?
    let departure: Departure
    @State private var journey: Journey?

    var body: some View {
        List {
            ForEach(journey?.departures ?? [], id: \.quay.id) {departure in
                JourneyDetailRow(departure: departure)
            }
        }.task {
            do {
                journey = try await EnTurAPI.journeyPlanner.getJourney(journeyId: departure.journeyId, date: departure.date)
            } catch {
                print ("Error: \(error)")
            }
            print(journey)
        }
    }
}


struct JourneyDetail_Previews: PreviewProvider {
    static var previews: some View {
        JourneyDetail(departure: Departure(realtime: true, aimedArrivalTime: "", expectedArrivalTime: "", date: "", forBoarding: true, destination: "", quay: Quay(id: "", name: "", publicCode: "", description: ""), journeyId: "", lineId: "", lineCode: "", lineName: "", transportMode: ""))
    }
}
