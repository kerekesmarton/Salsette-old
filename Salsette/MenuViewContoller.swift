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

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var sideMenuViewController: SideMenuViewController?
    func showMenu(_ sender: UIBarButtonItem) {
        let searchViewController = SearchFeatureLauncher.launchSearch()
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
