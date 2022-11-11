//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2022 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation
import UIKit

class Timestamp {
    static func format(from timestampString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        return format(from: dateFormatter.date(from: timestampString)!)
    }

    static func format(from date: Date) -> String {
        let returnDateFormatter = DateFormatter()
        returnDateFormatter.dateFormat = "HH:mm"

        return returnDateFormatter.string(from: date)
    }


    static func formatExpectedTimeLabel(expectedArrivalTime: String, isRealtime: Bool? = false) -> String {
        let dateFormatter = ISO8601DateFormatter()

        let date = dateFormatter.date(from: expectedArrivalTime)!

        switch date.timeIntervalSince(Date())/60 {
        case ..<1:
            return "Nå"

        case ..<11:
            if let isRealtime = isRealtime, isRealtime == true {
                return "\(String(format: "%.0f", date.timeIntervalSince(Date())/60)) min"
            } else {
                return "ca \(String(format: "%.0f", date.timeIntervalSince(Date())/60)) min"
            }

        default:
            return Timestamp.format(from: date)
        }
    }

    static func getAimedTimeLabel(aimedTime: String, expectedTime: String) -> NSAttributedString {
        let timestamp = NSMutableAttributedString(string: Timestamp.format(from: aimedTime))

        if isDelayed(aimedTime: aimedTime, expectedTime: expectedTime) {
            timestamp.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, timestamp.length))
        }

        return timestamp
    }

    static func getNewTimeLabel(aimedTime: String, expectedTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()

        if isDelayed(aimedTime: aimedTime, expectedTime: expectedTime) {
            return "\(Timestamp.format(from: dateFormatter.date(from: expectedTime)!))"
        }

        return ""
    }

    static func isDelayed(aimedTime: String, expectedTime: String) -> Bool {
        let dateFormatter = ISO8601DateFormatter()

        let aimedTimeDate = dateFormatter.date(from: aimedTime)!
        let expectedTimeDate = dateFormatter.date(from: expectedTime)!

        return expectedTimeDate.timeIntervalSince(aimedTimeDate) > 60;
    }
}
