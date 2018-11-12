//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class AboutCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []

    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController(nibName: nil, bundle: nil)
        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }()

    var rootViewController: UIViewController {
        navigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("About", comment: "About sanntidsappen"), image: #imageLiteral(resourceName: "compass"), selectedImage: #imageLiteral(resourceName: "compass"))
        return navigationController
    }

    init() {
        let viewController = AboutViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

    func start() {

    }

}
