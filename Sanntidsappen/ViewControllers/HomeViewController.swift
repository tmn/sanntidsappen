//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {

    weak var coordinator: HomeCoordinator?

    @IBOutlet weak var departureStationButton: UIButton!
    @IBOutlet weak var destinationStationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func departureStationButton(_ sender: UIButton) {
        coordinator?.registerDepartureStation(targetButton: sender, departureStation: "Solsiden")
    }

    @IBAction func destinationStationButton(_ sender: UIButton) {
        coordinator?.registerDestinationStation(targetButton: sender, destinationStation: "IKEA")
    }

}
