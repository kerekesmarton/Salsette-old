//
//  Autho.swift
//  Salsette
//
//  Created by Marton Kerekes on 04/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Lock
import UIKit

class AuthoViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
                print("Obtained credentials \($0)")
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

