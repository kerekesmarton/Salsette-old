//
//  CreateEvents.swift
//  Salsette
//
//  Created by Marton Kerekes on 01/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import CircleMenu
import FBSDKCoreKit

private struct CreateEventFeatureLauncher {
    
    static func configure(viewController: CreateEventViewController) {
        viewController.interactor = CreateEventInteractor(with: viewController, manager: PermissionManager.sharedInstance)
    }
}

class CreateEventViewController: UITableViewController {
    private static let cellId = "CreateEventCell"
    fileprivate var interactor: CreateEventInteractor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CreateEventFeatureLauncher.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.ready()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.cancel()
    }
}

extension CreateEventViewController: CircleMenuDelegate {
    @objc func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        
    }
}

class CreateEventInteractor {
    private weak var view: CreateEventViewController?
    private var permissionManager: PermissionManager
    private var connection: FBSDKGraphRequestConnection?
   
    init(with view: CreateEventViewController, manager: PermissionManager) {
        self.view = view
        self.permissionManager = manager
    }
    
    func ready() {
        permissionManager.askFor(permissions: ["user_events"], from: view!, completion: { [weak self] (result, error) in
            if let  error = error {
                print(error)
            }
            let request = FBSDKGraphRequest(graphPath: "me/events", parameters: ["fields":"id,name"])
            self?.connection = request?.start(completionHandler: { [weak self] (connection, result, error) in
                guard let error = error else {
                    self?.parseEvents(result)
                    return
                }
                print(error)
            })
        })
        
    }
    
    func cancel() {
        if let existingConnection = connection {
            existingConnection.cancel()
        }
    }
    
    private func parseEvents(_ results: Any?) {
        guard let parseableResults = results as? [String: Any],
            let events = parseableResults["data"] as? [Any] else {
                print(results ?? "no results")
                return
        }
        print(events)
        
    }
}

class CreateEventCell: UITableViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var metaLabel: UILabel!
}
