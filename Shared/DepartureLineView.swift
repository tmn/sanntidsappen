//
//  DepartureLineView.swift
//  sanntidsappen
//
//  Created by Tri Nguyen on 23/06/2020.
//

import SwiftUI

struct DepartureListItemView: View {
    var departure: Departure

    var body: some View {
        HStack {
            Text(departure.line)
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

struct DepartureLineView_Previews: PreviewProvider {
    static var previews: some View {
        DepartureListItemView(departure: Departure(line: "5", title: "Test"))
    }
}
