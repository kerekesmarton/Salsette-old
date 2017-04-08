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
import Lock

extension AppDelegate {
    
    func fbDidFinishLaunchingapplication(_ application: UIApplication!, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any]! = [:]) {
        _ = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        _ = FBSDKLoginButton.self
        _ = FBSDKProfilePictureView.self
    }
    
    func fbApplication(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        _ = Lock.resumeAuth(url, options: options)
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func fbAppDidBecomeActive(_ app: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}