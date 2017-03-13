//
//  SearchPopoverViewController.swift
//  ColorMatchTabs
//
//  Created by Marton Kerekes on 08/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import ColorMatchTabs

class SearchPopoverViewController: PopoverViewController {
    
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
        contentView.addSubview(searchView)
        
        searchView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        searchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        searchView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        searchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
