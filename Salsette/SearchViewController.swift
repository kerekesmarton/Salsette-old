//
//  ViewController.swift
//  Salsette
//
//  Created by Marton Kerekes on 08/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import ObjectiveC
import UIKit
import TextFieldEffects
import PDTSimpleCalendar

class SearchViewController: UITableViewController {

    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var dateField: HoshiTextField!
    @IBOutlet weak var locationField: HoshiTextField!
    @IBOutlet weak var typeField: HoshiTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateField.inputViewController = CalendarInputViewController()
    }
}

class CalendarInputViewController: UIInputViewController {
    
    private var calendarViewController: CalendarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarViewController = UIStoryboard.calendarViewController()
        self.view.addSubview(calendarViewController!.view)
        self.addChildViewController(calendarViewController!)
        calendarViewController!.didMove(toParentViewController: self)
    }
}

class CalendarViewController: PDTSimpleCalendarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

var AssociatedObjectHandle: UInt8 = 0
extension HoshiTextField {
    override open var inputViewController: UIInputViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? UIInputViewController
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override var inputView: UIView? {
        get {
            return inputViewController?.view
        }
        set {}
    }
    
    open override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
}
