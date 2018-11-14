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

    var journey: [Journey.EstimatedCall] = []

    var tableView: UITableView!

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


        tableView = UITableView(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.rowHeight = 65.0
        tableView.register(JourneyDetailsTableViewCell.self, forCellReuseIdentifier: JourneyDetailsTableViewCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)

        requestData()
    }

    func formatTimeStamp(timeInString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()

        let returnDateFormatter = DateFormatter()
        returnDateFormatter.dateFormat = "HH:mm"

        return returnDateFormatter.string(from: dateFormatter.date(from: timeInString)!)
    }
}

extension DepartureDetailsJourneyViewController {

    func requestData() {
        EnTurAPI.journeyPlanner.getJourney(journeyId: journeyId, date: journeyDate) { res in
            switch (res) {
            case .success(let value):
                self.journey = value.data.serviceJourney.estimatedCalls

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print(error)
            }
        }
    }

}

extension DepartureDetailsJourneyViewController: UITableViewDelegate {

}

extension DepartureDetailsJourneyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journey.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JourneyDetailsTableViewCell.identifier, for: indexPath) as! JourneyDetailsTableViewCell

        cell.selectionStyle = .none

        cell.titleLabel.text = journey[indexPath.item].quay.name
        cell.timeStampLabel.text = formatTimeStamp(timeInString: journey[indexPath.item].aimedDepartureTime)

        return cell
    }


}
