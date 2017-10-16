
import UIKit

extension UINavigationController {
    func customizeTransparentNavigationBar() {
        view.backgroundColor = UIColor.flatWhite
        navigationBar.barTintColor = UIColor.clear
        navigationBar.tintColor = UIColor.flatBlue
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.flatWhite]
        let image = UIImage.resizableImage(UIColor.flatWhite, cornerRadius: 0)
        navigationBar.shadowImage = image
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.isTranslucent = true
        navigationBar.tintAdjustmentMode = .normal
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customizeTransparentNavigationBar()
    }
}
