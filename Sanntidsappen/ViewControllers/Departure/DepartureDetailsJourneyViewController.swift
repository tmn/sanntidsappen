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

    let departure: EstimatedCall

    var journey: [Journey.EstimatedCall] = []

    var tableView: UITableView!

    var currentActiveIndexPath: IndexPath?

    init(departure: EstimatedCall) {
        self.departure = departure

        super.init(nibName: nil, bundle: nil)
        self.title = departure.destinationDisplay.frontText
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

    func scrollTableView() {
        if let quayIndex = journey.firstIndex(where: { $0.quay.id == departure.quay.id }) {
            tableView.scrollToRow(at: IndexPath(item: quayIndex, section: 0), at: .top, animated: true)
        }
    }
}

extension DepartureDetailsJourneyViewController {
    func requestData() {
        EnTurAPI.journeyPlanner.getJourney(journeyId: departure.serviceJourney.id, date: departure.date) { res in
            switch (res) {
            case .success(let value):
                self.journey = value.data.serviceJourney.estimatedCalls

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.scrollTableView()
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

        cell.journeyLine.frame = CGRect(x: 84, y: 0, width: 3, height: 65)
        cell.journeyPoint.fillColor = UIColor.SALightGray.cgColor

        cell.titleLabel.text = journey[indexPath.item].quay.name
        cell.timeStampLabel.text = formatTimeStamp(timeInString: journey[indexPath.item].aimedDepartureTime)

        if indexPath.item == 0 {
            cell.journeyLine.frame = CGRect(x: 84, y: 65/2, width: 3, height: 65/2)
        } else if indexPath.item == journey.count - 1 {
            cell.journeyLine.frame = CGRect(x: 84, y: 0, width: 3, height: 65/2)
        }

        if journey[indexPath.item].quay.id == departure.quay.id {
            cell.journeyPoint.fillColor = UIColor.SAPink.cgColor
        }

        return cell
    }


}
