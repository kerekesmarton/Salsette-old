//
//  FacebookService.swift
//  Salsette
//
//  Created by Marton Kerekes on 19/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

//import UIKit
import FBSDKCoreKit
import Social

class FacebookService {

    private init() {}

    static let shared = FacebookService()
    fileprivate var simpleConnection: FBSDKGraphRequestConnection?
    var cachedUserEvents: Any?
    
    var isLoggedIn: Bool {
        get {
            return FBSDKAccessToken.current() != nil ? true : false
        }
    }
    
    var token: String? {
        get {
            guard let currentToken = FBSDKAccessToken.current() else { return nil }
            return currentToken.tokenString ?? nil
        }
    }
    
    func getUser(from vc: UIViewController, completion: @escaping (Any?, Error?)->Void) {
        let meRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name"])
        simpleConnection = meRequest?.start(completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result {
                completion(returnedResult, nil)
            }
        })
    }
    
    func getPicture(user: String = "me", completion: @escaping (String?, Error?)->Void) {
        let request = FBSDKGraphRequest(graphPath: "\(user)/picture", parameters: ["type":"large", "fields":"url", "redirect":"false"])
        simpleConnection = request?.start(completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result, let url = JSON(returnedResult)["data"]["url"].string {
                completion(url, nil)
            }
        })
    }

    func loadUserCreatedEvents(completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        let request = FBSDKGraphRequest(graphPath: "me/events?type=created&since=now", parameters: ["fields":"name,place,start_time,end_time,cover,owner,description"])
        simpleConnection = request?.start(completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result {
                completion(FacebookEventEntity.create(with: returnedResult), nil)
            }
        })
    }
    
    func loadUserEvents(completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        let request = FBSDKGraphRequest(graphPath: "me/events?since=now", parameters: [ "fields":"name,place,start_time,end_time,cover,owner,description"])
        self.simpleConnection = request?.start(completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result {
                
                let sortedEvents = FacebookEventEntity.create(with: returnedResult).sorted(by: { (event1, event2) -> Bool in
                    guard let s1 = event1.startDate, let s2 = event2.startDate else {
                        return event1.hashValue < event2.hashValue
                    }
                    return s1 < s2
                })
                completion(sortedEvents, nil)
            }
        })
    }
    
    fileprivate var operationQueue: OperationQueue? = OperationQueue()
    func loadEvents(with parameters: SearchParameters, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        cancel()
        events(with: parameters, completion: { (events, error) in
            if self.validError(error: error, completion: completion) {
                return
            } else {
                completion(events,nil)
            }
        })
    }
    
    fileprivate func validError(error: Error?, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) -> Bool {
        if let error = error {
            completion(nil, error)
            return true
        } else {
            return false
        }
    }
    
    fileprivate func filter(results: [FacebookEventEntity]?, startDate: Date?, endDate: Date?) -> [FacebookEventEntity] {
    
        guard let results = results else {
            return []
        }
        
        let sdate = startDate ?? Date().setting(month: 1)
        let edate = endDate ?? Date().setting(month: 12)
        
        return results.flatMap({ (event) -> FacebookEventEntity? in
            if let eventStartDate = event.startDate, let eventEndDate = event.endDate,
                eventStartDate > sdate, eventEndDate < edate
            {
                return event
            }
            return nil
        })
        
    }
    
    fileprivate func fillDateOn(_ parameters: SearchParameters, _ request: FBSDKGraphRequest?) {
        if let date = parameters.startDate {
            let dateString = DateFormatters.facebookDateFormatter.string(from: date)
            request?.parameters.addEntries(from: ["since":dateString])
        } else {
            request?.parameters.addEntries(from: ["since":"now"])
        }
        if let date = parameters.endDate {
            let dateString = DateFormatters.facebookDateFormatter.string(from: date)
            request?.parameters.addEntries(from: ["until":dateString])
        }
    }
    
    private func events(with parameters: SearchParameters, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        var searchTerms = ""
        if let location = parameters.location, location.count > 0 {
            searchTerms = location
        }
        if let type = parameters.type?.rawValue, type.count > 0 {
            searchTerms.append(" \(type)")
        }
        guard searchTerms.count > 0 else {
            completion([],nil)
            return
        }        
        let request = FBSDKGraphRequest(graphPath: "/search", parameters: ["q":"\(searchTerms)", "type":"event", "fields":"name,place,start_time,end_time,cover,owner,description"])
        fillDateOn(parameters, request)
        
        self.simpleConnection = request?.start(completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result {
                
                let results = FacebookEventEntity.create(with: returnedResult).sorted(by: { (event1, event2) -> Bool in
                    guard let s1 = event1.startDate, let s2 = event2.startDate else {
                        return event1.hashValue < event2.hashValue
                    }
                    return s1 < s2
                })
                completion(results, nil)
//                completion(self.filter(results: results, startDate: parameters.startDate, endDate: parameters.endDate), nil)
            }
        })
    }
    
    func cancel() {
        if let existingConnection = simpleConnection {
            existingConnection.cancel()
            simpleConnection = nil
        }
        operationQueue?.cancelAllOperations()
        if let existingConnection = eventsByPlaceConnection {
            existingConnection.cancel()
            eventsByPlaceConnection = nil
        }
        if let existingConnection = simpleConnection {
            existingConnection.cancel()
            simpleConnection = nil
        }
        
    }
    
    //MARK: - unused
    fileprivate var eventsByPlaceConnection: FBSDKGraphRequestConnection?
}

