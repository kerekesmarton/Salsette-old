//
//  Profile.swift
//  Salsette
//
//  Created by Marton Kerekes on 31/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CircleMenu

class ProfileFeatureLauncher {
    
    static func configure(_ vc: ProfileViewController) {
        vc.interactor = ProfileInteractor(with: vc, manager: PermissionManager.sharedInstance)
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
    @IBOutlet var loginBtn: FBSDKLoginButton!
    @IBOutlet var buttonsStack: UIStackView!
    var interactor: ProfileInteractor?
    override func awakeFromNib() {
        super.awakeFromNib()
        ProfileFeatureLauncher.configure(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginBtn.delegate = self
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
    
    @IBAction func loginTapped(_ sender: Any) {
        interactor?.login(with: self)
    }
    
    func set(viewState: ViewStates) {
        switch viewState {
        case .profilePicture(let pictureIdentifier):
            profilePictureView.profileID = pictureIdentifier
        case .displayName(let displayName):
            nameLbl.text = displayName
        case .buttonsStack(let show):
            buttonsStack.isHidden = !show
        default:
            ()
        }
    }
    
    func performSegue(withIdentifier identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
    }
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        interactor?.viewReady()
    }
}

class ProfileInteractor {
    private weak var view: ProfileViewController?
    private var permissionManager: PermissionManager
    private var connection: FBSDKGraphRequestConnection?
    init(with view: ProfileViewController, manager: PermissionManager) {
        self.view = view
        self.permissionManager = manager
    }
    
    func viewReady() {
        if FBSDKAccessToken.current() != nil {
            view?.set(viewState: .profilePicture("me"))
            fetchMe()
        } else {
            view?.set(viewState: .buttonsStack(false))
        }
    }
    
    func cancel() {
        if let existingConnection = connection {
            existingConnection.cancel()
        }
    }
    
    func login(with vc: UIViewController) {        
        permissionManager.askFor(permissions: ["public_profile", "email", "user_friends"], from: vc, completion: { (result, error) in
            if let  error = error {
                print(error)
            }
        })
    }
    
    private func fetchMe() {
        let meRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        cancel()
        connection = FBSDKGraphRequestConnection()
        connection?.add(meRequest, completionHandler: { [weak self] (connection, result, error) in
            guard let error = error else {
                self?.parse(me: result ?? [:])
                self?.view?.set(viewState: .buttonsStack(true))
                return
            }
            print(error)
        })
        connection?.start()
    }
    
    func parse(me: Any) {
        guard let result = me as? [String: Any], let name = result["name"] as? String else {
            return
        }
        view?.set(viewState: .displayName(name))
    }
    
}

enum ProfileSegues {
    static let login = "Login"
}

