//
//  SideMenuViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Modified by Kerekes Marton
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import Segmentio

protocol SideMenuChildViewProtocol {
    func resizeViewsToFit(frame: CGRect)
}

@objc protocol SideMenuPresenter {
    func didPresentChild(viewController: UIViewController)
    func willDismiss(sideMenu: SideMenuViewController)
}

typealias SideMenuHandler = (() -> Void)

private let animationDuration: TimeInterval = 0.3
private let selectedCheckboxImage = UIImage(named: "selectedCheckbox")
private let defaultCheckboxImage = UIImage(named: "defaultCheckbox")

class SideMenuViewController: UIViewController {
    
    var sideMenuDidHide: SideMenuHandler?
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var sideMenuContainerViewWidthConstraint: NSLayoutConstraint!
    weak var presenter: SideMenuPresenter?
    fileprivate var currentStyle = SegmentioStyle.onlyImage
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.isHidden = true
        view.isHidden = true
        setupGestureRecognizers()
    }
    
    // MARK: - Public functions
    
    class func create() -> SideMenuViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        return board.instantiateViewController(withIdentifier: String(describing: self)) as! SideMenuViewController
    }
    
    func showSideMenu(in hostViewController: UIViewController, with child: UIViewController, currentStyle: SegmentioStyle = SegmentioStyle.onlyImage, sideMenuDidHide: SideMenuHandler?) {
        self.currentStyle = currentStyle
        self.sideMenuDidHide = sideMenuDidHide
        modalPresentationStyle = .overCurrentContext
        let size = view.frame.size
        
        hostViewController.present(self, animated: false) { [weak self] in
            self?.addToContainer(childViewController: child)
            self?.view.isHidden = false
            self?.containerView.frame.origin = CGPoint(x: -size.width, y: 0)
            UIView.animate(
                withDuration: animationDuration,
                animations: {
                    self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.63)
                    self?.slideAnimationToPoint(.zero)
                    self?.containerView.isHidden = false
                }
            )
        }
    }
    
    func addToContainer(childViewController: UIViewController) {
        guard let childView = childViewController.view,
        let adaptingViewController = childViewController as? SideMenuChildViewProtocol else {
            return
        }
        self.presenter?.didPresentChild(viewController: childViewController)
        self.view.addSubview(childViewController.view)
        self.addChildViewController(childViewController)
        childViewController.didMove(toParentViewController: self)
        
        adaptingViewController.resizeViewsToFit(frame: containerView.frame)
        
        containerView.addSubview(childView)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = true
        childView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        childView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        childView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        childView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    // MARK: - Private functions
    
    fileprivate func setupGestureRecognizers() {
        let dissmisSideMenuSelector = #selector(SideMenuViewController.dismissSideMenu)
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: dissmisSideMenuSelector)
        swipeRecognizer.direction = .left
        swipeRecognizer.delegate = self
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    fileprivate func didSelectItem(at indexPath: IndexPath) {
        currentStyle = SegmentioStyle.allStyles[indexPath.row]
        dismissSideMenu()
    }
    
    @objc func dismissSideMenu() {
        let size = view.frame.size
        presenter?.willDismiss(sideMenu: self)
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                self.slideAnimationToPoint(CGPoint(x: -size.width, y: 0))
                self.view.backgroundColor = .clear
            },
            completion: { _ in
                self.view.isHidden = true
                self.containerView.isHidden = true
                self.sideMenuDidHide?()
            }
        )
    }
    
    fileprivate func slideAnimationToPoint(_ point: CGPoint) {
        UIView.animate(withDuration: animationDuration) {
            self.containerView.frame.origin = point
        }
    }
}


extension SideMenuViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
