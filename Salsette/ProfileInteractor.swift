//
//  ProfileInteractor.swift
//  Salsette
//
//  Created by Marton Kerekes on 21/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class ProfileInteractor {
    fileprivate weak var view: ProfileViewController!
    private var graphManager: GraphManager
    private var auth0Manager: Auth0Manager
    private var fbService: FacebookService
    
    init(with view: ProfileViewController, graphManager: GraphManager = GraphManager.shared, auth0Manager: Auth0Manager = Auth0Manager.shared, fbService: FacebookService = FacebookService.shared) {
        self.view = view
        self.graphManager = graphManager
        self.auth0Manager = auth0Manager
        self.fbService = fbService
    }
    
    func viewReady() {
        guard fbService.isLoggedIn, auth0Manager.isLoggedIn, graphManager.isLoggedIn else {
            view.set(viewState: .userReady(false))
            return
        }
        facebookLogin()        
    }
    
    func facebookLogin() {
        if let token = fbService.token {
            auth0SignIn(with: token)
        } else {
            //user needs to log in by pressing the fb login btn
            view.set(viewState: .userReady(false))
        }
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
    
    func scapholdLinkAccounts() {
        guard let token  = auth0Manager.auth0Token else {
            let signInerror = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't sign in to scaphold"])
            view.set(viewState: .error(signInerror)) //shouldn't ever get here but hey..
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
        view.set(viewState: .loading(true, "resolving user...", nil))
        fbService.getUser(from: view) { [weak self] (result, error) in
            self?.view.set(viewState: .loading(false, nil, nil))
            guard let returnedError = error else {
                self?.finalise(with: result)
                return
            }
            self?.view.set(viewState: .error(returnedError))
        }
    }
    
    private func finalise(with result: Any?) {
        guard let data = result as? [String:Any], let name = JSON(data)["name"].string  else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't get user information"])
            self.view.set(viewState: .error(error))
            return
        }
        view?.set(viewState: .displayName(name))
        view?.set(viewState: .userReady(true))
    }
    
    func loadImage(with completion: @escaping ((UIImage) -> Void)) {
        FacebookService.shared.getPicture { [weak self] (url, error) in
            guard let url = url else {
                if let error = error {
                    self?.view?.set(viewState: .error(error))
                }
                return
            }
            ImageDownloader.shared.downloadImage(for: url, completion: { (image) in
                completion(image)
            })
        }
    }
}
