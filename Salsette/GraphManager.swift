//
//  User.swift
//  Salsette
//
//  Created by Marton Kerekes on 05/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Foundation
import Apollo

class GraphManager {
    private  init() {}
    static let shared = GraphManager()
    
    lazy var client: ApolloClient = {
        return ApolloClient(url: URL(string: "https://eu-west-1.api.scaphold.io/graphql/dance")!)
    }()

    var isLoggedIn: Bool {
        get {
            return (token != nil) ? true : false
        }
    }

    private var user: LoginMutation.Data.LoginUserWithAuth0Social.User?
    
    private var operation: Cancellable?

    func createUser(with token: String, closure: @escaping (Bool, Error?)->Void) {
        let input = LoginUserWithAuth0SocialInput(accessToken: token, connection: .facebook)
        operation = client.perform(mutation: LoginMutation(token: input), resultHandler: { (result, error) in
            guard let auth = result?.data?.loginUserWithAuth0Social,
                let newUser = auth.user,
                let token = auth.token else {
                closure(false, error)
                return
            }
            if let serverError = result?.errors {
                closure(false,serverError.first)
            } else {
                self.token = token
                self.user = newUser
                closure(true, error)                
            }
        })
    }
}


extension GraphManager {
    var token: String? {
        get {
            return KeychainStorage.shared[Keys.graphIdToken]
        }
        set {
            KeychainStorage.shared[Keys.graphIdToken] = newValue
        }
    }
}
