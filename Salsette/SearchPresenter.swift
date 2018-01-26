import Foundation

class SearchPresenter: NSObject {
    
    init(view: SearchViewController) {
        self.searchView = view
    }
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
    
    func didChange(type value: Dance?) {
        searchParameters.didChange(.type(value))
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
    
    func update(endDate: Date?) {
        guard let safeStartDate = searchParameters.startDate, let safeEndDate = endDate else {
            searchView?.setSearch(.dates(""))
            return
        }
        searchView?.setSearch(.dates(formatter.string(from: safeStartDate)+" to "+formatter.string(from: safeEndDate)))
    }
    
    private var formatter: DateFormatter {
        return DateFormatters.shortDateFormatter
    }
    fileprivate var searchParameters = SearchParameters.shared
    fileprivate var newDate: Date? {
        didSet {
            guard let date = newDate else {
                return
            }
            if !searchParameters.hasStartDate() {
                update(startDate: date)
                searchParameters.didChange(.startDate(date))
            } else if !searchParameters.hasEndDate() {
                update(endDate: date)
                searchParameters.didChange(.endDate(date))
            } else {
                searchParameters.startDate = date
                searchParameters.endDate = nil
                update(startDate: date)                
            }
        }
    }
    
    private func dispatch(_ result: SearchViewController.ResultsViewModel) {
        DispatchQueue.main.async {
            self.searchView?.setResult(result)
        }
    }
    
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
}

extension SearchPresenter: CalendarViewSelectionDelegate {
    
    func calendarViewController(_ controller: CalendarProxy, shouldSelect date: Date, from selectedDates: [Date]) -> Bool {
        guard let startDate = searchParameters.startDate else {
            return true // no start date, pick it
        }
        if startDate > date {
            searchParameters.didChange(.startDate(nil))
            searchParameters.didChange(.endDate(nil))
            controller.deselectAll()
            return true
        }
        guard let endDate = searchParameters.endDate else {
            return true // no end date, pick it
        }
        if startDate < date && endDate > date {
            return true
        } else {
            reset(oldDate: date)
            controller.deselectAll()
            searchParameters.didChange(.startDate(nil))
            searchParameters.didChange(.endDate(nil))
            return false
        }
    }
    
    func calendarViewController(_ controller: CalendarProxy, didSelect date: Date) {
        if !searchParameters.hasStartDate() {
            newDate = date
            return
        }
        if !searchParameters.hasEndDate() {
            newDate = date
        }
        guard let start = searchParameters.startDate,
            let end = searchParameters.endDate else { return }
        controller.markSelectedBetween(startDate: start, endDate: end)
    }
    
    func calendarViewController(shouldDeselect date: Date, from selectedDates: [Date]) -> Bool {
        guard let start = searchParameters.startDate, let end = searchParameters.endDate else {
            return true
        }
        if start <= date && end >= date {
            return false
        }
        return true
    }
}
