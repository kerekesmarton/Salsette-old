//  Copyright © 2018 Marton Kerekes. All rights reserved.

import UIKit
import CoreLocation

extension PlaceModel: SearchableLocation {
    
    init?(placemark: CLPlacemark) {
        guard let address = placemark.thoroughfare, let name = placemark.name, let city = placemark.locality, let country = placemark.country, let zip = placemark.postalCode else {
            return nil
        }
        self.address = address
        self.city = city
        self.country = country
        self.name = name
        self.zip = zip
    }
    
    func displayableName() -> String? {
        return name
    }
    
    func displayableAddress() -> String? {
        return "\(zip), \(city), \(address)"
    }
    
    public func graphLocation() -> String? {
        return city
    }
}

extension CLPlacemark: SearchableLocation {
    
    public func displayableName() -> String? {
        return name
    }
    
    public func graphLocation() -> String? {
        if let city = locality {
            return city
        }
        return nil
    }
    
    public func displayableAddress() -> String? {
        guard let address = thoroughfare, let city = locality, let country = country, let zip = postalCode else {            
            if let city = locality {
                return city
            }
            return nil
        }
        
        return "\(address), \(zip), \(city),\(country)"
    }
    
    public func displayableCoordinates() -> String? {
        guard let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude else {
            return nil
        }
        return "Lat: \(lat), Lon\(lon)"
    }
}

class LocationSearchViewController: UITableViewController {
    lazy var locationMatcher = LocationMatching()
    var fbLocation: FacebookLocation?
    var accurateSearchCompletion: ((PlaceModel) -> ())?
    var lowAccuracySearchCompletion: ((FacebookLocation) -> ())?
    private lazy var search: SearchController = {
        let vc = SearchController(searchResultsController: nil)
        vc.searchResultsUpdater = self
        vc.delegate = self
        vc.searchBar.placeholder = "Search"        
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
        locationMatcher.geocode(value: text) { [weak self] (placemarks) in
            self?.places = placemarks
        }
    }
    
    private var places: [CLPlacemark] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let placemark = places[indexPath.row]
        cell.textLabel?.text = placemark.displayableName()
        cell.detailTextLabel?.text = placemark.displayableAddress()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placemark = places[indexPath.row]
        let location = FacebookLocation()
        location.city = placemark.locality
        location.address = placemark.displayableAddress()
        lowAccuracySearchCompletion?(location)
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
        vc.placemark = places[index.row]
        vc.completion = accurateSearchCompletion
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
