//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

class SearchInteractor {
    
    private let fbService = FacebookService.shared
    private let graphService = GraphManager.shared
    private func loadGraphEvents(parameters: SearchParameters, completion: @escaping ([EventModel]?, Error?)->Void) {
        graphService.searchEvent(parameters: parameters) { (events, error) in
            completion(events, error)
        }
    }
    
    private func loadFacebookEvents(ids: [String]?, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        guard let safeIds = ids, safeIds.count > 0 else {
            completion(nil, NSError(with: "Couldn't find events"))
            return
        }
        fbService.loadEvents(with: safeIds, completion: { (events, error) in
            completion(events, error)
        })
    }
    
    fileprivate func match(_ fbEvents: [FacebookEventEntity], with eventModels:[EventModel]) {
        fbEvents.forEach({ (fbEvent) in
            guard let index = eventModels.index(where: { (eventModel) -> Bool in
                return eventModel.fbID == fbEvent.identifier
            }) else {
                return
            }
            fbEvent.graphEvent = eventModels[index]
        })
    }
    
    func load(with parameters: SearchParameters, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        loadGraphEvents(parameters: parameters) { [weak self]  (eventModels, error) in
            guard let eventModels = eventModels, eventModels.count > 0 else {
                completion(nil, NSError(with: "Couldn't find events"))
                return
            }
            let ids = eventModels.reduce(into: [String]()) { $0.append($1.fbID) }
            self?.loadFacebookEvents(ids: ids, completion: { [weak self] (fbEvents, error) in
                guard let fbEvents = fbEvents, fbEvents.count > 0 else {
                    completion(nil, NSError(with: "Couldn't find events"))
                    return
                }
                self?.match(fbEvents, with: eventModels)
                completion(fbEvents, nil)
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
