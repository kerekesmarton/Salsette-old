//
//  PassThroughView.swift
//  Salsette
//
//  Created by Marton Kerekes on 27/05/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class PassThroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
