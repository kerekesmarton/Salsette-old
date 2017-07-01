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
    private var connection: FBSDKGraphRequestConnection?
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
        connection = meRequest?.start(completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result {
                completion(returnedResult, nil)
            }
        })
    }
    
    func getPicture(user: String = "me", completion: @escaping (String?, Error?)->Void) {
        let request = FBSDKGraphRequest(graphPath: "\(user)/picture", parameters: ["type":"large", "fields":"url", "redirect":"false"])
        connection = request?.start(completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result, let url = JSON(returnedResult)["data"]["url"].string {
                completion(url, nil)
            }
        })
    }

    func loadUserEvents(from vc: UIViewController, completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        FacebookPermissions.shared.askFor(permissions: ["user_events"], from: vc, completion: { [weak self] (result, error) in
            if let  error = error {
                print(error)
            }
            let request = FBSDKGraphRequest(graphPath: "me/events?type=created&since=now", parameters: ["fields":"name,place,start_time,end_time,cover,owner,description"])
            self?.connection = request?.start(completionHandler: { (connection, result, error) in
                if let returnedError = error {
                    completion(nil, returnedError)
                } else if let returnedResult = result {
                    completion(FacebookEventEntity.create(with: returnedResult), nil)
                }
            })
        })
    }
    
    func loadSalsaEvents(completion: @escaping ([FacebookEventEntity]?, Error?)->Void) {
        
        let request = FBSDKGraphRequest(graphPath: "/search", parameters: ["q":"salsa", "type":"event", "fields":"name,place,start_time,end_time,cover,owner,description"])
        connection = request?.start(completionHandler: { (connection, result, error) in
            if let returnedError = error {
                completion(nil, returnedError)
            } else if let returnedResult = result {
                completion(FacebookEventEntity.create(with: returnedResult), nil)
            }
        })
    }

    func cancel() {
        guard let existingConnection = connection else {
            return
        }
        existingConnection.cancel()
        connection = nil
    }
}


class FacebookEventEntity: ContentEntityInterface {
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
    
    func location(from json: JSON) -> String {
        return "\(json["zip"].string ?? "") \(json["city"].string ?? "") \(json["street"].string ?? "") \(json["country"].string ?? "") \n latitude:\(json["latitude"].string ?? "") longitude:\(json["longitude"].string ?? "")"
    }
}
