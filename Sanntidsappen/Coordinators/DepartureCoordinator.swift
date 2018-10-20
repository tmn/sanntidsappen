//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class DepartureCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []

    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController(nibName: nil, bundle: nil)
        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }()

    var rootViewController: UIViewController {
        navigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("Departures", comment: "Find roudepartureste"), image: #imageLiteral(resourceName: "clock"), selectedImage: #imageLiteral(resourceName: "clock"))
        return navigationController
    }

    init() {
        let viewController = DepartureViewController()
        viewController.delegate = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func start() {

    }

    func showDetailedView(stop: Stop) {
        let viewController = DepartureDetailsViewController(title: stop.properties.name, stop: stop)

        navigationController.pushViewController(viewController, animated: true)
    }

}

extension DepartureCoordinator: DepartureViewControllerDelegate {

    func departureViewController(_ viewController: DepartureViewController, continueWith stop: Stop) {
        self.showDetailedView(stop: stop)
    }

}
