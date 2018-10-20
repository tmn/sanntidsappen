//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

class DepartureDetailsViewController: UIViewController {

    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    var refresher: UIRefreshControl!

    var departures: [EstimatedCalls] = []
    let stop: Stop

    init(title: String, stop: Stop) {
        self.stop = stop

        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        flowLayout = ColumnFlowLayout()

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.alwaysBounceVertical = true

        refresher = UIRefreshControl()
        refresher.tintColor = .SAPink
        refresher.addTarget(self, action: #selector(requestData), for: .valueChanged)

        collectionView.refreshControl = refresher

        view.addSubview(collectionView)

        collectionView.register(UINib(nibName: DepartureDetailsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DepartureDetailsCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self

        self.requestData()
    }

}

extension DepartureDetailsViewController {

    @objc func requestData() {
        print(self.stop)
        EnTurAPI.journeyPlanner.getStopPlace(for: self.stop) { res in

            DispatchQueue.main.async {
                switch res {
                case .success(let value):
                    self.departures = value.data.stopPlace.estimatedCalls
//                    let test = Dictionary(grouping: value.data.stopPlace.estimatedCalls, by:{ ($0 as EstimatedCalls).quay.id })
                    self.collectionView.reloadData()

                case .failure(let error):
                    print("ERROR: \(error)")
                }

                self.refresher.endRefreshing()
            }
        }
    }

}


// MARK: - Delegate

extension DepartureDetailsViewController: UICollectionViewDelegate {

}


// MARK: - Data Source

extension DepartureDetailsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return departures.count
    }

    func formatTimestamp(from date: Date) -> String {
        let returnDateFormatter = DateFormatter()
        returnDateFormatter.dateFormat = "HH:mm"

        return returnDateFormatter.string(from: date)
    }

    func formatExpectedTimeLabel(string expectedArrivalTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()

        let date = dateFormatter.date(from: expectedArrivalTime)!

        switch date.timeIntervalSince(Date())/60 {
        case ..<1:
            return "Nå"

        case ..<11:
            return "\(String(format: "%.0f", date.timeIntervalSince(Date())/60)) min"

        default:
            return formatTimestamp(from: date)
        }
    }

    func getAimedTimeLabel(aimedTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        let aimedTimeDate = dateFormatter.date(from: aimedTime)!

        return "Rutetid: \(formatTimestamp(from: aimedTimeDate))"
    }

    func getNewTimeLabel(aimedTime: String, expectedTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()

        let aimedTimeDate = dateFormatter.date(from: aimedTime)!
        let expectedTimeDate = dateFormatter.date(from: expectedTime)!

        if expectedTimeDate.timeIntervalSince(aimedTimeDate) > 0 {
            return "  (\(formatTimestamp(from: expectedTimeDate)))"
        }

        return ""
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepartureDetailsCollectionViewCell.identifier, for: indexPath) as! DepartureDetailsCollectionViewCell

        let departure = departures[indexPath.item]

        cell.lineLabel.text = departure.serviceJourney.journeyPattern.line.publicCode
        cell.destinationLabel.text = departure.destinationDisplay.frontText
        cell.aimedTimeLabel.text = getAimedTimeLabel(aimedTime: departure.aimedArrivalTime)
        cell.newTimeLabel.text = getNewTimeLabel(aimedTime: departure.aimedArrivalTime, expectedTime: departure.expectedArrivalTime)

        cell.expectedTimeLable.text = formatExpectedTimeLabel(string: departure.expectedArrivalTime)

        return cell
    }

}
