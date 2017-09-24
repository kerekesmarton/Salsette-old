//
//  CreateEventInteractor.swift
//  Salsette
//
//  Created by Marton Kerekes on 28/08/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

struct GraphEvent {
    var id: String
    var type: Dance
    var workshops: [GraphWorkshop]?
}

struct GraphWorkshop: Equatable {
    var name: String
    let hours: Double = 1
    var startTime: Date
    var room: String
    var artist: String?
    var isEmpty = false
    var graphId: String? = nil
    
    init(name: String, startTime: Date, room: String) {
        self.name = name
        self.startTime = startTime
        self.room = room
    }
    
    init(startTime: Date, room: String) {
        isEmpty = true
        name = ""
        self.startTime = startTime
        self.room = room
    }
}

func ==(lhs: GraphWorkshop, rhs: GraphWorkshop) -> Bool {
    return lhs.room == rhs.room && lhs.startTime == rhs.startTime
}

class CreateEventInteractor {
    
    let graphManager = GraphManager.shared
    
    func createEvent(fbID: String, type: Dance, completion: @escaping (GraphEvent?, Error?) -> Void) {
        let model = GraphManager.CreateEventModel(fbID: fbID, type: type)
        graphManager.createEvent(model: model) { (createdEvent, error) in
            if let result = createdEvent {
                completion(CreateEventInteractor.graphEvent(from: result), nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func searchEvent(fbID: String?, completion: @escaping ((GraphEvent?, Error?) -> Void)) {
        guard let fbID = fbID else {
            completion(nil, nil)
            return
        }
        graphManager.searchEvent(fbID: fbID) { (eventSearchResult, error) in
            if let result = eventSearchResult {
                completion(CreateEventInteractor.graphEvent(from: result), nil)
            } else if let error = error {
                completion(nil, error)
            }
            completion(nil, nil)
        }
    }
    
    static func graphEvent(from createdEvent: GraphManager.CretedEvent) -> GraphEvent {
        return GraphEvent(id: createdEvent.fbId!, type: createdEvent.type, workshops: nil)
    }
    
    static func graphEvent(from searchEvent: GraphManager.EventSearchResult) -> GraphEvent {
        return GraphEvent(id: searchEvent.fbId!, type: searchEvent.type, workshops: CreateEventInteractor.graphWorkshop(from: searchEvent.workshops))
    }
    
    static func graphWorkshop(from searchWorkshop: GraphManager.EventSearchResult.Workshop?) -> [GraphWorkshop]? {
        guard let edges = searchWorkshop?.edges else { return nil }
        return edges.flatMap {
            guard let node = $0?.node, let timeInterval = Double(node.startTime) else { return nil }
            let time = Date(timeIntervalSince1970: timeInterval)
            var workshop =  GraphWorkshop(name: node.name, startTime: time, room: node.room)
            workshop.artist = node.artist
            workshop.graphId = node.id
            return workshop
        }
    }
}
