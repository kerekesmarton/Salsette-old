//
//  MenuViewController.swift
//  ColorMatchTabs
//
//  Created by Serhii Butenko on 26/6/16.
//  Modified by Kerekes Marton
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import ColorMatchTabs

class MenuViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showMenu(_:)))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewControllers = StubContentViewControllersProvider.viewControllers
    }
    
    var sideMenuViewController: SideMenuViewController?
    func showMenu(_ sender: UIBarButtonItem) {
        let searchViewController = SearchFeatureLauncher.launchSearch(for: self)
        sideMenuViewController =  SideMenuViewController.create()
        sideMenuViewController?.showSideMenu(in: self, with: searchViewController, sideMenuDidHide: { [weak self] in
                self?.dismiss(animated: false, completion:nil)
            }
        )
    }
}

extension MenuViewController: SearchResultsDelegate {
    func didUpdateSearch(parameters: SearchParameters) {
        
    }
}
