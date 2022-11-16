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
import SwiftUI

protocol DepartureSearchResultViewControllerDelegate: AnyObject {
    func dismissKeyboardFrom(_ viewController: DepartureSearchResultViewController)
    func selectDepartureAtIndexPath(_ viewController: DepartureSearchResultViewController, at indexPath: IndexPath)
}

class DepartureSearchResultViewController: UIViewController {

    weak var coordinator: DepartureSearchResultViewControllerDelegate?

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

        flowLayout = ColumnFlowLayout(minimumLineSpacing: 0, cellHeight: 56)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)

        collectionView.alwaysBounceVertical = true

        collectionView.register(UINib(nibName: SearchResultCell.identifier, bundle: nil), forCellWithReuseIdentifier: SearchResultCell.identifier)
        
        view.addSubview(collectionView)

        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }

        collectionView.dataSource = self
        collectionView.delegate = self
    }

}


// MARK: - Delegate

extension DepartureSearchResultViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        (cell as? SearchResultCell)?.topLine.backgroundColor = UITableView().separatorColor?.cgColor
        (cell as? SearchResultCell)?.stopNameLabel.textColor = UIColor.SA.Primary
        (cell as? SearchResultCell)?.stopLocationLabel.textColor = .lightGray
        
        if #available(iOS 13.0, *) {
            cell?.contentView.backgroundColor = .systemBackground
        } else {
            cell?.contentView.backgroundColor = .white
        }
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        (cell as? SearchResultCell)?.topLine.backgroundColor = UIColor.SA.Primary.cgColor
        (cell as? SearchResultCell)?.stopNameLabel.textColor = .white
        (cell as? SearchResultCell)?.stopLocationLabel.textColor = .white
        
        cell?.contentView.backgroundColor = UIColor.SA.Primary
        cell?.contentView.clipsToBounds = true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.selectDepartureAtIndexPath(self, at: indexPath)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        coordinator?.dismissKeyboardFrom(self)
    }

}



// MARK: - DataSource

extension DepartureSearchResultViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stops.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell

        cell.stopNameLabel.text = stops[indexPath.item].name
        cell.stopLocationLabel.text = stops[indexPath.item].locality + ", " + stops[indexPath.item].county

        cell.stop = stops[indexPath.item]
        cell.topLine.isHidden = indexPath.item == 0

        return cell
    }

}
