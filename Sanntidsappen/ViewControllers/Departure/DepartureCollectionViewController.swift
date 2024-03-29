//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2019 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import UIKit
import CoreLocation
import CoreData
import SwiftUI

protocol DepartureCollectionViewControllerDelegate: AnyObject {
    func moveToDetailsViewController(from viewController: DepartureCollectionViewController, withStop stop: Stop)
    func getDetailsViewController(forStop stop: Stop) -> UIHostingController<DepartureDetail>
}

enum DepartureSearchSection: String, CaseIterable {
    case recent
    case nearby

    var title: String {
        switch self {
        case .recent: return NSLocalizedString("Recent", comment: "Recent searches")
        case .nearby: return NSLocalizedString("Nearby", comment: "Nearby stops")
        }
    }
}

class DepartureCollectionViewController: UICollectionViewController, Storyboarded, UICollectionViewDelegateFlowLayout {

    weak var coordinator: DepartureCollectionViewControllerDelegate?

    var locationManager: CLLocationManager!
    var searchController: UISearchController!
    var searchResultController: DepartureSearchResultViewController!
    var workingItem: DispatchWorkItem?

    var recentStopSearch: [String] = []
    var nearbyStops: [Stop] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionView = collectionView {
            let collectionViewWidth = collectionView.frame.width

            flowLayout.estimatedItemSize = CGSize(width: collectionViewWidth, height: 50)

            collectionView.register(UINib(nibName: SearchResultCell.identifier, bundle: nil), forCellWithReuseIdentifier: SearchResultCell.identifier)
        }

        searchResultController = DepartureSearchResultViewController()
        searchResultController.coordinator = self

        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = NSLocalizedString("Search stops", comment: "Search stops")

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.delegate = self
        searchController.searchBar.delegate = self

        definesPresentationContext = true

        RecentStopSearchData.shared.getRecentSearchFromCoreData() { [weak self] stops in
            self?.recentStopSearch = stops
            DispatchQueue.main.async {
                self?.collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
            }
        }

        enableBasicLocationServices()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DepartureSearchSection.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return recentStopSearch.count
        } else {
            return nearbyStops.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSearchCell", for: indexPath) as? RecentSearchCell else {
                fatalError("Unable to dequeue RecentSearchCell")
            }

            cell.stopNameLabel.text = recentStopSearch[indexPath.item]

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell else {
                fatalError("Unable to dequeue SearchResultCell")
            }

            cell.stopNameLabel.text = nearbyStops[indexPath.item].name
            cell.stopLocationLabel.text = nearbyStops[indexPath.item].locality + ", " + nearbyStops[indexPath.item].county

            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DepartureSearchSectionHeaderCell", for: indexPath) as? DepartureSearchSectionHeaderCell else {
            fatalError("Unable to dequeue DepartureSearchSectionHeaderCell")
        }

        cell.searchHeaderLabel.text = DepartureSearchSection.allCases[indexPath.section].title

        if indexPath.section == 0 {
            if recentStopSearch.count == 0 {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
        } else {
            if nearbyStops.count == 0 {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 50)
        } else {
            return CGSize(width: collectionView.frame.width, height: 56)
        }
    }


    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        if indexPath.section == 0 {
            (cell as? RecentSearchCell)?.topLine.backgroundColor = UITableView().separatorColor?.cgColor
            (cell as? RecentSearchCell)?.stopNameLabel.textColor = UIColor.SA.Primary
        } else {
            (cell as? SearchResultCell)?.topLine.backgroundColor = UITableView().separatorColor?.cgColor
            (cell as? SearchResultCell)?.stopNameLabel.textColor = UIColor.SA.Primary
            (cell as? SearchResultCell)?.stopLocationLabel.textColor = .lightGray
        }

        cell?.contentView.backgroundColor = UITableView().backgroundColor
    }

    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        if indexPath.section == 0 {
            (cell as? RecentSearchCell)?.topLine.backgroundColor = UIColor.SA.Primary.cgColor
            (cell as? RecentSearchCell)?.stopNameLabel.textColor = .white
        } else {
            (cell as? SearchResultCell)?.topLine.backgroundColor = UIColor.SA.Primary.cgColor
            (cell as? SearchResultCell)?.stopNameLabel.textColor = .white
            (cell as? SearchResultCell)?.stopLocationLabel.textColor = .white
        }

        cell?.contentView.backgroundColor = UIColor.SA.Primary
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.searchController.isActive = true
            self.searchController.searchBar.text = self.recentStopSearch[indexPath.item]
            self.searchBar(self.searchController.searchBar, textDidChange: self.recentStopSearch[indexPath.item])
        } else {
            self.coordinator?.moveToDetailsViewController(from: self, withStop: self.nearbyStops[indexPath.item])
        }
    }

}

