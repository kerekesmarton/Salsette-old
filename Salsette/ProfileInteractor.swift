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
        getFacebookUser()
    }
    
    fileprivate func getFacebookUser() {
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
    
    fileprivate func finalise(with result: Any?) {
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
            if let error = error {
                self?.view?.set(viewState: .error(error))
            } else if let url = url {
                ImageDownloader.shared.downloadImage(for: url, completion: { (image) in
                    completion(image)
                })
            } else {
                self?.view?.set(viewState: .error(NSError(with: "Something went wrong")))
            }
        }
    }
}
