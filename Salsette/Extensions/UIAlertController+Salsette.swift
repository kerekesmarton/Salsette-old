
import UIKit

extension UIAlertController {
    
    static func loadingAlert(with message: String? = "Please, wait...") -> UIAlertController {
        return UIAlertController(title: nil, message: message, preferredStyle: .alert)
    }

    static func errorAlert(with error: Error) -> UIAlertController {
        let alert = UIAlertController(title: "Uh-oh", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    }
}
