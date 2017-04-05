//
//  Autho.swift
//  Salsette
//
//  Created by Marton Kerekes on 04/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Lock
import UIKit
import Apollo

class AuthoViewController: UIViewController {

    override func viewDidLoad() {
        Lock
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
                $0.connectionScope = ["facebook": "user_friends,email"]
            }
            .onAuth {
                guard let idToken = $0.idToken else {
                    return
                }
                let graphlQLEndpointURL = "https://api.graph.cool/simple/v1/salsette"
                let apollo = ApolloClient(url: URL(string: graphlQLEndpointURL)!)
                let mutation = CreateUserMutation(idToken: idToken)
                apollo.perform(mutation: mutation, resultHandler: { (result, error) in
                    if let error = error {
                        print(error)
                    }
                    guard let newUser = result?.data?.createUser else {
                        print(#function, "ERROR | Could not get the new user")
                        return
                    }
                    print("Created new user: \(newUser)")
                })
            }
            .onError {
                print("Failed with \($0)")
            }
            .onCancel {
                print("User cancelled")
            }
            .present(from: self)
    }
}

