//
//  Permissions.swift
//  Salsette
//
//  Created by Marton Kerekes on 01/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import FBSDKLoginKit

class PermissionManager {
    
    private init() {
        self.loginManager = FBSDKLoginManager()
        loginManager.loginBehavior = .systemAccount
    }
    private var loginManager: FBSDKLoginManager
    
    static let sharedInstance: PermissionManager = PermissionManager()
    
    func askFor(permissions: [String], from vc: UIViewController, completion:@escaping (Bool, Error?)->Void) {
        
        let missingPermissions = permissions.filter {!FBSDKAccessToken.current().hasGranted($0)}
        
        if missingPermissions.count == 0 {
            completion(true, nil)
            return
        }
        
        loginManager.logIn(withReadPermissions: permissions, from: vc) { (loginResult, error) in
            
            guard let returnedError = error else {
                completion(true, nil)
                return
            }
            completion(false, returnedError)
        }
        
    }
}
