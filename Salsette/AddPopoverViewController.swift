//
//  SearchPopoverViewController.swift
//  ColorMatchTabs
//
//  Created by Marton Kerekes on 08/03/2017.
//  Modified by Kerekes Marton
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class SearchPopoverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }
    
    var searchViewController: SearchViewController! {
        
        let searchViewController = UIStoryboard.searchViewController()
        self.view.addSubview(searchViewController.view)
        self.addChildViewController(searchViewController)
        searchViewController.didMove(toParentViewController: self)
        
        return searchViewController
    }
    
    fileprivate func setupContentView() {
        guard let searchView = searchViewController.view else {
            return
        }
        view.addSubview(searchView)
        
        searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
