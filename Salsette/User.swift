//
//  User.swift
//  Salsette
//
//  Created by Marton Kerekes on 05/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Foundation
import Auth0
import Apollo
import Lock

class UserManager {
    private  init() {}
    static let shared = UserManager()

    var needsSignIn: Bool {
        get {
            return (userId != nil) ? true : false
        }
    }

    var isLoggedIn: Bool {
        get {
            return (idToken != nil) ? true : false
        }
    }

    var userId: String? {
        get {
            return UserDefaults.standard.value(forKey: "userID") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userID")
        }
    }

    var idToken: String? {
        get {
            return UserDefaults.standard.value(forKey: "idToken") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "idToken")
        }
    }

    lazy var apollo: ApolloClient = {
        let graphlQLEndpointURL = "https://api.graph.cool/simple/v1/salsette"
        return ApolloClient(url: URL(string: graphlQLEndpointURL)!)
    }()

    func createUser(with credentials: Credentials, closure: @escaping (Bool, Error?)->Void) {
        guard let idToken = credentials.idToken else {
            return
        }
        let mutation = CreateUserMutation(idToken: idToken)
        apollo.perform(mutation: mutation, resultHandler: { (result, error) in
            guard let newUser = result?.data?.createUser else {
                closure(false, error)
                print(#function, "ERROR | Could not get new user")
                return
            }
            self.userId = newUser.id
            self.signIn(closure: closure)
        })
    }

    func signIn(closure: @escaping (Bool, Error?)->Void){
        let mutation = SingInUserMutation(idToken: idToken!)
        apollo.perform(mutation: mutation, resultHandler: { (result, error) in
            guard let token = result?.data?.signinUser.token else {
                closure(false, error)
                print(#function, "ERROR | Could not retrieve token")
                return
            }
            closure(true, error)
            self.idToken = token
        })
    }

    func lock(with callback: @escaping (Credentials) -> Void) -> Lock {

        return Lock
            .classic()
            .withOptions {
                $0.closable = false
            }
            .withStyle {
                $0.title = "Welcome to my App!"
            }
            .withConnections { connections in
                connections.social(name: "facebook", style: .Facebook)
            }
            .withOptions {
                $0.connectionScope = ["facebook": "public_profile, email, user_friends"]
            }
            .onAuth {
                callback($0)
            }
            .onError {
                print("Failed with \($0)")
            }
            .onCancel {
                print("User cancelled")
        }            
    }
    
}
