//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class HomeCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let viewController = HomeViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

}
