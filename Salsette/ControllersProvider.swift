//
//  ControllersProvider.swift
//  ColorMatchTabs
//
//  Created by anna on 6/15/16.
//  Modified by Kerekes Marton
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import ColorMatchTabs

class StubContentViewControllersProvider {
    
    static let viewControllers: [UIViewController] = {
        let classesViewController = WorkshopFeatureLauncher.launch(with: "Classes")
        let partiesViewController = EventFeatureLauncher.launch(with: "Events")
        
        return [classesViewController, partiesViewController]
    }()

}