// MARK: - Location functionality

extension DepartureCollectionViewController {

    func enableBasicLocationServices() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
    }

    func startReceivingUserLocation() {
        locationManager.requestLocation()
    }

    func updateNearbyStops(lastLocation: CLLocation) {
        let latitude = lastLocation.coordinate.latitude
        let longitude = lastLocation.coordinate.longitude

        Task {
            do {
                let stops = try await EnTurAPI.geocoder.getNearbyStops(latitude: latitude, longitude: longitude)

                self.nearbyStops = stops.stops

                DispatchQueue.main.async {
                    self.collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
                }
            } catch {
                DispatchQueue.main.async {
                    self.performSelector(onMainThread: #selector(self.showErrorAlert(lastLocation:)), with: nil, waitUntilDone: false)
                }
            }
        }
    }

    @objc func showErrorAlert(lastLocation: CLLocation) {
        let alertController = UIAlertController(title: NSLocalizedString("Oh, no!", comment: "Something wrong happened on network request"), message: NSLocalizedString("An error has occured. Make sure your phone is connected to the Internet and try again.", comment: "Try again"), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Try again", comment: "Try again"), style: .default) { _ in
            self.updateNearbyStops(lastLocation: lastLocation)
        })

        present(alertController, animated: true)
    }

}

// MARK: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate

extension DepartureCollectionViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            if let item = workingItem {
                item.cancel()
                workingItem = nil
            }

            workingItem = DispatchWorkItem {
                Task {
                    guard let stops = try? await EnTurAPI.geocoder.getAutocompleteBusStop(searchQuery: searchText) else {
                        return
                    }

                    self.searchResultController.stops = stops.stops
                    DispatchQueue.main.async {
                        self.searchResultController.collectionView?.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
                    }
                }
            }

            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.120, execute: workingItem!)
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

extension DepartureCollectionViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                startReceivingUserLocation()

            case .restricted, .denied:  // Location services currently unavailable.
                locationManager.stopUpdatingLocation()

            case .notDetermined:        // Authorization not determined yet.
               manager.requestWhenInUseAuthorization()

            default:
                break
            }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        searchResultController.currentLocation = locations.last!
        updateNearbyStops(lastLocation: locations.last!)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

}

// MARK: DepartureSearchResultViewControllerDelegate

extension DepartureCollectionViewController: DepartureSearchResultViewControllerDelegate {

    func dismissKeyboardFrom(_ viewController: DepartureSearchResultViewController) {
        searchController.searchBar.resignFirstResponder()
    }

    func selectDepartureAtIndexPath(_ viewController: DepartureSearchResultViewController, at indexPath: IndexPath) {
        let stop = searchResultController.stops[indexPath.item]

        RecentStopSearchData.shared.saveSearchToCoreData(stop: stop) { [weak self] stops in
            self?.recentStopSearch = stops

            DispatchQueue.main.async {
                self?.collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
            }
        }

        coordinator?.moveToDetailsViewController(from: self, withStop: stop)
    }

}
