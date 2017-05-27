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
import Hero

class ProfileFeatureLauncher {
    
    static func configure(_ vc: ProfileViewController) {
        vc.interactor = ProfileInteractor(with: vc)
    }
}

class ProfileViewController: UITableViewController {

    enum ViewStates {
        case profilePicture(String)
        case displayName(String)
        case loading(Bool, String?, (() -> Void)?)
        case error(Error)
        case userReady(Bool)
    }

    @IBOutlet var loginBtn: FBSDKLoginButton!
    @IBOutlet var loginView: UIView!
    var interactor: ProfileInteractor?
    override func awakeFromNib() {
        super.awakeFromNib()
        ProfileFeatureLauncher.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatWhite
        loginBtn.loginBehavior = .systemAccount
        loginBtn.delegate = self
        loginBtn.readPermissions = ["public_profile", "email", "user_friends", "user_events"]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(deleteKeychain))
    }

    func deleteKeychain() {
        KeychainStorage.shared.clear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.prepareView()
//        set(viewState: .userReady(true))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.viewReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func set(viewState: ViewStates) {
        switch viewState {
        case .profilePicture(let pictureIdentifier):
            self.pictureIdentifier = pictureIdentifier
        case .displayName(let displayName):
            self.displayName = displayName
        case .loading(let value, let message, let completion):
            showLoading(value, message, completion)
        case .error(let error):
            showError(error)
        case .userReady(let isReady):
            userIsReady = isReady
            tableView.reloadData()
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

    fileprivate var userIsReady: Bool = false
    fileprivate var displayName: String?
    fileprivate var pictureIdentifier: String?
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        interactor?.prepareView()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        interactor?.prepareView()
    }

}

extension ProfileViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIsReady ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 270
        case 1:
            return 60
        case 2:
            return 150
        default:
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCellIdentifiers.allIdentifiers[indexPath.row])!
        cell.heroModifiers = [.fade, .translate(y:20)]
        switch indexPath.row {
        case 0:
            guard let imageCell = cell as? UserImageCell else { return cell }
            imageCell.profilePictureView?.profileID = pictureIdentifier
        case 1:
            guard let nameCell = cell as? UserNameCell else { return cell }
            nameCell.userNameLabel?.text = displayName
        case 2:
            guard let eventsCell = cell as? UserEventsCreationCell else { return cell }
            eventsCell.configure(with: self, selection: { (eventEntity) in
//                let createEventVC = UIStoryboard.createEventViewController()
//                createEventVC.item = eventEntity
//                self?.navigationController?.pushViewController(createEventVC, animated: true)
            })
        default:
            ()
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UserEventCollectionViewCell, let vc = segue.destination as? CreateEventViewController {
            vc.item = cell.item
        }
    }
}
