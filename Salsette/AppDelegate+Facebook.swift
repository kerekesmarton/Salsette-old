//
//  AppDelegate+Facebook.swift
//  Salsette
//
//  Created by Marton Kerekes on 31/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit


extension AppDelegate {
    
    func fbDidFinishLaunchingapplication(_ application: UIApplication!, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any]! = [:]) {
        _ = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        _ = FBSDKLoginButton.self
        _ = FBSDKProfilePictureView.self
    }
    
    func fbApplication(_ app: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func fbAppDidBecomeActive(_ app: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}
