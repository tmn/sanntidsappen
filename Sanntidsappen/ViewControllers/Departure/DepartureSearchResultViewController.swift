//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit
import CoreLocation

protocol DepartureSearchResultViewControllerDelegate: class {
    func dismissKeyboardFrom(_ viewController: DepartureSearchResultViewController)
    func selectDepartureAtIndexPath(_ viewController: DepartureSearchResultViewController, at indexPath: IndexPath)
}

class DepartureSearchResultViewController: UIViewController {

    weak var delegate: DepartureSearchResultViewControllerDelegate?

    var currentLocation: CLLocation?

    var stops: [Stop] = [] {
        didSet {
            guard let location = currentLocation else {
                return
            }

            stops = stops.sorted(by: { $0.distanceToCurrentLocation(to: location) < $1.distanceToCurrentLocation(to: location) })
        }
    }

    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

        flowLayout = ColumnFlowLayout(minimumLineSpacing: 0, cellHeight: 65)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)

        collectionView.alwaysBounceVertical = true

        collectionView.register(DepartureSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: DepartureSearchResultCollectionViewCell.identifier)

        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

}


// MARK: - Delegate

extension DepartureSearchResultViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = .white
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.85)
        cell?.contentView.layer.cornerRadius = 5
        cell?.contentView.clipsToBounds = true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectDepartureAtIndexPath(self, at: indexPath)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.dismissKeyboardFrom(self)
    }

}


// MARK: - DataSource

extension DepartureSearchResultViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stops.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepartureSearchResultCollectionViewCell.identifier, for: indexPath) as! DepartureSearchResultCollectionViewCell

        cell.nameLabel.text = stops[indexPath.item].properties.name
        cell.locationLabel.text = stops[indexPath.item].properties.locality + ", " + stops[indexPath.item].properties.county
        cell.stop = stops[indexPath.item]

        if indexPath.item == 0 {
            cell.bottomLine.isHidden = true
        } else {
            cell.bottomLine.isHidden = false
        }

        return cell
    }

}
