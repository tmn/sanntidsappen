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

protocol DepartureViewControllerDelegate: class {
    func departureViewController(_ viewController: DepartureViewController, continueWith stop: Stop)
}

enum SearchContainerSection: String, CaseIterable {
    case recent = "Recent"
    case nearby = "Nearby stops"
}

class DepartureViewController: UIViewController {

    weak var delegate: DepartureViewControllerDelegate?

    var searchController: UISearchController!
    var searchResultController: DepartureSearchResultViewController!

    var flowLayout: UICollectionViewFlowLayout!
    var collectionView: UICollectionView!

    var workingItem: DispatchWorkItem?

    var locationManager: CLLocationManager!

    var sections: [SearchContainerSection: [Stop]] = [
        .recent: [],
        .nearby: []
    ]

    init() {
        super.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("Search", comment: "Find departures")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        flowLayout = ColumnFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 55)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.alwaysBounceVertical = true

        view.addSubview(collectionView)

        collectionView.register(DepartureSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: DepartureSearchResultCollectionViewCell.identifier)
        collectionView.register(DepartureViewControllerHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DepartureViewControllerHeaderCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self

        searchResultController = DepartureSearchResultViewController()
        searchResultController.delegate = self

        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Bus Stops", comment: "Search bus stops")

        // TODO: support older OS?
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }

        definesPresentationContext = true

        enableBasicLocationServices()
    }

}


// MARK: - Location functionality

extension DepartureViewController {

    func enableBasicLocationServices() {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .restricted, .denied:
            print("DENIED")

        case .authorizedWhenInUse, .authorizedAlways:
            startReceivingUserLocation()
        }
    }

    func startReceivingUserLocation() {
        locationManager.startUpdatingLocation()
    }

    func updateNearbyStops(lastLocation: CLLocation) {
        let latitude = lastLocation.coordinate.latitude
        let longitude = lastLocation.coordinate.longitude

        EnTurAPI.getNearbyStops(latitude: latitude, longitude: longitude, type: Feature.self) { res in
            DispatchQueue.main.async {
                switch res {
                case .success(let value):
                    self.sections[.nearby] = value.features
                    self.collectionView.reloadData()

                case .failure:
                    print("ERROR")
                }
            }
        }
    }

}


// MARK: - DataSource: UICollectionView

extension DepartureViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchContainerSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[SearchContainerSection.allCases[section]]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepartureSearchResultCollectionViewCell.identifier, for: indexPath) as! DepartureSearchResultCollectionViewCell

        cell.nameLabel.text = sections[SearchContainerSection.allCases[indexPath.section]]![indexPath.item].properties.name

        if indexPath.section == 0 {
            cell.locationLabel.isHidden = true
            cell.nameLabel.font = UIFont.systemFont(ofSize: 24)
        } else {
            cell.locationLabel.isHidden = false
            cell.nameLabel.font = UIFont.systemFont(ofSize: 20)
            cell.locationLabel.text = sections[SearchContainerSection.allCases[indexPath.section]]![indexPath.item].properties.locality + ", " +  sections[SearchContainerSection.allCases[indexPath.section]]![indexPath.item].properties.county
        }

        cell.stop = sections[SearchContainerSection.allCases[indexPath.section]]![indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DepartureViewControllerHeaderCell.identifier, for: indexPath) as! DepartureViewControllerHeaderCell

        headerView.titleLabel.text = SearchContainerSection.allCases[indexPath.section].rawValue

        return headerView
    }

}


// MARK: - Delegates

// MARK: UICollectionViewDelegate

extension DepartureViewController: UICollectionViewDelegate {

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
        if indexPath.section == 0 {
            if let stop = sections[.recent]?[indexPath.item] {
                self.searchController.isActive = true
                self.searchController.searchBar.text = stop.properties.name
                self.searchBar(self.searchController.searchBar, textDidChange: stop.properties.name)
            }
        } else {
            if let stop = sections[.nearby]?[indexPath.item] {
                self.delegate?.departureViewController(self, continueWith: stop)
            }
        }
    }

}


// MARK: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate

extension DepartureViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            if let item = workingItem {
                item.cancel()
                workingItem = nil
            }

            workingItem = DispatchWorkItem { EnTurAPI.getAutocompleteBusStop(searchQuery: searchText, type: Feature.self) { res in

                DispatchQueue.main.async {
                    switch res {
                    case .success(let value):
                        self.searchResultController.stops =  value.features
                        self.searchResultController.collectionView?.reloadData()

                    case .failure(let error):
                        print("ERROR: \(error)")
                    }
                }
                } }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workingItem!)
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = self.searchController.searchBar.text else {
            return
        }

        if searchText.count == 0 {
            if searchResultController.stops.count > 0 {
                searchResultController.stops = []
                searchResultController.collectionView.reloadData()
            }
        }
    }

}


// MARK: CLLocationManager

extension DepartureViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            print("DISABLED")

        case .authorizedWhenInUse:
            startReceivingUserLocation()

        case .notDetermined, .authorizedAlways:
            print("HMMM")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateNearbyStops(lastLocation: locations.last!)
    }

}


// MARK: DepartureSearchResultViewControllerDelegate

extension DepartureViewController: DepartureSearchResultViewControllerDelegate {

    func selectDepartureAtIndexPath(_ viewController: DepartureSearchResultViewController, at indexPath: IndexPath) {
        let stop = searchResultController.stops[indexPath.item]

        // TODO: populate database instead of this
        self.sections[.recent]?.append(stop)
        self.collectionView.reloadData()

        delegate?.departureViewController(self, continueWith: stop)
    }

    func dismissKeyboardFrom(_ viewController: DepartureSearchResultViewController) {
        self.searchController.searchBar.resignFirstResponder()
    }

}
