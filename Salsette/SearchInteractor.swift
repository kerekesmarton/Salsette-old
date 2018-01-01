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
    
    init(fbService: FacebookService = FacebookService.shared) {
        self.fbService = fbService
    }
    
    private var fbService: FacebookService
    
//    fileprivate func loadGraphEvents(for facebookEvents:[FacebookEventEntity]) {
//        let ids = facebookEvents.flatMap({ (entity) -> String? in
//            return entity.identifier
//        })
//        GraphManager.shared.searchEvents(fbIDs: ids, closure: { [weak self] (eventModels, error) in
//            self?.searchPresenter.results(with: facebookEvents)
//        })
//    }
    
    func load(with parameters: SearchParameters, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        fbService.loadEvents(with: parameters) { (events, error) in
            completion(events, error)            
        }
    }
    
    func loadInitial(completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        fbService.loadUserEvents() { (events, error) in
            completion(events, error)
        }
    }
    
    
    
    func canViewProfile() -> Bool {
        return fbService.isLoggedIn
    }
    
    func deleteKeychain() {
        KeychainStorage.shared.clear()
    }
}
