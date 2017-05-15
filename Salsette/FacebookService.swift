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

    func loadUserEvents(from vc: UIViewController, completion: @escaping (Any?, Error?)->Void) {
        FacebookPermissions.shared.askFor(permissions: ["user_events"], from: vc, completion: { [weak self] (result, error) in
            if let  error = error {
                print(error)
            }
            let request = FBSDKGraphRequest(graphPath: "me/events?type=created&since=now", parameters: ["fields":"name,place,start_time,end_time,cover,description,id"])
            self?.connection = request?.start(completionHandler: { (connection, result, error) in
                if let returnedError = error {
                    completion(nil, returnedError)
                } else if let returnedResult = result {
                    self?.cachedUserEvents = result
                    completion(returnedResult, nil)
                }
            })
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
    var location: String?
    var startDate: Date?
    var endDate: Date?
    var imageUrl: String?
    var image: UIImage?
    var id: String?
    var organiser: String?
    var type: EventTypes?


    convenience init(with dictionary:[String:Any]) {
        self.init()
        let dictionary = JSON(dictionary)
        name = dictionary["name"].string
        location = dictionary["place"]["name"].string
        id = dictionary["id"].string
        if let time = dictionary["start_time"].string {
            startDate = DateFormatters.dateTimeFormatter.date(from: time)
        }
        if let url = dictionary["cover"]["source"].string {
            self.imageUrl = url
        }
        if let time = dictionary["end_time"].string {
            endDate = DateFormatters.dateTimeFormatter.date(from: time)
        }
    }

    convenience init(with id: String) {
        self.init()
        self.id = id
    }
}
