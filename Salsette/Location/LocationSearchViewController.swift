//  Copyright © 2018 Marton Kerekes. All rights reserved.

import UIKit
import CoreLocation

class LocationSearchViewController: UITableViewController {
    lazy var locationMatcher = LocationMatching()
    var fbLocation: FacebookLocation?
    var accurateSearchCompletion: ((PlaceModel) -> ())?
    var lowAccuracySearchCompletion: ((FacebookLocation) -> ())?
    private lazy var search: SearchController = {
        let vc = SearchController(searchResultsController: nil)
        vc.searchResultsUpdater = self
        vc.delegate = self
        vc.searchBar.placeholder = "Address, City, etc."            
        return vc
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.searchController = search
        if let name = fbLocation?.displayableName() {
            search.searchBar.text = "\(name), \(fbLocation?.displayableAddress() ?? "")"
        } else {
            search.searchBar.text = fbLocation?.displayableAddress()
        }

        search.isActive = true
    }
    
    @objc func finish() {
        dismiss(animated: true)
    }
    
    private func didChange(location text: String?) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(updateLocationSearch(text:)), with: text, afterDelay: 0.5)
    }
    
    @objc private func updateLocationSearch(text: String?) {
        guard let text = text else { return }
        locationMatcher.geocode(value: text) { (fbLocations) in
            self.locations = fbLocations
        }
        locationMatcher.geocode(value: text) { [weak self] (fbLocations) in
            self?.locations = fbLocations
        }
    }
    
    private var locations: [SearchableLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let placemark = locations[indexPath.row]
        cell.textLabel?.text = placemark.displayableName()
        cell.detailTextLabel?.text = placemark.displayableAddress()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        if let fbLocation = location as? FacebookLocation {
            lowAccuracySearchCompletion?(fbLocation)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if accurateSearchCompletion != nil {
            return true
        }
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? LocationRefineViewController, let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell) else { return }
        vc.useName = fbLocation?.name
        vc.completion = accurateSearchCompletion
        if let fbLocation = locations[index.row] as? FacebookLocation {
            vc.location = fbLocation
        }
    }
}

extension LocationSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        didChange(location: text)
    }
}

extension LocationSearchViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        finish()
    }
}
