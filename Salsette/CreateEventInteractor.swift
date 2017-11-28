//
//  CreateEventInteractor.swift
//  Salsette
//
//  Created by Marton Kerekes on 28/08/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit


class CreateEventInteractor {
    
    let graphManager = GraphManager.shared
    
    func createEvent(fbID: String, type: Dance, completion: @escaping (EventModel?, Error?) -> Void) {
        let model = EventModel(fbID: fbID, type: type)
        graphManager.createEvent(model: model) { (createdEvent, error) in
            if let result = createdEvent {
                completion(result, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func searchEvent(fbID: String?, completion: @escaping ((EventModel?, Error?) -> Void)) {
        guard let fbID = fbID else {
            completion(nil, nil)
            return
        }
        graphManager.searchEvent(fbID: fbID) { (eventSearchResult, error) in
            if let result = eventSearchResult {
                completion(result, nil)
            } else if let error = error {
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
        }
    }
}
