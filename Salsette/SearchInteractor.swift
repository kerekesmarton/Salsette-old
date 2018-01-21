//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation
import CoreLocation

class SearchInteractor {
    
    private let fbService = FacebookService.shared
    private let geocoder = CLGeocoder()
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
    
    func geocode(value: String, completion: @escaping ([String]?, Error?)->Void) {
        geocoder.geocodeAddressString(value, completionHandler: { (placemarks, error) in
            guard let placemarks = placemarks, placemarks.count >= 0 else {
                print(String(describing: error))
                return
            }
            print(placemarks)
        })
    }
}
