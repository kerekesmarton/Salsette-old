//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

struct SearchParameters {
    var name: String?
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var type: Dance?
    
    static var shared = SearchParameters()
    private init() {}
}

class SearchInteractor {
    enum DataType{
        case name(String)
        case location(String)
        case dates(Date?,Date?)
        case type(Dance)
    }
    let searchPresenter: SearchPresenter
    init(presenter: SearchPresenter, fbService: FacebookService = FacebookService.shared) {
        self.searchPresenter = presenter
        self.fbService = fbService
    }
    
    private var searchParameters = SearchParameters.shared
    private var fbService: FacebookService
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
            searchParameters.name = value
        case .location(let value):
            searchParameters.location = value
        case .type(let value):
            searchParameters.type = value
        case .dates(let start, let end):
            searchParameters.startDate = start
            searchParameters.endDate = end
        }
    }
    
    var startDate: Date?
    var endDate: Date?
    
    func load(with parameters: SearchParameters) {
        //          offline
        //        let items: [ContentEntityInterface] = AppTutorial.didShow ? DummySearchDatSource().dummyEvents : AppTutorial.cards
        //        completion(items,nil)
        //        return
        //
        
        //online
        searchPresenter.loading(message: "Loading...")
        FacebookService.shared.loadEvents(with: parameters) { [weak self] (events, error) in
            if let error = error as NSError? {
                self?.searchPresenter.results(with: error)
            } else if let events = events {
                self?.searchPresenter.results(with: events)
            }
        }
    }
    
    func deleteKeychain() {
        KeychainStorage.shared.clear()
    }
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
