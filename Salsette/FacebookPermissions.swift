//
//  Permissions.swift
//  Salsette
//
//  Created by Marton Kerekes on 01/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import FBSDKLoginKit

class FacebookPermissions {
    
    private init() {
        self.loginManager = FBSDKLoginManager()
        loginManager.loginBehavior = .systemAccount
    }
    private var loginManager: FBSDKLoginManager
    
    static let shared: FacebookPermissions = FacebookPermissions()

    func refresh(with completion:@escaping (Bool, Error?)->Void) {

        guard let savedToken = token else {
            completion(false,nil)
            return
        }
        let accessToken = FBSDKAccessToken(
            tokenString: savedToken,
            permissions: permissions ?? ["user_profile"],
            declinedPermissions: declinedPermissions ?? [],
            appID: "com.mk.Salsette",
            userID: userID,
            expirationDate: expirationDate,
            refreshDate: refreshDate
        )

        FBSDKAccessToken.setCurrent(accessToken)
        completion(true,nil)
    }
    
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

extension FacebookPermissions {

    var declinedPermissions: [String]? {
        get {
            return UserDefaults.standard.value(forKey: FBKeys.declinedPermissions) as? [String]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: FBKeys.declinedPermissions)
        }
    }

    var expirationDate: Date? {
        get {
            return UserDefaults.standard.value(forKey: FBKeys.expirationDate) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: FBKeys.expirationDate)
        }
    }

    var token: String? {
        get {
            return KeychainStorage.shared[FBKeys.fbAccessToken]
        }
        set {
            KeychainStorage.shared[FBKeys.fbAccessToken] = newValue
        }
    }

    var permissions: [String]? {
        get {
            return UserDefaults.standard.value(forKey: FBKeys.permissions) as? [String]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: FBKeys.permissions)
        }
    }

    var refreshDate: Date? {
        get {
            return UserDefaults.standard.value(forKey: FBKeys.refreshDate) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: FBKeys.refreshDate)
        }
    }

    var userID: String? {
        get {
            return KeychainStorage.shared[FBKeys.userID]
        }
        set {
            KeychainStorage.shared[FBKeys.userID] = newValue
        }
    }
}
