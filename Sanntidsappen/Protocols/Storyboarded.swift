//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2019 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
