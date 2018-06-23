//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

class SearchInteractor {
    
    private let fbService = FacebookService.shared
    private let graphService = GraphManager.shared
    private let noEventsError = NSError(with: "Couldn't find events")
    private func loadGraphEvents(parameters: SearchParameters, completion: @escaping ([EventModel]?, Error?)->Void) {
        graphService.searchEvent(parameters: parameters) { (events, error) in
            completion(events, error)
        }
    }
    
    private func loadFacebookEvents(ids: [String]?, completion: @escaping ([FacebookEvent]?, Error?)->Void) {
        guard let safeIds = ids, safeIds.count > 0 else {
            completion([], nil)
            return
        }
        fbService.loadEvents(with: safeIds, completion: { (events, error) in
            completion(events, error)
        })
    }
    
    fileprivate func match(_ fbEvents: [FacebookEvent], with eventModels:[EventModel]) -> [SearchResult] {
        return eventModels.compactMap({ (graphEvent) -> SearchResult? in
            var result = SearchResult(graphEvent: graphEvent)            
            if let index = fbEvents.index(where: { (fbEvent) -> Bool in
                return graphEvent.fbID == fbEvent.identifier
            }) {
                result.fbEvent = fbEvents[index]
            }
            return result
        })
    }
    
    func load(with parameters: SearchParameters, completion: @escaping ([SearchResult]?, Error?)->Void) {
        loadGraphEvents(parameters: parameters) { [weak self]  (eventModels, error) in
            guard let eventModels = eventModels, eventModels.count > 0 else {
                completion(nil, error ?? self?.noEventsError)
                return
            }
            let ids = eventModels.reduce(into: [String]()) { $0.append($1.fbID) }
            self?.loadFacebookEvents(ids: ids, completion: { [weak self] (fbEvents, error) in
                guard let fbEvents = fbEvents else {
                    completion(nil, error)
                    return
                }
                completion(self?.match(fbEvents, with: eventModels), nil)
            })
        }
    }
    
    func canViewProfile() -> Bool {
        return fbService.isLoggedIn
    }
    
    func deleteKeychain() {
        KeychainStorage.shared.clear()
    }
}
