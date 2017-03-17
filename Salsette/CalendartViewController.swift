//
//  CalendartViewController.swift
//  Salsette
//
//  Created by Marton Kerekes on 12/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import ChameleonFramework
import FSCalendar

protocol CalendarViewControllerInteractor: class {
    func calendarViewController(_ controller: CalendarViewController, shouldSelect date: Date, from selectedDates: [Date]) -> Bool
    func calendarViewController(_ controller: CalendarViewController,didSelect date: Date)
    func calendarViewController(shouldDeselect date: Date, from selectedDates: [Date]) -> Bool
    func calendarViewController(didDeselect date: Date)
}

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var interactor: CalendarViewControllerInteractor?
    
    @IBOutlet fileprivate weak var calendar: FSCalendar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose dates when you visit"
        // Uncomment this to perform an 'initial-week-scope'
        // calendar.scope = FSCalendarScopeWeek;
        setup()
//        let dates = [
//            gregorian.date(byAdding: .day, value: -1, to: Date()),
//            Date(),
//            gregorian.date(byAdding: .day, value: 1, to: Date())
//        ]
//        dates.forEach { (date) in
//            calendar.select(date, scrollToDate: false)
//        }
        // For UITest
        calendar.accessibilityIdentifier = "calendar"
    }
    
    fileprivate func setup() {
        calendar.allowsMultipleSelection = true
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.today = nil // Hide the today circle
        calendar.register(CalendarViewCell.self, forCellReuseIdentifier: "cell")
        //        calendar.clipsToBounds = true // Remove top/bottom line
        
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
    }
    
    func markSelectedBetween(startDate: Date, endDate: Date) {
        
        var date = startDate
        while (date < endDate) {
            date = gregorian.date(byAdding: .day, value: 1, to: date)!
            calendar.select(date, scrollToDate: false)
        }
    }
    
    func deselectAll() {
        calendar.selectedDates.forEach { calendar.deselect($0) }
        configureVisibleCells()
    }
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        if gregorian.isDateInToday(date) {
//            return "😀"
//        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame.size.height = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        guard let interactor = interactor else {
            return monthPosition == .current
        }
        return interactor.calendarViewController(self, shouldSelect: date, from: calendar.selectedDates)
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        guard let interactor = interactor else {
            return monthPosition == .current
        }
        return interactor.calendarViewController(shouldDeselect: date, from: calendar.selectedDates)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let interactor = interactor {
            interactor.calendarViewController(self, didSelect: date)
        }
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        if let interactor = interactor {
            interactor.calendarViewController(didDeselect: date)
        }
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    // MARK: - Private functions
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            configure(cell: cell, for: date, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let cell = (cell as! CalendarViewCell)
        // Custom today circle
        cell.circleImageView.isHidden = !gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current {
            
            var selectionType = CellSelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                cell.selectionLayer.isHidden = true
                return
            }
            cell.selectionLayer.isHidden = false
            cell.selectionType = selectionType
            
        } else {
            cell.circleImageView.isHidden = true
            cell.selectionLayer.isHidden = true
        }
    }
    
}

enum CellSelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class CalendarViewCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    
    var selectionType: CellSelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let circleImageView = UIImageView(image: UIImage(named: "circle")!)
        contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.black.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        contentView.layer.insertSublayer(selectionLayer, below: titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        shapeLayer.isHidden = true
        
        let view = UIView(frame: bounds)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        backgroundView = view;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImageView.frame = contentView.bounds
        backgroundView?.frame = bounds.insetBy(dx: 1, dy: 1)
        selectionLayer.frame = contentView.bounds
        
        if selectionType == .middle {
            selectionLayer.path = UIBezierPath(rect: selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            selectionLayer.path = UIBezierPath(roundedRect: selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: selectionLayer.frame.width / 2, height: selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            selectionLayer.path = UIBezierPath(roundedRect: selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: selectionLayer.frame.width / 2, height: selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(selectionLayer.frame.height, selectionLayer.frame.width)
            selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: contentView.frame.width / 2 - diameter / 2, y: contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
//        if self.isPlaceholder {
            eventIndicator.isHidden = true
            titleLabel.textColor = UIColor.lightGray
//        }
    }
    
}

