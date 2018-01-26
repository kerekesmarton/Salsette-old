//  Copyright © 2018 Marton Kerekes. All rights reserved.

import UIKit

class LocationViewController: UISearchController {
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = .minimal
        hidesNavigationBarDuringPresentation = true
        obscuresBackgroundDuringPresentation = false
    }
}