fileprivate extension FacebookService {
     func loadPlaces(_ parameters: SearchParameters, _ completion: @escaping ([FacebookEventEntity]?, Error?) -> Void) {
        places(with: parameters, completion: { (ids, error) in
            
            if self.validError(error: error, completion: completion) {
                return
            } else if let ids = ids, ids.count > 0 {
                
                self.eventsByPlaces(with: ids,
                                    startDate: parameters.startDate,
                                    endDate: parameters.endDate,
                                    completion: completion)
            } else if parameters.location == nil {
                //
            } else {
                completion(nil, nil)
            }
        })
    }
    
    private func places(with parameters: SearchParameters, completion: @escaping ([String]?, Error?)->Void) {
        guard var queryString = parameters.location else {
            completion([],nil)
            return
        }
        let typeQuery = parameters.type?.rawValue ?? "Dance"
        queryString.append(" \(typeQuery)")
        let request = FBSDKGraphRequest(graphPath: "/search", parameters: ["q":"\(queryString)","type":"place", "fields":"name,location","limit":"25"])
        simpleConnection = request?.start(completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result {
                let result = JSON(returnedResult)["data"].flatMap { return $1["id"].string }
                completion(result, nil)
            }
        })
    }
    
    
    func eventsByPlaces(with ids:[String], startDate: Date?, endDate: Date?, completion: @escaping ([FacebookEventEntity]?, Error?) -> Void) {
        eventsByPlaceConnection = FBSDKGraphRequestConnection()
        var eventSet = Set<FacebookEventEntity>()
        var results: [FacebookEventEntity]?
        let sortOperation = BlockOperation(block: {
            results = eventSet.sorted(by: { (event1, event2) -> Bool in
                guard let s1 = event1.startDate, let s2 = event2.startDate else {
                    return event1.hashValue < event2.hashValue
                }
                return s1 < s2
            })
            completion(self.filter(results: results, startDate: startDate, endDate: endDate),nil)
        })
        ids.forEach({ (id) in
            
            var blockEvents: [FacebookEventEntity]? = nil
            let operation = BlockOperation(block: {
                blockEvents?.forEach { eventSet.insert($0) }
            })
            addEventRequestForPlace(with: id, startDate: startDate, endDate: endDate, to: eventsByPlaceConnection, completion: { [weak self] (events, error) in
                blockEvents = events
                self?.operationQueue?.addOperation(operation)
            })
            sortOperation.addDependency(operation)
        })
        operationQueue?.addOperation(sortOperation)
        eventsByPlaceConnection?.start()
    }
    
    private func addEventRequestForPlace(with placeId: String, startDate: Date?, endDate: Date?, to connection: FBSDKGraphRequestConnection?, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        let request = FBSDKGraphRequest(graphPath: "/\(placeId)/events", parameters: ["fields":"name,place,start_time,end_time,cover,owner,description"])
        if let date = startDate {
            let dateString = DateFormatters.dateFormatter.string(from: date)
            request?.parameters.addEntries(from: ["since":dateString])
        } else {
            request?.parameters.addEntries(from: ["since":"now"])
        }
        if let date = endDate {
            let dateString = DateFormatters.dateFormatter.string(from: date)
            request?.parameters.addEntries(from: ["until":dateString])
        }
        connection?.add(request, completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result {
                completion(FacebookEventEntity.create(with: returnedResult), nil)
            }
        })
    }
}
