//
//  CalendartViewController.swift
//  Salsette
//
//  Created by Marton Kerekes on 12/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import PDTSimpleCalendar
import ChameleonFramework

private let cellIdentifier = "com.producteev.collection.cell.identifier"

class CalendarViewController: PDTSimpleCalendarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(CalendarViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}

class CalendarViewCell: PDTSimpleCalendarViewCell {
    
    override var circleDefaultColor: UIColor! {
        get {
            return UIColor.clear
        }
        set {}
    }
    
    override var circleTodayColor: UIColor! {
        get {
            return UIColor.flatRed
        }
        set {}
    }
    
    override var circleSelectedColor: UIColor!  {
        get {
            return UIColor.flatForestGreen
        }
        set {}
    }
    
    override var textDefaultColor: UIColor!  {
        get {
            return UIColor.flatGray
        }
        set {}
    }
    
    override var textTodayColor: UIColor!  {
        get {
            return UIColor.flatBlack
        }
        set {}
    }
    
    override var textSelectedColor: UIColor! {
        get {
            return UIColor.flatBlack
        }
        set {}
    }
}

