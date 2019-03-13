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
import CoreData

protocol DepartureViewControllerDelegate: AnyObject {
    func moveToDetailsViewController(from viewController: DepartureViewController, withStop stop: Stop)
    func moveToDetailsViewController(from viewController: DepartureViewController, withDetailsView nextView: DepartureDetailsViewController)
    func getDetailsViewController(forStop stop: Stop) -> DepartureDetailsViewController
}

enum SearchContainerSection: String, CaseIterable {
    case recent = "Recent search"
    case nearby = "Nearby stops"
}

class DepartureViewController: UIViewController, Storyboarded {

    weak var coordinator: DepartureViewControllerDelegate?

    @IBOutlet weak var collectionView: UICollectionView!

    var searchController: UISearchController!
    var searchResultController: DepartureSearchResultViewController!

    var flowLayout: UICollectionViewFlowLayout!
    var locationManager: CLLocationManager!
    var workingItem: DispatchWorkItem?

    var recentStopSearch: [String] = []
    var nearbyStops: [Stop] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Search", comment: "Find departures")

        flowLayout = ColumnFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 55)

        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        registerForPreviewing(with: self, sourceView: collectionView)

        collectionView.register(DepartureSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: DepartureSearchResultCollectionViewCell.identifier)
        collectionView.register(DepartureViewControllerHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DepartureViewControllerHeaderCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self

        searchResultController = DepartureSearchResultViewController()
        searchResultController.coordinator = self

        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = NSLocalizedString("Bus Stops", comment: "Search bus stops")

        // TODO: support older OS?
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }

        searchController.delegate = self
        searchController.searchBar.delegate = self

        definesPresentationContext = true

        enableBasicLocationServices()

        RecentStopSearchData.shared.getRecentSearchFromCoreData() { stops in
            self.recentStopSearch = stops
            self.collectionView.reloadData()
        }
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

        EnTurAPI.geocoder.getNearbyStops(latitude: latitude, longitude: longitude) { res in
            DispatchQueue.main.async {
                switch res {
                case .success(let value):
                    self.nearbyStops = value.features

                    self.collectionView.reloadData()

                case .failure:
                    let alertController = UIAlertController(title: NSLocalizedString("Oh, no!", comment: "Something wrong happened on network request"), message: NSLocalizedString("An error has occured. Make sure your phone is connected to the Internet and try again.", comment: "Try again"), preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Try again", comment: "Try again"), style: .default) { _ in
                        self.updateNearbyStops(lastLocation: lastLocation)
                    })
                    self.present(alertController, animated: true)
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
        if section == 0 {
            return self.recentStopSearch.count
        } else {
            return self.nearbyStops.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepartureSearchResultCollectionViewCell.identifier, for: indexPath) as! DepartureSearchResultCollectionViewCell

        if indexPath.section == 0 {
            cell.nameLabel.text = self.recentStopSearch[indexPath.item]
            cell.nameLabel.font = UIFont.systemFont(ofSize: 24)

            cell.locationLabel.isHidden = true
        } else {
            cell.nameLabel.text = self.nearbyStops[indexPath.item].properties.name
            cell.nameLabel.font = UIFont.systemFont(ofSize: 20)

            cell.locationLabel.isHidden = false
            cell.locationLabel.text = self.nearbyStops[indexPath.item].properties.locality + ", " + self.nearbyStops[indexPath.item].properties.county

            cell.stop = self.nearbyStops[indexPath.item]
        }

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
            self.searchController.isActive = true
            self.searchController.searchBar.text = self.recentStopSearch[indexPath.item]
            self.searchBar(self.searchController.searchBar, textDidChange: self.recentStopSearch[indexPath.item])
        } else {
            self.coordinator?.moveToDetailsViewController(from: self, withStop: self.nearbyStops[indexPath.item])
        }
    }

}


// MARK: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate

extension DepartureViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            if let item = workingItem {
                item.cancel()
                workingItem = nil
            }

            workingItem = DispatchWorkItem { EnTurAPI.geocoder.getAutocompleteBusStop(searchQuery: searchText) { res in

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

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.120, execute: workingItem!)
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

// MARK: UIViewControllerPreviewingDelegate

extension DepartureViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.coordinator?.moveToDetailsViewController(from: self, withDetailsView: viewControllerToCommit as! DepartureDetailsViewController)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = collectionView.indexPathForItem(at: location), let cellAttributes = collectionView.layoutAttributesForItem(at: indexPath) {
            if indexPath.section > 0 {
                previewingContext.sourceRect = cellAttributes.frame
                return self.coordinator?.getDetailsViewController(forStop: self.nearbyStops[indexPath.item])
            }
        }
        
        return nil
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
        searchResultController.currentLocation = locations.last!
        updateNearbyStops(lastLocation: locations.last!)
    }

}


// MARK: DepartureSearchResultViewControllerDelegate

extension DepartureViewController: DepartureSearchResultViewControllerDelegate {
    
    func previewDepartureAtIndexPath(_ viewController: DepartureSearchResultViewController, at indexPath: IndexPath) -> DepartureDetailsViewController? {
        let stop = searchResultController.stops[indexPath.item]
        return self.coordinator?.getDetailsViewController(forStop: stop)
    }
    
    func commitPreviewedViewController(_ viewController: DepartureSearchResultViewController, viewControllerToCommit: DepartureDetailsViewController) {
        
        RecentStopSearchData.shared.saveSearchToCoreData(stop: viewControllerToCommit.stop) { stops in
            self.recentStopSearch = stops
            self.collectionView.reloadData()
        }
        
        self.coordinator?.moveToDetailsViewController(from: self, withDetailsView: viewControllerToCommit)
    }
    
    func selectDepartureAtIndexPath(_ viewController: DepartureSearchResultViewController, at indexPath: IndexPath) {
        let stop = searchResultController.stops[indexPath.item]

        RecentStopSearchData.shared.saveSearchToCoreData(stop: stop) { stops in
            self.recentStopSearch = stops
            self.collectionView.reloadData()
        }

        coordinator?.moveToDetailsViewController(from: self, withStop: stop)
    }

    func dismissKeyboardFrom(_ viewController: DepartureSearchResultViewController) {
        self.searchController.searchBar.resignFirstResponder()
    }
    
}
