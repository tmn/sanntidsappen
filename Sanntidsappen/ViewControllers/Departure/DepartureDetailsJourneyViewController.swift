//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class DepartureDetailsJourneyViewController: UIViewController {

    let journeyId: String
    let journeyDate: String

    init(title: String, journeyId: String, journeyDate: String) {
        self.journeyId = journeyId
        self.journeyDate = journeyDate

        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        requestData()
    }

}

extension DepartureDetailsJourneyViewController {

    func requestData() {
//        EnTurAPI.journeyPlanner.getJourney(journeyId: journeyId, date: journeyDate) { res in
//            switch (res) {
//            case .success(let value):
//            case .failure(let error):
//            }
//        }
    }

}
