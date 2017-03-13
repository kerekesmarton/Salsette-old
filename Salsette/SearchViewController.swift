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

    static func presentSearch(in hostViewController: UIViewController!) -> SearchViewController {
        let searchViewController = UIStoryboard.searchViewControllerWithNavigation()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter)
        searchViewController.searchInteractor = interactor
        presenter.searchView = searchViewController
        
        return searchViewController
    }
    
    static func launchSearch() -> SearchViewController {
        let searchViewController = UIStoryboard.searchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter)
        searchViewController.searchInteractor = interactor
        presenter.searchView = searchViewController
        
        return searchViewController
    }
}

class SearchViewController: UITableViewController, PDTSimpleCalendarViewDelegate {

    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var dateField: HoshiTextField!
    @IBOutlet weak var locationField: HoshiTextField!
    @IBOutlet weak var typeField: HoshiTextField!
    var calendarViewController: CalendarViewController?
    var calendarView: UIView {
        calendarViewController = CalendarViewController(nibName: "keyboard", bundle: nil)
        calendarViewController?.delegate = self
        return calendarViewController!.view
    }
    
    var searchInteractor: SearchInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateField.inputView = calendarView
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date?) {
        searchInteractor?.newDate = date
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
        default:
            return
        }
    }
    
    func resetCellForDate(date: Date) {
        guard let cell: CalendarViewCell = calendarViewController?.cellForItem(at: date) as? CalendarViewCell,
        let indexPath = calendarViewController?.collectionView?.indexPath(for: cell) else {
            return
        }
        calendarViewController?.collectionView?.reloadItems(at: [indexPath])
    }
}

extension SearchViewController: SideMenuChildViewProtocol {
    func resizeViewsToFit(frame: CGRect) {
        view.frame = frame
        tableView.frame = frame
    }
}

class SearchInteractor {
    let searchPresenter: SearchPresenter
    
    init(presenter: SearchPresenter) {
        self.searchPresenter = presenter
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, textColorFor date: Date!) -> UIColor! {
        return UIColor.flatBlack
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, circleColorFor date: Date!) -> UIColor! {
        return UIColor.flatForestGreen
    }
    
    var newDate: Date? {
        willSet {
            guard let oldDate = newDate else {
                return
            }
            searchPresenter.reset(oldDate: oldDate)
        }
        didSet {
            guard let date = newDate else {
                return
            }
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
    }
    var startDate: Date?
    var endDate: Date?
}

class SearchPresenter {
    
    weak var searchView: SearchViewController?
    
    func reset(oldDate: Date) {
        searchView?.resetCellForDate(date: oldDate)
    }
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
 
