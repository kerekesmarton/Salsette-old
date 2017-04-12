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

    var canLogIn: Bool {
        get {
            return (idToken != nil) ? true : false
        }
    }

    var needsSignIn: Bool {
        get {
            return (userId != nil) ? true : false
        }
    }

    var idToken: String? {
        get {
            return KeychainStorage.shared[Keys.idToken]
        }
        set {
            KeychainStorage.shared[Keys.idToken] = newValue
        }
    }

    var userId: String? {
        get {
            return KeychainStorage.shared[Keys.userId]
        }
        set {
            KeychainStorage.shared[Keys.userId] = newValue
        }
    }


    lazy var apollo: ApolloClient = {
        let graphlQLEndpointURL = "https://api.graph.cool/simple/v1/salsette"
        return ApolloClient(url: URL(string: graphlQLEndpointURL)!)
    }()

    func createUser(with idToken: String, closure: @escaping (Bool, Error?)->Void) {
        let mutation = CreateUserMutation(idToken: idToken)
        apollo.perform(mutation: mutation, resultHandler: { (result, error) in
            guard let newUser = result?.data?.createUser else {
                closure(false, error)
                print(#function, "ERROR | Could not get new user")
                return
            }
            self.idToken = idToken
            self.userId = newUser.id
            closure(true, error)
        })
    }    
}
