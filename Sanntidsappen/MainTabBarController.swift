//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2019 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class MainTabBarController: UITabBarController {

    let aboutCoordinator = AboutCoordinator(navigationController: UINavigationController())
    let departureCoordinator = DepartureCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()

        // Starts the coordinators
        aboutCoordinator.start()
        departureCoordinator.start()

        viewControllers = [departureCoordinator.navigationController, aboutCoordinator.navigationController]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
