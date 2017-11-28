//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation
import Apollo

struct EventModel {
    let fbID: String
    let type: Dance
    var id: String? = nil
    var workshops: [WorkshopModel]? = nil
    
    init(fbID: String, type: Dance, id: String? = nil, workshops: [WorkshopModel]? = nil) {
        self.fbID = fbID
        self.type = type
        self.id = id
        self.workshops = workshops
    }
    
    fileprivate static func events(from result: FetchAllEventQuery.Data) -> [EventModel]? {
        return result.allEvents.map({ (event) -> EventModel in
            return EventModel(fbID: event.fbId, type: event.type, id: event.id)
        })
    }
}

struct WorkshopModel {
    var room: String
    var startTime: Date
    var artist: String? = nil
    var name: String
    var eventID: String? = nil
    var id: String? = nil
    
    init(room: String, startTime: Date, artist: String, name: String, eventID: String? = nil, id: String? = nil) {
        self.room = room
        self.startTime = startTime
        self.artist = artist
        self.name = name
        self.eventID = eventID
    }
    
    var startTimeToStr: String {
        return String(startTime.timeIntervalSince1970)
    }
    
    static func dateTime(from str: String) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(str)!)
    }
    
    fileprivate static func workshops(from event:FetchEventQuery.Data.AllEvent) -> [WorkshopModel]? {
        return event.workshops?.map( { (workshop) -> WorkshopModel in
            let date = WorkshopModel.dateTime(from: workshop.startTime)
            return WorkshopModel(room: workshop.room, startTime: date, artist: workshop.artist, name: workshop.name, eventID: event.id)
        })
    }
}

class GraphManager {
    private init() {}
    static let shared = GraphManager()
    private static let path = "https://api.graph.cool/simple/v1/salsette"
    lazy var client: ApolloClient = {
        return ApolloClient(url: URL(string: GraphManager.path)!)
    }()
    
    var loggedInClient: ApolloClient? {
        guard let token = token, let url = URL(string: GraphManager.path) else {
            return nil
        }
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
        return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }
    var isLoggedIn: Bool {
        get {
            return (token != nil) ? true : false
        }
    }
    var keepMeSignIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: GraphManager.keepMeSignInKey)
        }
        set {
            if newValue == false {
                token = nil
            }
            UserDefaults.standard.set(newValue, forKey: GraphManager.keepMeSignInKey)            
        }
    }
    private var privateToken: String? = nil
    var token: String? {
        get {
            if keepMeSignIn {
                return KeychainStorage.shared.string(for: GraphManager.tokenKey)
            } else {
                return privateToken
            }
        }
        set {
            if keepMeSignIn {
                KeychainStorage.shared.set(newValue, for: GraphManager.tokenKey)
            } else {
                privateToken = newValue
            }
        }
    }
    private static let keepMeSignInKey = "GraphManager.keepMeSignIn"
    private static let tokenKey = "GraphManager.tokenKey"
    fileprivate var operation: Cancellable?
    
    func createUser(email: String, password: String, closure: @escaping (Bool, Error?)->Void) {
        let input = AuthProviderSignupData(email: AUTH_PROVIDER_EMAIL(email: email, password: password))
        operation = client.perform(mutation: CreateUserMutation(data: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(false, self.error(from: serverError))
            } else if let _ = result?.data?.createUser?.id {
                self.signIn(email: email, password: password, closure: closure)
            } else {
                closure(false, error)
            }
        })
    }
    
    func signIn(email: String, password: String, closure: @escaping (Bool, Error?)->Void) {
        let input = AUTH_PROVIDER_EMAIL(email: email, password: password)
        operation = client.perform(mutation: LoginMutation(data: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(false, self.error(from: serverError))
            } else if let token = result?.data?.signinUser.token {
                self.token = token
                closure(true, error)
            } else {
                closure(false, error)
            }
        })
    }
    
    func createEvent(model: EventModel, closure: @escaping (EventModel?, Error?)->Void) {
        guard let client = loggedInClient else {
            closure(nil, NSError(with: "Please log in"))
            return
        }
        let input = CreateEventMutation(fbId: model.fbID, type: model.type)
        operation = client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let event = result?.data?.createEvent {
                closure(EventModel(fbID: event.fbId, type: event.type, id: event.id), error)
            }
        })
    }
    
    func searchEvent(fbID: String, closure: @escaping (EventModel?, Error?)->Void) {
        guard let client = loggedInClient else {
            closure(nil, NSError(with: "Please log in"))
            return
        }
        let query = FetchEventQuery(filter: EventFilter(fbId: fbID))
        operation = client.fetch(query: query, cachePolicy: .returnCacheDataElseFetch, queue: DispatchQueue.main, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let _ = error {
                closure(nil, NSError(with: "Please log in again."))
            } else if let event = result?.data?.allEvents.first {
                closure(EventModel(fbID: event.fbId, type: event.type, id: event.id, workshops: WorkshopModel.workshops(from: event)), error)
            } else {
                closure(nil, nil)
            }
        })
    }
    
    func serchAllEvents(closure: @escaping ([EventModel]?, Error?)->Void) {
        guard let client = loggedInClient else {
            closure(nil, NSError(with: "Please log in"))
            return
        }
        operation = client.fetch(query: FetchAllEventQuery(), cachePolicy: .returnCacheDataElseFetch, queue: DispatchQueue.main, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let data = result?.data {
                closure(EventModel.events(from: data), error)
            }
            closure(nil, nil)
        })
    }
    
    
    func createWorkshop(model: WorkshopModel, closure: @escaping (WorkshopModel?, Error?)->Void) {
        guard let client = loggedInClient else {
            closure(nil, NSError(with: "Please log in"))
            return
        }
        
        let input = CreateWorkshopMutation(artist: model.artist!, name: model.name, room: model.room, startTime: model.startTimeToStr, eventId: model.eventID)
        operation = client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let workshop = result?.data?.createWorkshop {
                let date = WorkshopModel.dateTime(from: workshop.startTime)
                closure(WorkshopModel(room: workshop.room, startTime: date, artist: workshop.artist, name: workshop.name, eventID: model.eventID), error)
            }
            closure(nil, nil)
        })
    }
    
    fileprivate func error(from graphQLErrors: [GraphQLError]) -> Error {
        guard let error = graphQLErrors.first else {
            return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:"Unknown error"])
        }
        return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:error.message])
    }
}
