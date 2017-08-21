//
//  FacebookService.swift
//  Salsette
//
//  Created by Marton Kerekes on 19/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

//import UIKit
import FBSDKCoreKit

class FacebookService {

    private init() {}

    static let shared = FacebookService()
    private var simpleConnection: FBSDKGraphRequestConnection?
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
    
    private var operationQueue: OperationQueue? = OperationQueue()
    func loadEvents(with parameters: SearchParameters, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        cancel()
        places(with: parameters, completion: { (ids, error) in
            
            if self.validError(error: error, completion: completion) {
                return
            } else if let ids = ids, ids.count > 0 {
                
                self.eventsByPlaces(with: ids,
                                    startDate: parameters.startDate,
                                    endDate: parameters.endDate,
                                    completion: completion)
            } else if parameters.location == nil {
                self.eventsByType(with: parameters, completion: { (events, error) in
                    
                    if self.validError(error: error, completion: completion) {
                        return
                    } else if let events = events, events.count > 0 {
                        completion(events,nil)
                    } else {
                        self.loadUserEvents(completion: completion)
                    }
                })
            } else {
                completion(nil, nil)
            }
        })
        
        
    }
    
    private func validError(error: Error?, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) -> Bool {
        if let error = error {
            completion(nil, error)
            return true
        } else {
            return false
        }
    }
    
    private func filter(results: [FacebookEventEntity]?, startDate: Date?, endDate: Date?) -> [FacebookEventEntity] {
    
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
    
    private var eventsByPlaceConnection: FBSDKGraphRequestConnection?
    func eventsByPlaces(with ids:[String], startDate: Date?, endDate: Date?, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        self.eventsByPlaceConnection = FBSDKGraphRequestConnection()
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
    
    private func eventsByType(with parameters: SearchParameters, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        guard let type = parameters.type?.rawValue else {
            completion([],nil)
            return
        }
        let request = FBSDKGraphRequest(graphPath: "/search", parameters: ["q":"\(type)", "type":"event", "fields":"name,place,start_time,end_time,cover,owner,description"])
        if let date = parameters.startDate {
            let dateString = DateFormatters.dateFormatter.string(from: date)
            request?.parameters.addEntries(from: ["since":dateString])
        } else {
            request?.parameters.addEntries(from: ["since":"now"])
        }
        if let date = parameters.endDate {
            let dateString = DateFormatters.dateFormatter.string(from: date)
            request?.parameters.addEntries(from: ["until":dateString])
        }
        
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
                completion(self.filter(results: results, startDate: parameters.startDate, endDate: parameters.endDate), nil)
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
}


class FacebookEventEntity: ContentEntityInterface, Equatable, Hashable {
    var name: String?
    var place: String?
    var location: String?
    var startDate: Date?
    var endDate: Date?
    var imageUrl: String?
    var image: UIImage?
    var identifier: String?
    var organiser: String?
    var type: EventTypes?
    var longDescription: String?
    var shortDescription: String? = nil

    convenience init(with dictionary:[String:Any]) {
        self.init(with: JSON(dictionary))
    }
    
    convenience init(with dictionary: JSON) {
        self.init()
        name = dictionary["name"].string
        place = dictionary["place"]["name"].string
        location = location(from: dictionary["place"]["location"])
        identifier = dictionary["id"].string
        imageUrl = dictionary["cover"]["source"].string
        organiser = dictionary["owner"]["name"].string
        if let time = dictionary["start_time"].string {
            startDate = DateFormatters.dateTimeFormatter.date(from: time)
        }
        if let time = dictionary["end_time"].string {
            endDate = DateFormatters.dateTimeFormatter.date(from: time)
        }
        longDescription = dictionary["description"].string
    }

    convenience init(with id: String) {
        self.init()
        self.identifier = id
    }
    
    class func create(with data: Any) ->[FacebookEventEntity] {
        let items = JSON(data)["data"]
        return items.map({ (_, body) -> FacebookEventEntity in
            return FacebookEventEntity(with: body)
        })
    }
    
    private func location(from json: JSON) -> String {
        var address = "\(json["zip"].string ?? "") \(json["city"].string ?? "") \(json["street"].string ?? "") \(json["country"].string ?? "")"
        
        if let lon = json["longitude"].string, let lat = json["latitude"].string {
            address.append("latitude:\(lat), longitude:\(lon)")
        }
        
        return address
    }
    
    var hashValue: Int {
        guard let identifier = identifier, let hash = Int(identifier) else { return 0 }
        return hash
    }
    
}

func == (lhs: FacebookEventEntity, rhs: FacebookEventEntity) -> Bool {
    return lhs.identifier == rhs.identifier
}
