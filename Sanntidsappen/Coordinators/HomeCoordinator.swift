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

    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController(nibName: nil, bundle: nil)
        return navigationController
    }()

    var rootViewController: UIViewController {
        navigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: "Home dashboard"), image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"))
        return navigationController
    }

    init() {
        let viewController = HomeViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

    func start() {

    }

}
