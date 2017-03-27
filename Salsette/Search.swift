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
import ChameleonFramework

protocol SearchResultsDelegate {
    func didUpdateSearch(parameters: SearchParameters)
}

struct SearchSize {
    static let smallSize = 215.0
    static let calendarSize = 400.0
    static let mapSize = 400.0
}

struct SearchParameters {
    var name: String?
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var type: String?
}

class GlobalSearch: SearchResultsDelegate {

    func didUpdateSearch(parameters: SearchParameters) {
        searchParameters = parameters
    }

    var searchParameters = SearchParameters()
}

struct SearchFeatureLauncher {

    static func launchSearch() -> SearchViewController {
        let searchViewController = UIStoryboard.searchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter, delegate: GlobalSearch())
        searchViewController.searchInteractor = interactor
        presenter.searchView = searchViewController
        
        return searchViewController
    }
}

class SearchViewController: UITableViewController {

    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var dateField: HoshiTextField!
    @IBOutlet weak var locationField: HoshiTextField!
    @IBOutlet weak var typeField: HoshiTextField!
    var searchInteractor: SearchInteractor?
    
    override func viewDidLoad() {
        dateField.delegate = self
    }
    
    func addToContainer(childViewController: UIViewController) {
        self.view.addSubview(childViewController.view)
        self.addChildViewController(childViewController)
        childViewController.didMove(toParentViewController: self)
        
        view.addSubview(childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = true
        childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        childViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        childViewController.view.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        childViewController.view.heightAnchor.constraint(equalToConstant: 220.0).isActive = true
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateField {
            let calendarViewController = UIStoryboard.calendarViewController()
            calendarViewController.interactor = self.searchInteractor
            addToContainer(childViewController: calendarViewController)
            return false
        }
        return true
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
}

class SearchInteractor {
    let searchPresenter: SearchPresenter
    let searchResultsDelegate: SearchResultsDelegate
    init(presenter: SearchPresenter, delegate: SearchResultsDelegate) {
        self.searchPresenter = presenter
        self.searchResultsDelegate = delegate
    }
    
    var newDate: Date? {
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

extension SearchInteractor: CalendarViewControllerInteractor {
    
    func calendarViewController(_ controller: CalendarViewController, shouldSelect date: Date, from selectedDates: [Date]) -> Bool {
        guard let startDate = startDate else {
            return true // no start date, pick it
        }
        if startDate > date {
            return false
        }
        guard let endDate = endDate else {
            return true // no end date, pick it
        }
        if startDate < date && endDate > date {
            return true
        } else {
            searchPresenter.reset(oldDate: date)
            controller.deselectAll()
            self.startDate = nil
            self.endDate = nil
            return false
        }
    }

    func calendarViewController(_ controller: CalendarViewController, didSelect date: Date) {
        if startDate == nil {
            newDate = date
            return
        }
        if endDate == nil {
            newDate = date
        }
        guard let start = startDate,
            let end = endDate else { return }
        controller.markSelectedBetween(startDate: start, endDate: end)
    }
    
    func calendarViewController(shouldDeselect date: Date, from selectedDates: [Date]) -> Bool {
        
        guard let start = startDate, let end = endDate else {
            return true
        }
        if start < date && end > date {
            return false
        }
        return true
    }
    
    func calendarViewController(didDeselect date: Date) {
        if startDate == date {
            startDate = nil
        }
        if endDate == date {
            endDate = nil
        }
        searchPresenter.reset(oldDate: date)
    }
}

class SearchPresenter {
    
    weak var searchView: SearchViewController?
    
    func reset(oldDate: Date) {
        searchView?.set(.dates(""))
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
