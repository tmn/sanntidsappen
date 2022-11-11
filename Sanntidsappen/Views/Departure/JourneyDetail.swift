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
    let departure: Departure

    @State private var journey: Journey?

    func fetchJourney() async {
        guard let journey = try? await EnTurAPI.journeyPlanner.getJourney(journeyId: departure.journeyId, date: departure.date) else {
            print("Could not get journeys")
            return
        }

        self.journey = journey
    }

    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(journey?.departures ?? [], id: \.quay.id) { departure in
                    JourneyDetailRow(
                        departure: departure,
                        quayId: self.departure.quay.id
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(
                        .init(top: 0, leading: 20, bottom: 0, trailing: 0)
                    )

                }
            }
            .onChange(of: journey) { _ in
                if self.departure.quay.id == departure.quay.id {
                    withAnimation {
                        proxy.scrollTo(departure.quay.id, anchor: .top)
                    }
                }
            }
            .task {
                await fetchJourney()
            }
            .listStyle(.inset)
            .navigationTitle(Text(departure.destination))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


struct JourneyDetail_Previews: PreviewProvider {
    static var previews: some View {
        JourneyDetail(departure: Departure(
            realtime: true,
            aimedArrivalTime: "2022-11-07T23:27:00+01:00",
            expectedArrivalTime: "2022-11-07T23:28:17+01:00",
            date: "2022-11-07",
            forBoarding: true,
            destination: "Ringen via Majorstuen",
            quay: Quay(
                id: "NSR:Quay:7334",
                name: "Nationaltheatret",
                publicCode: "2",
                description: "Retning vest"
            ),
            journeyId: "RUT:ServiceJourney:5-169523-23866420",
            lineId: "RUT:Line:5",
            lineCode: "5",
            lineName: "Sognsvann - Vestli",
            transportMode: "metro"
        ))
    }
}
