//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2022 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

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
}
