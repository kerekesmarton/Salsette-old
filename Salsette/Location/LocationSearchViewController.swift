//  Copyright © 2018 Marton Kerekes. All rights reserved.

import UIKit
import CoreLocation

extension PlaceModel: SearchableLocation {
    
    init?(placemark: CLPlacemark) {
        guard let address = placemark.thoroughfare, let name = placemark.name, let city = placemark.locality, let country = placemark.country, let zip = placemark.postalCode, let lat = placemark.location?.coordinate.latitude, let lon = placemark.location?.coordinate.longitude else {
            return nil
        }
        self.address = address
        self.city = city
        self.country = country
        self.lat = lat
        self.lon = lon
        self.name = name
        self.zip = zip
    }
    
    func displayableName() -> String? {
        return name
    }
    
    func displayableAddress() -> String? {
        return "\(zip), \(city), \(address)"
    }
    
    func displayableCoordinates() -> String? {
        return "latitude: \(lat), longitude: \(lon)"
    }
}

extension CLPlacemark: SearchableLocation {
    
    public func displayableName() -> String? {
        return name
    }
    
    public func displayableAddress() -> String? {
        guard let address = thoroughfare, let city = locality, let country = country, let zip = postalCode else {
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
    private let geocoder = CLGeocoder()
    var fbLocation: FacebookLocation?
    var completion: ((PlaceModel) -> ())?
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
        search.searchBar.text = fbLocation?.displayableAddress()
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
        geocode(value: text)
    }
    
    private var places: [CLPlacemark] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private func geocode(value: String) {
        geocoder.geocodeAddressString(value, completionHandler: { [weak self] (placemarks, error) in
            guard let placemarks = placemarks, placemarks.count >= 0 else {
                self?.places = []
                return
            }
            self?.places = placemarks
        })
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? LocationRefineViewController, let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell) else { return }
        vc.placemark = places[index.row]
        vc.completion = completion
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
