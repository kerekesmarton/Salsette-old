import Foundation

class SearchPresenter {
    
    weak var searchView: SearchViewController?
    
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
    
    func loading(message: String) {
        dispatch(.loading(message))
    }
    
    func results(with events: [ContentEntityInterface]) {
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

