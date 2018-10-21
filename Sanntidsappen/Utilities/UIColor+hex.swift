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

    static var SADarkBlue: UIColor {
        return UIColor(hex: 0x303C4C)
    }

    static var SAGreen: UIColor {
        return UIColor(hex: 0x53C22B)
    }

    static var SAPink: UIColor {
        return UIColor(hex: 0xFF2E55)
    }

    static var SALightGray: UIColor {
        return UIColor(hex: 0xf4f4f4)
    }

}

private extension UIColor {

    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0

        self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }

}
