//  Copyright © 2018 Marton Kerekes. All rights reserved.

import Foundation
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

class LocationMatching: NSObject {
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
    }
    
    lazy var geocoder = CLGeocoder()
    func geocode(value: String, completion: @escaping ([SearchableLocation])->()) {
        geocoder.geocodeAddressString(value, completionHandler: { (placemarks, error) in
            guard let placemarks = placemarks else {
                completion([])
                return
            }
            let fbLocations = placemarks.map({ (placemark) -> FacebookLocation in
                let fbLocation = FacebookLocation()
                fbLocation.address = placemark.displayableAddress()
                fbLocation.city = placemark.graphLocation()
                fbLocation.country = placemark.country
                fbLocation.name = placemark.name
                fbLocation.zip = placemark.postalCode
                return fbLocation
            })
            
            completion(fbLocations)
        })
    }
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    private var completion: ((SearchableLocation)->())?
    func reverseGeocodeCurrentLocation(completion: @escaping (SearchableLocation)->()) {
        self.completion = completion
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationMatching: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        geocoder.reverseGeocodeLocation(userLocation) { [weak self] (placemarks, error) in
            guard let placemarks = placemarks, placemarks.count > 0 else {
                return
            }
            self?.completion?(placemarks[0])
            self?.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
