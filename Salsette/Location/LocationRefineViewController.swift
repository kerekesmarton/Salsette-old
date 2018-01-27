//  Copyright © 2018 Marton Kerekes. All rights reserved.

import UIKit
import CoreLocation

extension CLLocationCoordinate2D {
    func readable() -> String {
        return "Lat: \(latitude), Lon: \(longitude)"
    }
}

class LocationRefineViewController: UITableViewController {

    var useName: String?
    var completion: ((PlaceModel) -> ())?
    var placemark: CLPlacemark?
    private let geocoder = CLGeocoder()
    @IBOutlet var nameField: UITextField!
    @IBOutlet var addressField: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var countryField: UITextField!
    @IBOutlet var zipField: UITextField!
    @IBOutlet var coordsField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = useName ?? placemark?.name
        addressField.text = "\(placemark?.subThoroughfare ?? "") \(placemark?.thoroughfare ?? "")"
        cityField.text = placemark?.locality
        countryField.text = placemark?.country
        zipField.text = placemark?.postalCode
        coordinates = placemark?.location?.coordinate
        fillCoordinatesLabel()
    }

    private func fillCoordinatesLabel() {
        if let coordinates = coordinates, CLLocationCoordinate2DIsValid(coordinates) {
            coordsField.text = coordinates.readable()
        } else {
            coordsField.text = nil
        }
    }

    fileprivate func startGeocode() {
        var text = placemark?.subThoroughfare ?? ""
        text.append(" \(placemark?.thoroughfare ?? "")")
        text.append(", \(placemark?.locality ?? "")")

        geocode(text: text)
    }
    var coordinates: CLLocationCoordinate2D? {
        didSet {
            fillCoordinatesLabel()
        }
    }
    private func geocode(text: String) {
        geocoder.geocodeAddressString(text, completionHandler: { [weak self] (placemarks, error) in
            guard let placemarks = placemarks, placemarks.count >= 0 else {
                self?.coordinates = nil
                return
            }
            self?.coordinates = placemarks.first?.location?.coordinate
        })
    }

    @IBAction func done(_ sender: Any) {
        guard let name = nameField.text, name.count > 2 else {
            nameField.becomeFirstResponder()
            return
        }
        guard let address = addressField.text, address.count > 3 else {
            addressField.becomeFirstResponder()
            return
        }
        guard let city = cityField.text, city.count > 2 else {
            cityField.becomeFirstResponder()
            return
        }

        guard let country = countryField.text, country.count > 2 else {
            countryField.becomeFirstResponder()
            return
        }

        guard let zip = zipField.text, zip.count > 2 else {
            zipField.becomeFirstResponder()
            return
        }

        guard let coords = coordinates else {
            coordsField.becomeFirstResponder()
            return
        }

        let result = PlaceModel(address: address, city: city, country: country, lat: coords.latitude, lon: coords.longitude, name: name, zip: zip)
        completion?(result)        
    }
}

extension LocationRefineViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == coordsField {
            startGeocode()
            return false
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == coordsField {
            startGeocode()
            return
        }
    }
}

