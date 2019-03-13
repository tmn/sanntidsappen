//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class TripCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let viewController = TripViewController()
        viewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Travel", comment: "Find route"), image: #imageLiteral(resourceName: "compass"), selectedImage: #imageLiteral(resourceName: "compass"))

        navigationController.pushViewController(viewController, animated: true)
    }

}
