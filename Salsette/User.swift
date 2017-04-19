//
//  Profile.swift
//  Salsette
//
//  Created by Marton Kerekes on 31/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Auth0

class ProfileFeatureLauncher {
    
    static func configure(_ vc: ProfileViewController) {
        vc.interactor = ProfileInteractor(with: vc, graphManager: GraphManager.shared, auth0Manager: Auth0Manager.shared)
    }
}

class ProfileViewController: UITableViewController {

    enum ViewStates {
        case profilePicture(String)
        case displayName(String)
        case buttonsStack(Bool)
        case loading(Bool, String?, (() -> Void)?)
        case error(Error)
    }

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePictureView: FBSDKProfilePictureView!
    @IBOutlet var loginBtn: FBSDKLoginButton!
    @IBOutlet var buttonsStack: UIStackView!
    var interactor: ProfileInteractor?
    override func awakeFromNib() {
        super.awakeFromNib()
        ProfileFeatureLauncher.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.loginBehavior = .systemAccount
        loginBtn.readPermissions = ["public_profile", "email", "user_friends", "user_events"]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(deleteKeychain))
    }

    func deleteKeychain() {
        KeychainStorage.shared.clear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.viewReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.cancelFbRequest()
    }
    
    func set(viewState: ViewStates) {
        switch viewState {
        case .profilePicture(let pictureIdentifier):
            profilePictureView.profileID = pictureIdentifier
        case .displayName(let displayName):
            nameLbl.text = displayName
        case .buttonsStack(let show):
            buttonsStack.isHidden = !show
        case .loading(let value, let message, let completion):
            showLoading(value, message, completion)
        case .error(let error):
            showError(error)
        }
    }

    fileprivate func showLoading(_ active: Bool, _ message: String?, _ completion: (() -> Void)?) {
        if active {
            self.present(UIAlertController.loadingAlert(with: message), animated: false, completion: completion)
        } else {
            self.dismiss(animated: false, completion: completion)
        }
    }

    private func showError(_ error: Error) {
        showLoading(false, nil, nil)
        self.present(UIAlertController.errorAlert(with: error), animated: false, completion: nil)
    }
}

class ProfileInteractor {
    fileprivate weak var view: ProfileViewController!
    private var connection: FBSDKGraphRequestConnection?
    private var graphManager: GraphManager
    private var auth0Manager: Auth0Manager
    
    init(with view: ProfileViewController, graphManager: GraphManager, auth0Manager: Auth0Manager) {
        self.view = view
        self.graphManager = graphManager
        self.auth0Manager = auth0Manager
    }
    
    func viewReady() {
        facebookLogin()
    }
    
    func facebookLogin() {
        if let token = FBSDKAccessToken.current() {
            auth0SignIn(with: token.tokenString)
        } else {
            //user needs to log in by pressing the fb login btn
            view?.set(viewState: .buttonsStack(false))
        }
    }
    
    func scapholdLinkAccounts() {
        guard let token  = auth0Manager.auth0Token else {
            let signInerror = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't sign in to scaphold"])
            view.set(viewState: .error(signInerror))
            return
        }
        if graphManager.isLoggedIn {
            facebookUser()
            return
        }
        view.set(viewState: .loading(true, "linking account...", nil))
        graphManager.createUser(with: token, closure: { [weak self] (success, error) in
            self?.view.set(viewState: .loading(false, nil, nil))
            guard let returnedError = error else {
                self?.facebookUser()
                return
            }
            self?.view.set(viewState: .error(returnedError))
        })
    }

    fileprivate func facebookUser() {
        let meRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name"])
        cancelFbRequest()
        view.set(viewState: .loading(true, "resolving user...", nil))
        connection = meRequest?.start(completionHandler: { [weak self] (connection, result, error) in
            self?.view.set(viewState: .loading(false, nil, nil))
            guard let returnedError = error else {
                self?.finalise(with: result)
                return
            }
            self?.view.set(viewState: .error(returnedError))
        })
    }
    
    func auth0SignIn(with tokenString: String) {
        if auth0Manager.isLoggedIn {
            scapholdLinkAccounts()
            return
        }
        view.set(viewState: .loading(true, "signing in...", nil))
        auth0Manager.auth0LoginUsingFacebook(token: tokenString) { [weak self] (success, error) in
            self?.view.set(viewState: .loading(false, nil, nil))
            guard let returnedError = error else {
                self?.scapholdLinkAccounts()
                return
            }
            self?.view.set(viewState: .error(returnedError))
        }
    }

    func cancelFbRequest() {
        if let existingConnection = connection {
            existingConnection.cancel()
        }
    }

    private func finalise(with result: Any?) {
        parse(me: result)
        view?.set(viewState: .buttonsStack(true))
        view?.set(viewState: .profilePicture("me"))
    }

    private func parse(me: Any?) {
        guard let data = me as? [String:Any], let name = JSON(data)["name"].string  else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't get user information"])
            self.view.set(viewState: .error(error))
            return
        }
        view?.set(viewState: .displayName(name))
    }
}
