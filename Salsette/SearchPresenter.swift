import Foundation

class SearchPresenter {
    
    weak var searchView: SearchViewController?
    var interactor = SearchInteractor()
    
    func isProfileEnabled() -> Bool {
        return interactor.canViewProfile()
    }
    
    func viewReady() {
        loading(message: "Loading...")
        interactor.loadInitial { [weak self] (events, error) in
            if let error = error as NSError? {
                self?.results(with: error)
            } else if let events = events {
                self?.results(with: events)
            }            
        }
    }
    
    func load() {
        loading(message: "Loading...")
        if searchParameters.type == nil {
            searchParameters.type = .dance
        }
        interactor.load(with: searchParameters) { [weak self] (events, error) in
            if let error = error as NSError? {
                self?.results(with: error)
            } else if let events = events {
                self?.results(with: events)
            }
        }
    }
    
    func didLogout() {
        interactor.deleteKeychain()
    }
    
    func reset(oldDate: Date) {
        searchView?.setSearch(.dates(""))
    }
    
    func update(startDate: Date?) {
        guard let safeDate = startDate else {
            searchView?.setSearch(.dates(""))
            return
        }
        searchView?.setSearch(.dates(formatter.string(from: safeDate)))
    }
    
    func update(startDate: Date?, endDate: Date?) {
        guard let safeStartDate = startDate,
            let safeEndDate = endDate else {
                searchView?.setSearch(.dates(""))
                return
        }
        searchView?.setSearch(.dates(formatter.string(from: safeStartDate)+" to "+formatter.string(from: safeEndDate)))
    }
    
    private var formatter: DateFormatter {
        return DateFormatters.shortDateFormatter
    }
    
    private var searchParameters = SearchParameters.shared
    var newDate: Date? {
        didSet {
            guard let date = newDate else {
                return
            }
            if startDate == nil {
                startDate = date
                update(startDate: date)
                didChange(.dates(startDate, nil))
            } else if endDate == nil {
                endDate = date
                update(startDate: startDate, endDate: date)
                didChange(.dates(startDate, endDate))
            } else {
                startDate = date
                update(startDate: date)
                endDate = nil
            }
        }
    }
    
    enum DataType{
        case name(String?)
        case location(String?)
        case dates(Date?,Date?)
        case type(Dance?)
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
    
    func loading(message: String) {
        dispatch(.loading(message))
    }
    
    func results(with events: [SearchableEntity]) {
        if events.count > 0 {
            dispatch(.success(events))
        } else {
            dispatch(.failed("Couldn't find anything... \nSorry about that."))
        }
    }
    
    func results(with error: NSError) {
        switch (error.domain,error.code) {
        case (_,8):
            dispatch(.needsFacebookLogin("Please log in with your facebook account"))
        case (NSURLErrorDomain,_):
            dispatch(.failed(error.localizedDescription))
        default:
            dispatch(.failed("Unknown Error occured"))
        }
    }
    
    private func dispatch(_ result: SearchViewController.ResultsViewModel) {
        DispatchQueue.main.async {
            self.searchView?.setResult(result)
        }
    }
}

extension SearchPresenter: CalendarViewSelectionDelegate {
    
    func calendarViewController(_ controller: CalendarProxy, shouldSelect date: Date, from selectedDates: [Date]) -> Bool {
        guard let startDate = startDate else {
            return true // no start date, pick it
        }
        if startDate > date {
            self.startDate = nil
            self.endDate = nil
            controller.deselectAll()
            return true
        }
        guard let endDate = endDate else {
            return true // no end date, pick it
        }
        if startDate < date && endDate > date {
            return true
        } else {
            reset(oldDate: date)
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

