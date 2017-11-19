//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

class ProfileInteractor {
    fileprivate weak var view: ProfileViewController!
    fileprivate var graphManager: GraphManager
    fileprivate var auth0Manager: Auth0Manager
    fileprivate var fbService: FacebookService
    
    init(with view: ProfileViewController, graphManager: GraphManager = GraphManager.shared, auth0Manager: Auth0Manager = Auth0Manager.shared, fbService: FacebookService = FacebookService.shared) {
        self.view = view
        self.graphManager = graphManager
        self.auth0Manager = auth0Manager
        self.fbService = fbService
    }
    
    func viewReady() {
        guard fbService.isLoggedIn else {
            view.set(viewState: .userReady(false))
            return
        }
        graphCreateUser()
    }
    
    func graphCreateUser() {
        guard graphManager.isLoggedIn else {
            view.set(viewState: .login)
            return
        }
        facebookUser()        
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

//MARK: - Unused

extension ProfileInteractor {
    func auth0SignIn() {
        if auth0Manager.isLoggedIn {
            graphLinkAccounts()
            return
        }
        view.set(viewState: .loading(true, "Signing in.", nil))
        auth0Manager.webAuth0 { [weak self] (success, error) in
            self?.view.set(viewState: .loading(false, nil, nil))
            guard let returnedError = error else {
                self?.graphLinkAccounts()
                return
            }
            self?.view.set(viewState: .error(returnedError))
        }
    }
    
    func auth0SignInUsingFacebook(tokenString: String) {
        if auth0Manager.isLoggedIn {
            graphLinkAccounts()
            return
        }
        auth0Manager.auth0LoginUsingFacebook(token: tokenString) { [weak self] (success, error) in
            guard let returnedError = error else {
                self?.graphLinkAccounts()
                return
            }
            self?.view.set(viewState: .error(returnedError))
        }
    }
    
    func graphLinkAccounts() {
        guard let token  = auth0Manager.auth0Token else {
            let signInerror = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't sign in to GraphQL."])
            view.set(viewState: .error(signInerror)) //shouldn't ever get here but hey..
            return
        }
        if graphManager.isLoggedIn {
            facebookUser()
            return
        }
        view.set(viewState: .loading(true, "Setting things up...", nil))
        graphManager.createUser(token: token, closure: { [weak self] (success, error) in
            self?.view.set(viewState: .loading(false, nil, nil))
            guard let returnedError = error else {
                self?.facebookUser()
                return
            }
            self?.view.set(viewState: .error(returnedError))
        })
    }
}
