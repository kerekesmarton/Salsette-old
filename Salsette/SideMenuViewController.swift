//
//  SideMenuViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Modified by Kerekes Marton
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import Presentr


typealias SideMenuHandler = (() -> Void)

private let animationDuration: TimeInterval = 0.3

class SideMenuViewController: UIViewController {
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var sideMenuContainerViewWidthConstraint: NSLayoutConstraint!
    var sideMenuDidHide: SideMenuHandler?
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .topHalf)
        presenter.transitionType = .coverVerticalFromTop
//        presenter.blurBackground = true
//        presenter.blurStyle = UIBlurEffectStyle.light
        return presenter
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.resignFirstResponder()
    }
    
    class func create() -> SideMenuViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        return board.instantiateViewController(withIdentifier: String(describing: self)) as! SideMenuViewController
    }
    
    func showSideMenu(in hostViewController: UIViewController, with child: UIViewController, sideMenuDidHide: SideMenuHandler?) {
        self.sideMenuDidHide = sideMenuDidHide
        self.addToContainer(childViewController: child)
        hostViewController.customPresentViewController(presenter, viewController: self, animated: true, completion:nil)
    }
    
    func addToContainer(childViewController: UIViewController) {
        self.view.addSubview(childViewController.view)
        self.addChildViewController(childViewController)
        childViewController.didMove(toParentViewController: self)
        
        containerView.addSubview(childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = true
        childViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        childViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        childViewController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        childViewController.view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    // MARK: - Private functions
    fileprivate func didSelectItem(at indexPath: IndexPath) {
        dismissSideMenu()
    }
    
    @objc func dismissSideMenu() {
        
    }
    
}
