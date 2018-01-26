//  Copyright © 2018 Marton Kerekes. All rights reserved.

import UIKit
import CoreLocation

class LocationRefineViewController: UITableViewController {

    var completion: ((PlaceModel) -> ())?
    var placemark: CLPlacemark?
    {
        didSet {
            nameField.text = placemark?.name
            addressField.text = "\(String(describing: placemark?.subThoroughfare)) + \(String(describing: placemark?.thoroughfare))"
            cityField.text = placemark?.locality
            countryField.text = placemark?.country
            zipField.text = placemark?.postalCode
            coordsField.text = placemark?.location?.description
        }
    }
    var result: PlaceModel?
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var addressField: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var countryField: UITextField!
    @IBOutlet var zipField: UITextField!
    @IBOutlet var coordsField: UITextField!
    
    
    @IBAction func done(_ sender: Any) {
        guard let placemark = placemark else { return }
        result = PlaceModel(placemark: placemark)
        
        guard let result = result else { return }
        completion?(result)
    }
}
