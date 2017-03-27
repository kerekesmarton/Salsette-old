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
    static let Content = "Content"
}

private enum ViewControllers {
    static let SearchViewControllerNavigation = "SearchViewControllerNavigation"
    static let SearchViewController = "SearchViewController"
    static let ContentViewController = "ContentViewController"
    static let ContentViewControllerNavigation = "ContentViewControllerNavigation"
    static let CalendarViewController = "CalendarViewController"
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
    
    class func contentViewController() -> ContentViewController {
        let storyBoard = UIStoryboard(name: Storyboards.Content, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: ViewControllers.ContentViewController) as! ContentViewController
        return viewController
    }
    
    class func contentViewControllerInNavigation() -> ContentViewController {
        let storyBoard = UIStoryboard(name: Storyboards.Content, bundle: nil)
        let navController = storyBoard.instantiateViewController(withIdentifier: ViewControllers.ContentViewControllerNavigation) as! UINavigationController
        return navController.topViewController as! ContentViewController
    }
    
    class func calendarViewController() -> CalendarViewController {
        let storyBoard = UIStoryboard(name: Storyboards.Search, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: ViewControllers.CalendarViewController) as! CalendarViewController
    }
}
