//  Copyright © 2018 Marton Kerekes. All rights reserved.

import UIKit
import CoreLocation

class LocationRefineViewController: UITableViewController {

    var useName: String?
    var completion: ((PlaceModel) -> ())?
    var placemark: CLPlacemark?
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

        let result = PlaceModel(address: address, city: city, country: country, name: name, zip: zip)
        completion?(result)        
    }
}

extension LocationRefineViewController: UITextFieldDelegate {

}

