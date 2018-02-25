//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

class PickerLabel: UILabel {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    private var privateInputView: UIView?
    override var inputView: UIView? {
        get {
            return privateInputView
        }
        set {
            privateInputView = newValue
        }
    }
    
    private var privateInputAccessoryView: UIView?
    override var inputAccessoryView: UIView? {
        get {
            return privateInputAccessoryView
        }
        set {
            privateInputAccessoryView = newValue
        }
    }
}

