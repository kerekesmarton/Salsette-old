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

protocol SearchResultsDelegate: class {
    func didUpdateSearch(parameters: SearchParameters)
}

struct SearchParameters {
    var name: String?
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var type: EventTypes?
}

class GlobalSearch {
    private init() { }
    static let sharedInstance = GlobalSearch()
    weak var searchResultsDelegate: SearchResultsDelegate?
    var searchParameters = SearchParameters() {
        didSet {
            searchResultsDelegate?.didUpdateSearch(parameters: searchParameters)
        }
    }
}

struct SearchFeatureLauncher {

    static func launchSearch() -> SearchViewController {
        let searchViewController = UIStoryboard.searchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter)
        searchViewController.searchInteractor = interactor
        presenter.searchView = searchViewController
        
        return searchViewController
    }
}

class SearchViewController: UITableViewController {
    static let searchSize: CGFloat = 268.0
    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var dateField: HoshiTextField!
    @IBOutlet weak var locationField: HoshiTextField!
    @IBOutlet weak var typeField: HoshiTextField!
    @IBOutlet var fields: [UITextField]!
    @IBOutlet var typePicker: UIPickerView!
    lazy var calendarProxy: CalendarProxy = {
        return UINib(nibName: "Calendar", bundle: nil).instantiate(withOwner: self, options: nil)[1] as! CalendarProxy
    }()
    var calendarView: UIView {
        calendarProxy.interactor = self.searchInteractor
        return calendarProxy.calendar
    }
    
    lazy var searchInteractor: SearchInteractor = {
        let interactor = SearchInteractor(presenter: SearchPresenter())
        interactor.searchPresenter.searchView = self
        return interactor
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateField.inputView = calendarView
        typeField.inputView = typePicker
        typePicker.delegate = self
        typePicker.dataSource = self
        typeField.delegate = self
        dateField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fields.forEach({$0.endEditing(true)})
    }
}

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EventTypes.allEventTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {        
        return EventTypes.string(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeField.text = EventTypes.string(at: row)
        searchInteractor.didChange(.type(EventTypes.item(at: row)))
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameField:
            searchInteractor.didChange(.name(nameField.text!))
        case locationField:
            searchInteractor.didChange(.location(locationField.text!))
        default:
            ()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            dateField.becomeFirstResponder()
        case dateField:
            locationField.becomeFirstResponder()
        case locationField:
            typeField.becomeFirstResponder()
        case typeField:
            typeField.resignFirstResponder()
        default:
            ()
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == typeField || textField == dateField {
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
    enum DataType{
        case name(String)
        case location(String)
        case dates(Date?,Date?)
        case type(EventTypes)
    }
    let searchPresenter: SearchPresenter
    init(presenter: SearchPresenter) {
        self.searchPresenter = presenter
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
                didChange(.dates(startDate, endDate))
            } else {
                startDate = date
                searchPresenter.update(startDate: date)
                endDate = nil
            }
        }
    }

    func didChange(_ dataType: DataType) {
        switch dataType {
        case .name(let value):
            GlobalSearch.sharedInstance.searchParameters.name = value
        case .location(let value):
            GlobalSearch.sharedInstance.searchParameters.location = value
        case .type(let value):
            GlobalSearch.sharedInstance.searchParameters.type = value
        case .dates(let start, let end):
            GlobalSearch.sharedInstance.searchParameters.startDate = start
            GlobalSearch.sharedInstance.searchParameters.endDate = end
        }
    }

    var startDate: Date?
    var endDate: Date?
}

extension SearchInteractor: CalendarViewSelectionDelegate {
    
    func calendarViewController(_ controller: CalendarProxy, shouldSelect date: Date, from selectedDates: [Date]) -> Bool {
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
            didChange(.dates(nil, nil))
            return false
        }
    }

    func calendarViewController(_ controller: CalendarProxy, didSelect date: Date) {
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
        if start <= date && end >= date {
            return false
        }
        return true
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
