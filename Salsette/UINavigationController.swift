
import UIKit

extension UINavigationController {
    func customizeTransparentNavigationBar() {
        view.backgroundColor = UIColor.white
        navigationBar.barTintColor = UIColor.clear
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        let image = UIImage.resizableImage(UIColor.white, cornerRadius: 0)
        navigationBar.shadowImage = image
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.isTranslucent = true
    }
}
