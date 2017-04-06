//
//  Profile.swift
//  Salsette
//
//  Created by Marton Kerekes on 31/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Lock
//import Apollo
//import Auth0

class ProfileFeatureLauncher {
    
    static func configure(_ vc: ProfileViewController) {
        vc.interactor = ProfileInteractor(with: vc, permissionsManager: PermissionManager.shared, userManager: UserManager.shared)
    }
}

class ProfileViewController: UITableViewController {

    enum ViewStates {
        case profilePicture(String)
        case displayName(String)
        case buttonsStack(Bool)
    }

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePictureView: FBSDKProfilePictureView!
    @IBOutlet var buttonsStack: UIStackView!
    var interactor: ProfileInteractor?
    override func awakeFromNib() {
        super.awakeFromNib()
        ProfileFeatureLauncher.configure(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.viewReady()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.cancel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ProfileSegues.login {
            //
        }
    }
    
    func set(viewState: ViewStates) {
        switch viewState {
        case .profilePicture(let pictureIdentifier):
            profilePictureView.profileID = pictureIdentifier
        case .displayName(let displayName):
            nameLbl.text = displayName
        case .buttonsStack(let show):
            buttonsStack.isHidden = !show
        }
    }
}

class ProfileInteractor {
    private weak var view: ProfileViewController?
    private var permissionManager: PermissionManager
    private var connection: FBSDKGraphRequestConnection?
    private var userManager: UserManager

    init(with view: ProfileViewController, permissionsManager: PermissionManager, userManager: UserManager) {
        self.view = view
        self.permissionManager = permissionsManager
        self.userManager = userManager
    }
    
    func viewReady() {
        guard userManager.needsSignIn else {
            setupNeedsCreateUser()
            return
        }
        guard userManager.isLoggedIn else {
            setupNeedsLogin()
            return
        }
        setupAuthenticated()        
    }
    
    func cancel() {
        if let existingConnection = connection {
            existingConnection.cancel()
        }
    }

    private func setupAuthenticated() {
        view?.set(viewState: .profilePicture("me"))
    }

    private func setupNeedsCreateUser() {
        let lock = userManager.lock(with: {
            self.userManager.createUser(with: $0, closure: self.handle)
        })
        guard let view = view else {
            return
        }
        view.set(viewState: .buttonsStack(false))
        lock.present(from: view)
    }

    private func setupNeedsLogin() {
        userManager.signIn(closure: handle)
    }


    private func fetchMe() {
        let meRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name"])
        cancel()
        connection = meRequest?.start(completionHandler: { [weak self] (connection, result, error) in
            guard let error = error else {
                self?.parse(me: result ?? [:])
                self?.view?.set(viewState: .buttonsStack(true))
                return
            }
            self?.handle(error)
        })
    }
    
    private func parse(me: Any) {
        if let name = JSON(me)["name"].string {
            view?.set(viewState: .displayName(name))
        }
    }

    private func handle(_ success: Bool, _ error: Error?) -> Void {
        guard let returnedError = error else {
            if success {
                self.fetchMe()
            }
            return
        }
        handle(returnedError)
    }

    private func handle(_ error: Error) {
        print(error)
    }
}

enum ProfileSegues {
    static let login = "Login"
}

