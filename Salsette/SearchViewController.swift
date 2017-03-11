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
import ChameleonFramework

struct SearchFeatureLauncher {

    static func setupSearch(viewController: SearchViewController) {
        
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter)
        viewController.searchInteractor = interactor
        presenter.searchView = viewController
    }
}

class SearchViewController: UITableViewController {

    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var dateField: HoshiTextField!
    @IBOutlet weak var locationField: HoshiTextField!
    @IBOutlet weak var typeField: HoshiTextField!
    var calendarViewController: CalendarViewController?
    var calendarView: UIView {
        calendarViewController = CalendarViewController(nibName: "keyboard", bundle: nil)
        calendarViewController?.delegate = searchInteractor
        return calendarViewController!.view
    }
    
    var searchInteractor: SearchInteractor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SearchFeatureLauncher.setupSearch(viewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateField.inputView = calendarView
    }
}

extension SearchViewController {
    
    enum SearchViewModel {
        case name(String)
        case dates(String)
        case location(String)
        case typde(String)
    }
    
    func set(_ viewModel: SearchViewModel) {
     
        switch viewModel {
        case .dates(let dateString):
            dateField.text = dateString
            calendarViewController?.collectionView?.reloadData()
        default:
            return
        }
    }
}

class SearchInteractor: NSObject, PDTSimpleCalendarViewDelegate {
    let searchPresenter: SearchPresenter
    
    init(presenter: SearchPresenter) {
        self.searchPresenter = presenter
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date!) {
        if startDate == nil {
            startDate = date
            searchPresenter.update(startDate: date)
        } else if endDate == nil {
            endDate = date
            searchPresenter.update(startDate: startDate, endDate: date)
        } else {
            startDate = date
            searchPresenter.update(startDate: date)
            endDate = nil
        }
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, textColorFor date: Date!) -> UIColor! {
        if date == startDate || date == endDate {
            return UIColor.flatBlack
        }
        return UIColor.flatGray
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, circleColorFor date: Date!) -> UIColor! {
        if date == startDate || date == endDate {
            return UIColor.flatRed
        }
        return UIColor(white: 0, alpha: 0)
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, shouldUseCustomColorsFor date: Date!) -> Bool {
        return true
    }
    
    var startDate: Date?
    var endDate: Date?
}

class SearchPresenter {
    
    weak var searchView: SearchViewController?
    
    func update(startDate: Date?) {
        guard let safeDate = startDate else {
            searchView?.set(.dates(""))
            return
        }
        searchView?.set(.dates(formatter.string(from: safeDate)))
    }
    
    func update(startDate: Date?, endDate: Date?) {
        guard let safeStartDate = startDate,
            let safeEndDate = endDate else {
            searchView?.set(.dates(""))
            return
        }
        searchView?.set(.dates(formatter.string(from: safeStartDate)+" to "+formatter.string(from: safeEndDate)))
    }
    
    lazy var formatter: DateFormatter = {
        let aFormatter = DateFormatter()
        aFormatter.dateStyle = .short
        aFormatter.timeStyle = .none
        return aFormatter
    }()
}

class CalendarViewController: PDTSimpleCalendarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.isPagingEnabled = true
    }
}

