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

    private var departureStation: String?
    private var destinationStation: String?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let viewController = HomeViewController.instantiate()
        viewController.coordinator = self

        viewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: "Main screen of Sanntidsappen"), image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"))

        navigationController.pushViewController(viewController, animated: true)
    }

    func showSearchForStation() {
        let viewController = StationSearchViewController.instantiate()

        navigationController.pushViewController(viewController, animated: true)
    }

    func registerDepartureStation(targetButton: UIButton, departureStation: String) {
        self.departureStation = departureStation

        targetButton.setTitle(departureStation, for: .normal)

        targetButton.sizeToFit()
        targetButton.layoutIfNeeded()

    }

    func registerDestinationStation(targetButton: UIButton, destinationStation: String) {
        self.destinationStation = destinationStation

        targetButton.setTitle(destinationStation, for: .normal)

        targetButton.sizeToFit()
        targetButton.layoutIfNeeded()
    }

}
