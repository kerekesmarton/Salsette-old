//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

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
    private init() {}
    static let shared = GlobalSearch()
    weak var searchResultsDelegate: SearchResultsDelegate?
    var searchParameters = SearchParameters() {
        didSet {
            searchResultsDelegate?.didUpdateSearch(parameters: searchParameters)
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
            GlobalSearch.shared.searchParameters.name = value
        case .location(let value):
            GlobalSearch.shared.searchParameters.location = value
        case .type(let value):
            GlobalSearch.shared.searchParameters.type = value
        case .dates(let start, let end):
            GlobalSearch.shared.searchParameters.startDate = start
            GlobalSearch.shared.searchParameters.endDate = end
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
    
    var formatter: DateFormatter {
        return DateFormatters.shortDateFormatter
    }
}
