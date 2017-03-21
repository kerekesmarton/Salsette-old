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
import Segmentio

class MenuViewController: ColorMatchTabsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont.navigationTitleFont()
        popoverViewController = SearchPopoverViewController()
        popoverViewController?.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showMenu(_:)))
        dataSource = self
        reloadData()
        StubContentViewControllersProvider.viewControllers.forEach {
            self.addChildViewController($0)
            $0.didMove(toParentViewController: self)
        }
    }
    var sideMenuViewController: SideMenuViewController?
    func showMenu(_ sender: UIBarButtonItem) {
        let searchViewController = SearchFeatureLauncher.launchSearch()
        sideMenuViewController =  SideMenuViewController.create()
        sideMenuViewController?.presenter = self
        sideMenuViewController?.showSideMenu(in: self, with: searchViewController, sideMenuDidHide: { [weak self] style in
                self?.dismiss(animated: false, completion:nil)
            }
        )
    }
}

extension MenuViewController: ColorMatchTabsViewControllerDataSource {
    
    func numberOfItems(inController controller: ColorMatchTabsViewController) -> Int {
        return TabItemsProvider.items.count
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, viewControllerAt index: Int) -> UIViewController {
        return StubContentViewControllersProvider.viewControllers[index]
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, titleAt index: Int) -> String {
        return TabItemsProvider.items[index].title
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, iconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].normalImage
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, hightlightedIconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].highlightedImage
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, tintColorAt index: Int) -> UIColor {
        return TabItemsProvider.items[index].tintColor
    }
    
}

extension MenuViewController: PopoverViewControllerDelegate {

    func popoverViewController(_ popoverViewController: PopoverViewController, didSelectItemAt index: Int) {
        selectItem(at: index)
    }
}

extension MenuViewController: SideMenuPresenter {
    
    func didPresentChild(viewController: UIViewController) {
        self.title = viewController.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: sideMenuViewController, action: #selector(sideMenuViewController?.dismissSideMenu))
    }
    
    func willDismiss(sideMenu: SideMenuViewController) {
        self.title = "Salsette"
        self.navigationItem.rightBarButtonItem = nil
    }
}
