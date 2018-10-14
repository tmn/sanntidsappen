//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class MainCoordinator: Coordinator {

    let window: UIWindow

    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    lazy var tabBarController: UITabBarController = {
        let controller = UITabBarController()
        return controller
    }()

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        setupChildCoordinators()

        tabBarController.viewControllers = childCoordinators.map { $0.rootViewController! }

        window.rootViewController = self.tabBarController
        window.makeKeyAndVisible()
    }

    func setupChildCoordinators() {
        let departureCoordinator = DepartureCoordinator()
        let homeCoordinator = HomeCoordinator()
        let tripCoordinator = TripCoordinator()

        childCoordinators = [
            homeCoordinator,
            departureCoordinator,
            tripCoordinator
        ]
    }

}
