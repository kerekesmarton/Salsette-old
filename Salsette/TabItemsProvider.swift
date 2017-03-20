//
//  TabItemsProvider.swift
//  ColorMatchTabs
//
//  Created by Sergey Butenko on 9/6/16.
//  Modified by Kerekes Marton
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import ColorMatchTabs

class TabItemsProvider {
    
    static let items = {
        return [
            classesTabItem,
            partiesTabItem
        ]
    }()
    
    fileprivate static let classesTabItem = TabItem(title: "Classes",
                                                    tintColor: UIColor.flatRed,
                                                    normalImage: UIImage(named: "products_normal")!,
                                                    highlightedImage: UIImage(named: "products_highlighted")!)
    
    fileprivate static let partiesTabItem = TabItem(title: "Parties",
                                                    tintColor: UIColor.flatGreen,
                                                    normalImage: UIImage(named: "venues_normal")!,
                                                    highlightedImage: UIImage(named: "venues_highlighted")!)
}
