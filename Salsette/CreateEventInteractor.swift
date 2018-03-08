//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

extension WorkshopModel {
    func isUnchangedComparedTo(_ comparedModel: WorkshopModel) -> Bool {
        if name == comparedModel.name,
            room == comparedModel.room,
            startTime == comparedModel.startTime,
            artist == comparedModel.artist,
            id == comparedModel.id {
            
            return true
        }
        return false
    }
}

class CreateEventInteractor {
    
    let graphManager = GraphManager.shared
    
    func createEvent(eventModel: EventModel, placeModel: PlaceModel, completion: @escaping (EventModel?, Error?) -> Void) {
        graphManager.createPlaceAndEvent(placeModel: placeModel, eventModel: eventModel) { (createdEvent, error) in
            if let event = createdEvent {
                completion(event, nil)
            } else {
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
    
    func deleteEvent(graphID: String?, completion: @escaping ((Bool?, Error?) -> Void)) {
        guard let graphID = graphID else {
            completion(nil, nil)
            return
        }
        graphManager.deleteEvent(graphID: graphID) { (success, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(success, nil)
            }
        }
    }
    
    fileprivate func filterNew(_ updates: [WorkshopModel], _ originals: [WorkshopModel]?) -> [WorkshopModel] {
        return updates.filter({ (updated) -> Bool in
            guard let originals = originals else {
                return true
            }
            return !originals.contains(updated)
        })
    }
    
    fileprivate func filterUpdated(_ updates: [WorkshopModel], _ originals: [WorkshopModel]?) -> [WorkshopModel] {
        return updates.filter({ (model) -> Bool in
            if let i = originals?.index(of: model), let original = originals?[i] {
                return !model.isUnchangedComparedTo(original)
            }
            return false
        })
    }
    
    fileprivate func filterDeleted(_ originals: [WorkshopModel]?, _ updated: [WorkshopModel]) -> [WorkshopModel] {
        guard let originals = originals else { return [] }
        return originals.filter({ (original) -> Bool in
            return !updated.contains(original)
        })
    }
    
    fileprivate func create(_ model: (WorkshopModel), _ id: String, on workGroup: DispatchGroup) {
        workGroup.enter()
        graphManager.createWorkshop(model: model, eventID: id) { (createdWorkshop, error) in
            if let error = error {
                self.errors.append(error)
            }
            workGroup.leave()
        }
    }
    
    fileprivate func update(_ model: (WorkshopModel), _ id: String, on workGroup: DispatchGroup) {
        workGroup.enter()
        graphManager.updateWorkshop(model: model, eventID: id) { (updatedWorkshop, error) in
            if let error = error {
                self.errors.append(error)
            }
            workGroup.leave()
        }
    }
    
    fileprivate func delete(_ model: (WorkshopModel), on workGroup: DispatchGroup) {
        workGroup.enter()
        graphManager.deleteWorkshop(id: model.id) { (success, error) in
            if let error = error {
                self.errors.append(error)
            }
            workGroup.leave()
        }
    }
    
    fileprivate func finaliseUpdate(_ completion: @escaping (EventModel?, Error?) -> Void, _ new: [WorkshopModel], _ updates: [WorkshopModel], _ deleted: [WorkshopModel], _ event: EventModel) {
        if errors.count > 0 {
            DispatchQueue.main.async {
                completion(nil, self.errors.first)
            }
        } else if new.count == 0, updates.count == 0, deleted.count == 0{
            DispatchQueue.main.async {
                completion(event, nil)
            }
        } else {
            searchEvent(fbID: event.fbID, completion: completion)
        }
    }
    private var errors = [Error]()
    fileprivate func asyncUpdate(_ event: EventModel, _ updated: [WorkshopModel], _ completion: @escaping (EventModel?, Error?) -> Void) {
        guard let eventId = event.id else {
            completion(nil, nil)
            return
        }
        let originals = event.workshops
        let new = filterNew(updated, originals)
        let updates = filterUpdated(updated, originals)
        let deleted = filterDeleted(originals, updated)
        let workGroup = DispatchGroup()
        errors.removeAll()
        new.forEach { (model) in
            create(model, eventId, on: workGroup)
        }
        updates.forEach { (model) in
            update(model, eventId, on: workGroup)
        }
        deleted.forEach({ (model) in
            delete(model, on: workGroup)
        })
        workGroup.wait()
        finaliseUpdate(completion, new, updates, deleted, event)
    }
    
    func update(event: EventModel, updated: [WorkshopModel], completion: @escaping (EventModel?, Error?) -> Void) {
        DispatchQueue.global().async {
            self.asyncUpdate(event, updated, completion)
        }
    }
}
