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

class ProfileFeatureLauncher {
    
    static func configure(_ vc: ProfileViewController) {
        vc.interactor = ProfileInteractor(with: vc, permissionsManager: FacebookPermissions.shared, graphManager: GraphManager.shared)
    }
}

class ProfileViewController: UITableViewController {

    enum ViewStates {
        case profilePicture(String)
        case displayName(String)
        case buttonsStack(Bool)
        case loading(Bool, (() -> Void)?)
        case error(Error)
        case showLock(Lock?)
    }

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePictureView: FBSDKProfilePictureView!
    @IBOutlet var buttonsStack: UIStackView!
    var interactor: ProfileInteractor?
    weak var lockViewController: LockViewController?
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
        interactor?.cancelFbRequest()
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
        case .loading(let value, let completion):
            showLoading(value, completion)
        case .error(let error):
            showError(error)
        case .showLock(let lock):
            presentLock(lock)
        }
    }

    fileprivate func showLoading(_ active: Bool, _ completion: (() -> Void)?) {
        if active {
            self.present(UIAlertController.loadingAlert(), animated: true, completion: completion)
        } else {
            self.dismiss(animated: true, completion: completion)
        }
    }

    private func presentLock(_ lock: Lock?) {
        if let passedLock = lock {
            let vc = passedLock.controller
            self.present(vc, animated: true, completion:nil)
            lockViewController = vc
        } else {
            guard let presentedLockVC = lockViewController else { return }
            presentedLockVC.dismiss(animated: true, completion: nil)
        }
    }

    private func showError(_ error: Error) {
        showLoading(false, nil)
        let alert = UIAlertController(title: "Uh-oh", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class ProfileInteractor {
    private weak var view: ProfileViewController!
    private weak var lockView: LockViewController?
    private var facebookPermissions: FacebookPermissions
    private var connection: FBSDKGraphRequestConnection?
    private var graphManager: GraphManager

    init(with view: ProfileViewController, permissionsManager: FacebookPermissions, graphManager: GraphManager) {
        self.view = view
        self.facebookPermissions = permissionsManager
        self.graphManager = graphManager
    }
    
    func viewReady() {
        view.set(viewState: .buttonsStack(false))
        checkToken()
    }

    fileprivate func checkToken() {
        view.set(viewState: .loading(true, nil))
        Auth0Manager.shared.retrieveProfile { [weak self] error in
            DispatchQueue.main.async {
                self?.view.set(viewState: .loading(false, {
                    guard error == nil else {
                        self?.lock()
                        return
                    }
                }))
            }
        }
    }

    fileprivate func lock() {
        let lock = Lock
            .classic()
            .withOptions {
                $0.scope = "openid offline_access"
                $0.closable = false
                $0.autoClose = false
                //                $0.parameters = ["device":"UNIQUE_ID"]
            }
            .withStyle {
                $0.title = "Welcome to my App!"
            }
            .withConnections { connections in
                connections.social(name: "facebook", style: .Facebook)
            }
            .withOptions {
                $0.connectionScope = ["facebook": "public_profile, email, user_friends"]
            }
            .onAuth {
                guard let idToken = $0.idToken, let refreshToken = $0.refreshToken else { return }
                Auth0Manager.shared.storeTokens(idToken, refreshToken: refreshToken)
                Auth0Manager.shared.retrieveProfile { [weak self] error in
                    self?.view.set(viewState: .showLock(nil))
                    self?.setupAuthenticated()
                }
            }
            .onError {
                self.view.set(viewState: .error($0))
            }
            .onCancel
            {
                self.view.set(viewState: .showLock(nil))
            }
        view.set(viewState: .showLock(lock))
    }
    
    private func setupAuthenticated() {
        view.set(viewState: .loading(true, nil))
        facebookPermissions.refresh { [weak self] (success, error) in
            guard let returnedError = error else {
                if success {
                    self?.fetchMe()
                } else {
                    self?.view.set(viewState: .loading(false, nil))
                }
                return
            }
            self?.view.set(viewState: .error(returnedError))
        }
    }

    private func fetchMe() {
        let meRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name"])
        cancelFbRequest()
        connection = meRequest?.start(completionHandler: { [weak self] (connection, result, error) in
            guard let returnedError = error else {
                self?.view.set(viewState: .loading(false, { 
                    self?.parse(me: result ?? [:])
                    self?.view?.set(viewState: .buttonsStack(true))
                    self?.view?.set(viewState: .profilePicture("me"))
                }))
                return
            }
            self?.view.set(viewState: .error(returnedError))
        })
    }

    func cancelFbRequest() {
        if let existingConnection = connection {
            existingConnection.cancel()
        }
    }

    private func parse(me: Any) {
        if let name = JSON(me)["name"].string {
            view?.set(viewState: .displayName(name))
        }
    }
}

enum ProfileSegues {
    static let login = "Login"
}

