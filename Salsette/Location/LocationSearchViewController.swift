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

class LocationSearchViewController: UITableViewController {
    private let geocoder = CLGeocoder()
    var fbLocation: FacebookLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finish))
        let search = LocationViewController(searchResultsController: nil)
        navigationItem.searchController = search
        search.delegate = self
        search.searchResultsUpdater = self
        search.isActive = true
        search.searchBar.text = fbLocation?.displayableAddress()
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
    
    private var places: [PlaceModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private func geocode(value: String) {
        geocoder.geocodeAddressString(value, completionHandler: { (placemarks, error) in
            guard let placemarks = placemarks, placemarks.count >= 0 else {
                self.places = []
                return
            }
            self.places = placemarks.flatMap({ (placemark) -> PlaceModel? in
                return PlaceModel(placemark: placemark)
            })
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let model = places[indexPath.row]
        cell.textLabel?.text = model.displayableName()
        cell.detailTextLabel?.text = model.displayableAddress()
        return cell
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
