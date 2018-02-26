import Foundation
import CoreLocation

class SearchPresenter: NSObject {
    
    init(view: SearchViewController) {
        self.searchView = view
    }
    weak var searchView: SearchViewController?
    var interactor = SearchInteractor()
    
    func isProfileEnabled() -> Bool {
        return interactor.canViewProfile()
    }
    
    lazy var locationMatching = LocationMatching()
    
    private func loadSettingUpDefaultLocation() {
        locationMatching.reverseGeocodeCurrentLocation { [weak self] (location) in
            self?.update(location: location.graphLocation())
            self?.load(with: location)
        }
    }
    
    func viewReady() {
        loading(message: "Determining location...")
        loadSettingUpDefaultLocation()
    }
    
    func load(with placemark: SearchableLocation) {
        searchParameters.didChange(.location(placemark))
        load()
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

    func didChange(location value: FacebookLocation) {
        searchParameters.location = value
    }
    
    func reset(oldDate: Date) {
        searchView?.setSearch(.dates(""))
    }
    
    private func update(startDate: Date?) {
        guard let safeDate = startDate else {
            searchView?.setSearch(.dates(""))
            return
        }
        searchView?.setSearch(.dates(formatter.string(from: safeDate)))
    }
    
    private func update(endDate: Date?) {
        guard let safeStartDate = searchParameters.startDate, let safeEndDate = endDate else {
            searchView?.setSearch(.dates(""))
            return
        }
        searchView?.setSearch(.dates(formatter.string(from: safeStartDate)+" to "+formatter.string(from: safeEndDate)))
    }
    
    private func update(location: String?) {
        guard let value = location else { return }
        DispatchQueue.main.async {
            self.searchView?.setSearch(.location(value))
        }
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
    
    private func dispatch(result: SearchViewController.ResultsViewModel) {
        DispatchQueue.main.async {
            self.searchView?.setResult(result)
        }
    }
    
    func loading(message: String) {
        dispatch(result: .loading(message))
    }
    
    func results(with events: [FacebookEventEntity]) {
        if events.count > 0 {
            dispatch(result: .success(events))
        } else {
            dispatch(result: .failed("Couldn't find anything... \nSorry about that."))
        }
    }
    
    func results(with error: NSError) {
        switch (error.domain, error.code) {
        case (_,8):
            dispatch(result: .needsFacebookLogin(""))
        case (_,80):
            dispatch(result: .needsGraphLogin(""))
        default:
            dispatch(result: .failed(error.localizedDescription))
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
