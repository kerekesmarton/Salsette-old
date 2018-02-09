//
//  LocationMatching.swift
//  Salsette
//
//  Created by Marton Kerekes on 08/02/2018.
//  Copyright © 2018 Marton Kerekes. All rights reserved.
//

import Foundation
import CoreLocation

class LocationMatching: NSObject {
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
    }
    
    lazy var geocoder = CLGeocoder()
    func geocode(value: String, completion: @escaping ([CLPlacemark])->()) {
        geocoder.geocodeAddressString(value, completionHandler: { (placemarks, error) in
            guard let placemarks = placemarks, placemarks.count >= 0 else {
                completion([])
                return
            }
            completion(placemarks)
        })
    }
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    var completion: ((CLPlacemark)->())?
    func reverseGeocodeCurrentLocation(completion: @escaping (CLPlacemark)->()) {
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
