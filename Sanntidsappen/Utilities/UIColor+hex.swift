//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

extension UIColor {

    struct SA {
        static let DarkBlue = UIColor(named: "SA Dark Blue")!
        static let Primary = UIColor(named: "SA Primary")!
        static let LightGray = UIColor(named: "SA Light Gray")!
    }

}

private extension UIColor {

    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0

        self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }

}
