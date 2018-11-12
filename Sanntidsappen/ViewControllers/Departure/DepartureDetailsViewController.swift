//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit

protocol DepartureDetailsViewControllerDelegate: class {
    func selectJourney(_ viewController: DepartureDetailsViewController, with id: String, and date: String, using title: String)
}

class DepartureDetailsViewController: UIViewController {

    weak var delegate: DepartureDetailsViewControllerDelegate?

    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    var refresher: UIRefreshControl!

    var segmentedDepartures: [String: [EstimatedCall]] = [:]
    var sortedSections: [String] = []
    var expandedSection: Int = -1

    var quays: [String: [StopRegisterQuay]]?

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
        collectionView.backgroundColor = .SALightGray
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.alwaysBounceVertical = true

        flowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 60)

        refresher = UIRefreshControl()
        refresher.tintColor = .SAPink
        refresher.addTarget(self, action: #selector(requestData), for: .valueChanged)

        collectionView.refreshControl = refresher

        view.addSubview(collectionView)

        collectionView.register(UINib(nibName: DepartureDetailsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DepartureDetailsCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: DepartureDetailsCollectionViewHeaderCell.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DepartureDetailsCollectionViewHeaderCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self

        self.requestData()
    }

}

extension DepartureDetailsViewController {

    @objc func requestData() {
        EnTurAPI.journeyPlanner.getStopPlace(for: self.stop) { res in

            DispatchQueue.main.async {
                switch res {
                case .success(let value):
                    self.segmentedDepartures = Dictionary(grouping: value.data.stopPlace.estimatedCalls, by:{ ($0 as EstimatedCall).quay.id })
                    self.sortedSections = self.segmentedDepartures.keys.map { $0 }.sorted(by: { $0.split(separator: ":").last! < $1.split(separator: ":").last! })

                    self.collectionView.reloadData()

                case .failure(let error):
                    print("ERROR: \(error)")
                }

                self.refresher.endRefreshing()
            }
        }

        EnTurAPI.stopRegister.getQuayInformation(for: self.stop) { res in

            switch res {
            case .success(let value):
                if let data = value.data {
                    self.quays = Dictionary(grouping: data.stopPlace[0].quays, by: { $0.id })

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }

            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }

}

extension DepartureDetailsViewController {

    func formatTimestamp(from date: Date) -> String {
        let returnDateFormatter = DateFormatter()
        returnDateFormatter.dateFormat = "HH:mm"

        return returnDateFormatter.string(from: date)
    }

    func formatExpectedTimeLabel(string expectedArrivalTime: String, isRealtime: Bool? = false) -> String {
        let dateFormatter = ISO8601DateFormatter()

        let date = dateFormatter.date(from: expectedArrivalTime)!

        switch date.timeIntervalSince(Date())/60 {
        case ..<1:
            return "Nå"

        case ..<11:
            if let isRealtime = isRealtime, isRealtime == true {
                return "\(String(format: "%.0f", date.timeIntervalSince(Date())/60)) min"
            } else {
                return "ca \(String(format: "%.0f", date.timeIntervalSince(Date())/60)) min"
            }

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

        if expectedTimeDate.timeIntervalSince(aimedTimeDate) > 60 {
            return "  (\(formatTimestamp(from: expectedTimeDate)))"
        }

        return ""
    }

}


// MARK: - Delegate

extension DepartureDetailsViewController: UICollectionViewDelegate {  }


// MARK: - Data Source

extension DepartureDetailsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sortedSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = segmentedDepartures[sortedSections[section]]?.count ?? 0

        if section == expandedSection {
            return count
        } else {
            return count > 4 ? 4 : count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepartureDetailsCollectionViewCell.identifier, for: indexPath) as! DepartureDetailsCollectionViewCell

        guard let departure = segmentedDepartures[sortedSections[indexPath.section]]?[indexPath.item] else {
            return cell
        }

        cell.lineLabel.text = String(departure.serviceJourney.journeyPattern.line.publicCode.prefix(3))
        cell.destinationLabel.text = departure.destinationDisplay.frontText
        cell.aimedTimeLabel.text = getAimedTimeLabel(aimedTime: departure.aimedArrivalTime)
        cell.newTimeLabel.text = getNewTimeLabel(aimedTime: departure.aimedArrivalTime, expectedTime: departure.expectedArrivalTime)

        cell.expectedTimeLable.text = formatExpectedTimeLabel(string: departure.expectedArrivalTime, isRealtime: departure.realtime)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DepartureDetailsCollectionViewHeaderCell.identifier, for: indexPath) as! DepartureDetailsCollectionViewHeaderCell

        headerView.delegate = self

        headerView.sectionHeaderLabel.text = String.localizedStringWithFormat(NSLocalizedString("Platform %d", comment: "Departure platform at stop place"), indexPath.section + 1)
        headerView.sectionNumber = indexPath.section

        UIView.performWithoutAnimation {
            if expandedSection == indexPath.section {
                headerView.expandButton.setTitle(NSLocalizedString("See less", comment: "Collapse departure list"), for: .normal)
            } else {
                headerView.expandButton.setTitle(NSLocalizedString("See all", comment: "Expand departure list"), for: .normal)
            }

            headerView.expandButton.sizeToFit()
            headerView.expandButton.layoutIfNeeded()
            headerView.expandButton.setNeedsLayout()
        }

        if let quays = self.quays,
            let quay = quays[sortedSections[indexPath.section]]?[0] {
            headerView.compassDirection = CompassDirection(bearing: String(format: "%.0f", quay.compassBearing))
        }

        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let departure = segmentedDepartures[sortedSections[indexPath.section]]?[indexPath.item] else {
            return
        }

        delegate?.selectJourney(self, with: departure.serviceJourney.id, and: departure.date, using: departure.destinationDisplay.frontText)
    }

}

extension DepartureDetailsViewController: DepartureDetailsCollectionViewHeaderCellDelegate {

    func expandSectionListWith(number: Int) {
        if self.expandedSection == number {
            self.expandedSection = -1
        } else {
            self.expandedSection = number
        }

        self.collectionView.reloadData()

        if expandedSection > -1 {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: expandedSection), at: .centeredVertically, animated: true)
        }
    }

}
