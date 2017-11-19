//
//  StoryboardHelper.swift
//  Salsette
//
//  Created by Marton Kerekes on 14/02/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

private enum Storyboards {
    static let Main = "Main"
}

private enum ViewControllers {
    static let GraphSignInViewController = "GraphCreateAccountViewController"
    
}

extension UIStoryboard {

    class func graphCreateAccountViewController() -> GraphCreateAccountViewController {
        let storyBoard = UIStoryboard(name: Storyboards.Main, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewControllers.GraphSignInViewController) as! GraphCreateAccountViewController
        return vc
    }
}
