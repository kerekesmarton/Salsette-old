//
//  InputAccessoryView.swift
//  Salsette
//
//  Created by Marton Kerekes on 27/05/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class InputAccessoryView: PassThroughView {
    
    class func create(next: @escaping ((UIButton)-> Void),
                      previous: @escaping ((UIButton)-> Void),
                      cancel: @escaping ((UIButton)-> Void)) -> InputAccessoryView
    {
        let iav = UINib(nibName: "InputAccessoryView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! InputAccessoryView
        iav.cancelAction = cancel
        iav.nextAction = next
        iav.prevAction = previous
        return iav
    }
    
    @IBOutlet private var nextBtn: UIButton?
    private var nextAction: ((UIButton)-> Void)?
    @IBAction private func performNextAction(sender: UIButton?) {
        if let action = nextAction, let btn = sender {
            action(btn)
        }
    }
    
    @IBOutlet private var previousBtn: UIButton?
    private var prevAction: ((UIButton)-> Void)?
    @IBAction private func performPrevAction(sender: UIButton?) {
        if let action = prevAction, let btn = sender {
            action(btn)
        }
    }
    
    @IBOutlet private var cancelBtn: UIButton?
    private var cancelAction: ((UIButton)-> Void)?
    @IBAction private func performCancelAction(sender: UIButton?) {
        if let action = cancelAction, let btn = sender {
            action(btn)
        }
    }
}
