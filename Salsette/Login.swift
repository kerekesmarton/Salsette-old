//
//  Login.swift
//  Salsette
//
//  Created by Marton Kerekes on 31/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var loginBtn: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.readPermissions = ["public_profile", "email", "user_friends"];
    }
    
//    @IBAction func loginTapped(_ sender: Any) {
//    
//    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
