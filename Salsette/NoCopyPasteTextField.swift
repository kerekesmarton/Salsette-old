//
//  NoCopyPasteTextField.swift
//  Salsette
//
//  Created by Marton Kerekes on 04/05/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import TextFieldEffects

class NoCopyPasteTextField: HoshiTextField {
    var showsCursor: Bool {
        get {
            return false
        }
    }

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return showsCursor
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        return showsCursor ? super.caretRect(for: position) : CGRect.zero
    }
}

