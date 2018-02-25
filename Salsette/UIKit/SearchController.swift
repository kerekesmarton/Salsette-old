//  Copyright © 2018 Marton Kerekes. All rights reserved.

import UIKit
import ChameleonFramework

class SearchController: UISearchController {
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = .minimal
        hidesNavigationBarDuringPresentation = false
        obscuresBackgroundDuringPresentation = false
        searchBar.tintColor = UIColor.flatBlue
        searchBar.backgroundColor = UIColor.flatWhite
    }
}
