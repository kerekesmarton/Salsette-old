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
    
    var token: String? {
        get {
            return KeychainStorage.shared[Keys.graphIdToken]
        }
        set {
            KeychainStorage.shared[Keys.graphIdToken] = newValue
        }
    }

    private var user: Auth0LoginMutation.Data.LoginUserWithAuth0.User?
    
    private var operation: Cancellable?

    func createUser(with token: String, closure: @escaping (Bool, Error?)->Void) {

        let input = LoginUserWithAuth0Input(idToken: token)
        operation = client.perform(mutation: Auth0LoginMutation(token: input), resultHandler: { (result, error) in
            guard let auth = result?.data?.loginUserWithAuth0,
                let newUser = auth.user else {
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
    
    func createEvent() {
        
    }
    
    func createWorkshop() {
        
    }
}
