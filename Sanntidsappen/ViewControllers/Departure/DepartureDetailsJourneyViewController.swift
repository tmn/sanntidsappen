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

    let departure: Departure

    var journey: [Journey.Departure] = []

    var tableView: UITableView!

    var currentActiveIndexPath: IndexPath?

    init(departure: Departure) {
        self.departure = departure

        super.init(nibName: nil, bundle: nil)
        self.title = departure.destination
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        tableView = UITableView(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
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
        EnTurAPI.journeyPlanner.getJourney(journeyId: departure.journeyId, date: departure.date) { res in
            switch (res) {
            case .success(let value):
                self.journey = value.departures

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.scrollTableView()
                }

            case .failure(_):
                let alertController = UIAlertController(title: NSLocalizedString("Oh, no!", comment: "Something wrong happened on network request"), message: NSLocalizedString("An error has occured. Make sure your phone is connected to the Internet and try again.", comment: "Try again"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Try again", comment: "Try again"), style: .default) { _ in
                    self.requestData()
                })
                self.present(alertController, animated: true)
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

        cell.journeyLine.frame = CGRect(x: 84, y: 0, width: 3, height: tableView.rowHeight)
        cell.journeyPoint.fillColor = UIColor.SA.LightGray.cgColor

        if #available(iOS 13.0, *) {
            cell.journeyPointBorder.strokeColor = UIColor.systemBackground.cgColor
        } else {
            cell.journeyPointBorder.strokeColor = UIColor.white.cgColor
        }

        cell.titleLabel.text = journey[indexPath.item].quay.name
        cell.timeStampLabel.text = formatTimeStamp(timeInString: journey[indexPath.item].aimedDepartureTime)

        if indexPath.item == 0 {
            cell.journeyLine.frame = CGRect(x: 84, y: 65/2, width: 3, height: tableView.rowHeight/2)
        } else if indexPath.item == journey.count - 1 {
            cell.journeyLine.frame = CGRect(x: 84, y: 0, width: 3, height: tableView.rowHeight/2)
        }

        if journey[indexPath.item].quay.id == departure.quay.id {
            cell.journeyPoint.fillColor = UIColor.SA.Primary.cgColor
            cell.journeyPointBorder.strokeColor = UIColor.SA.Primary.cgColor
        }

        return cell
    }

}
