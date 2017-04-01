//
//  Profile.swift
//  Salsette
//
//  Created by Marton Kerekes on 31/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import DZNEmptyDataSet

class ProfileFeatureLauncher {
    
    static func configure(_ vc: ProfileViewController) {
        vc.interactor = ProfileInteractor(with: ProfilePresenter(with: vc), fbManager: FBSDKLoginManager())
    }
}

class ProfileViewController: UITableViewController {
    enum ViewStates {
        case profilePicture(String)
        case displayName(String)
    }
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePictureView: FBSDKProfilePictureView!
    @IBOutlet var loginBtn: FBSDKLoginButton!
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
    
    @IBAction func loginTapped(_ sender: Any) {
        interactor?.login(with: self)
    }
    
    func set(viewState: ViewStates) {
        switch viewState {
        case .profilePicture(let pictureIdentifier):
            profilePictureView.profileID = pictureIdentifier
        case .displayName(let displayName):
            nameLbl.text = displayName
        default:
            ()
        }
    }
    
    func performSegue(withIdentifier identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
    }
}

class ProfileInteractor {
    private var presenter: ProfilePresenter
    private var fbManager: FBSDKLoginManager
    private var connection: FBSDKGraphRequestConnection?
    init(with presenter: ProfilePresenter, fbManager: FBSDKLoginManager) {
        self.presenter = presenter
        self.fbManager = fbManager
    }
    
    func viewReady() {
        if FBSDKAccessToken.current() != nil {
            presenter.setupProfile(pictureId: "me")
            fetchMe()
        }
    }
    
    func cancel() {
    }
    
    func login(with vc: UIViewController) {
        fbManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: vc) { (result, error) in
            if let  error = error {
                print(error)
            } else if let canceled = result?.isCancelled {
                print("login cancelled: \(canceled)")
            } else {
                print("good")
            }
        }
    }
    private func fetchMe() {
        let meRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        if let existingConnection = connection {
            existingConnection.cancel()
        }
        connection = meRequest?.start(completionHandler: { [weak self] (connection, result, error) in
            guard let error = error else {
                self?.parse(me: result ?? [:])
                return
            }
            print(error)
        })
    }
    
    func parse(me: Any) {
        guard let result = me as? [String: Any], let name = result["name"] as? String else {
            return
        }
        presenter.setupProfile(name: name)
    }
    
}

class ProfilePresenter {
    private weak var view: ProfileViewController?
    
    init(with view: ProfileViewController) {
        self.view = view
    }
    
    func setupProfile(pictureId: String) {
        view?.set(viewState: .profilePicture("me"))
    }
    
    func setupProfile(name: String) {
        view?.set(viewState: .displayName(name))
    }
}

enum ProfileSegues {
    static let login = "Login"
}

