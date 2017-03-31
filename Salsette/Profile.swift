//
//  Profile.swift
//  Salsette
//
//  Created by Marton Kerekes on 31/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileFeatureLauncher {
    
    static func configure(_ vc: ProfileViewController) {
        
        vc.interactor = ProfileInteractor(with: ProfilePresenter(with: vc))
    }
}

protocol ProfileView: class {
    func performSegue(withIdentifier identifier: String)
}

class ProfileViewController: UIViewController {
    
    var interactor: ProfileInteractor?
    override func awakeFromNib() {
        super.awakeFromNib()
        ProfileFeatureLauncher.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewReady()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ProfileSegues.login {
            //
        }
    }
}

extension ProfileViewController: ProfileView {
 
    func performSegue(withIdentifier identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
    }
}

class ProfileInteractor {
    var presenter: ProfilePresenter
    
    init(with presenter: ProfilePresenter) {
        self.presenter = presenter
    }
    
    func viewReady() {
        if FBSDKAccessToken.current() == nil {
            DispatchQueue.main.async { [weak self] in
                self?.presenter.presentLogin()
            }
        }
    }
}

class ProfilePresenter {
    weak var view: ProfileView?
    
    init(with view: ProfileView) {
        self.view = view
    }
    
    func presentLogin() {
        view?.performSegue(withIdentifier: ProfileSegues.login)
    }
}

enum ProfileSegues {
    static let login = "Login"
}

