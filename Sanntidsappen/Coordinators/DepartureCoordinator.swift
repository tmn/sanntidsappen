//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit
import SwiftUI

class DepartureCoordinator: Coordinator {

    private var modelData = ModelData()

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let viewController = DepartureCollectionViewController.instantiate()
        viewController.coordinator = self
        viewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Departures", comment: "Find roudepartureste"), image: #imageLiteral(resourceName: "clock"), selectedImage: #imageLiteral(resourceName: "clock"))
        viewController.title = NSLocalizedString("Search", comment: "Find departures")

        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetailedView(withViewController viewController: DepartureDetailsViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetailedView(forStop stop: Stop) {
        let viewController = createDetailedView(forStop: stop)

        navigationController.pushViewController(viewController, animated: true)
    }

    func showDepartureRoute(departure: Departure) {
        let viewController = UIHostingController(rootView: JourneyDetail(departure: departure))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    private func createDetailedView(forStop stop: Stop) -> UIHostingController<DepartureDetail> {
        let viewController = UIHostingController(rootView: DepartureDetail(stop: stop))
        return viewController
    }

}


// MARK: - DELEGATES

extension DepartureCoordinator: DepartureCollectionViewControllerDelegate {
    
    func moveToDetailsViewController(from viewController: DepartureCollectionViewController, withStop stop: Stop) {
        self.showDetailedView(forStop: stop)
    }
    
    func moveToDetailsViewController(from viewController: DepartureCollectionViewController, withDetailsView nextView: DepartureDetailsViewController) {
        self.showDetailedView(withViewController: nextView)
    }
    
    func getDetailsViewController(forStop stop: Stop) -> UIHostingController<DepartureDetail> {
        return self.createDetailedView(forStop: stop)
    }
    
}

extension DepartureCoordinator: DepartureDetailsViewControllerDelegate {

    func selectJourney(_ viewController: DepartureDetailsViewController, using departure: Departure) {
        self.showDepartureRoute(departure: departure)
    }

}
