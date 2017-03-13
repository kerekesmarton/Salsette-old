//
//  StoryboardHelper.swift
//  Salsette
//
//  Created by Marton Kerekes on 14/02/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

private enum Storyboards {
    static let Main = "Main"
    static let Search = "Search"
}

private enum ViewControllers {
    static let CalendarViewController = "CalendarViewController"
    static let SearchViewControllerNavigation = "SearchViewControllerNavigation"
    static let SearchViewController = "SearchViewController"
    
}

extension UIStoryboard {
    class func searchViewControllerWithNavigation() -> (SearchViewController) {
        let storyBoard = UIStoryboard(name: Storyboards.Search, bundle: nil)
        let navigationController = storyBoard.instantiateViewController(withIdentifier: ViewControllers.SearchViewControllerNavigation) as! UINavigationController
        let searchVC = navigationController.topViewController as! SearchViewController
        return searchVC
    }
    
    class func searchViewController() -> SearchViewController {
        let storyBoard = UIStoryboard(name: Storyboards.Search, bundle: nil)
        let searchVC = storyBoard.instantiateViewController(withIdentifier: ViewControllers.SearchViewController) as! SearchViewController
        return searchVC
    }
}
