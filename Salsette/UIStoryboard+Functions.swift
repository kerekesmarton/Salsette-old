//
//  StoryboardHelper.swift
//  Salsette
//
//  Created by Marton Kerekes on 14/02/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static func viewController<T: UIViewController>(name: String, storyboard: String = "Main", bundle: Bundle? = nil) -> T {
        let storyBoard = UIStoryboard(name: storyboard, bundle: bundle)        
        guard let vc = storyBoard.instantiateViewController(withIdentifier: name) as? T else {
            fatalError()
        }
        return vc
        
    }
}
