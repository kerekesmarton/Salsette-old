//
//  AppDelegate+Facebook.swift
//  Salsette
//
//  Created by Marton Kerekes on 31/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Foundation
import FBSDKCoreKit

extension AppDelegate {
    
    func fbDidFinishLaunchingapplication(_ application: UIApplication!, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any]! = [:]) {
        _ = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func fbApplication(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
     
        guard let appKey = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            let annotationKey = options[UIApplicationOpenURLOptionsKey.annotation] as? String else { return false }
        
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: appKey, annotation: annotationKey)
    }
    
    func fbAppDidBecomeActive(_ app: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}
