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
}

fileprivate extension EventModel {
    static func events(from result: FetchAllEventQuery.Data) -> [EventModel]? {
        return result.allEvents.map({ (event) -> EventModel in
            return EventModel(fbID: event.fbId, type: event.type, id: event.id)
        })
    }
}

struct WorkshopModel {
    let room: String
    let startTime: String
    let artist: String? = nil
    let name: String
    var eventID: String?
    var id: String? = nil

    init(room: String, startTime: String, artist: String, name: String, eventID: String? = nil, id: String? = nil) {
        self.room = room
        self.startTime = startTime
        self.artist = artist
        self.name = name
        self.eventID = eventID
    }
}

fileprivate extension WorkshopModel {
    static func workshops(from event:FetchEventQuery.Data.AllEvent) -> [WorkshopModel]?{
        return event.workshops?.map( { (workshop) -> WorkshopModel in
            return WorkshopModel(room: workshop.room, startTime: workshop.startTime, artist: workshop.artist, name: workshop.name, eventID: event.id)
        })
    }
}

class GraphManager {
    private init() {}
    static let shared = GraphManager()
    private let path = "https://api.graph.cool/simple/v1/salsette"
    lazy var client: ApolloClient = {
        return ApolloClient(url: URL(string: self.path)!)
    }()
    var loggedInClient: ApolloClient?
    var isLoggedIn: Bool {
        get {
            return (token != nil) ? true : false
        }
    }
    var token: String?
    
    private var operation: Cancellable?
    
    func createUser(with token: String, closure: @escaping (Bool, Error?)->Void) {
        let input = AuthProviderSignupData(auth0: AUTH_PROVIDER_AUTH0(idToken: token))
        operation = client.perform(mutation: LoginMutation(data: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(false, self.error(from: serverError))
            } else if let _ = result?.data?.createUser?.auth0UserId, let url = URL(string: self.path) {
                self.token = token
                let configuration = URLSessionConfiguration.default
                configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
                self.loggedInClient = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
                closure(true, error)
            }
            closure(false, error)
        })
    }

    func createEvent(model: EventModel, closure: @escaping (EventModel?, Error?)->Void) {
        guard let client = loggedInClient else {
            closure(nil, error(with: "Please log in"))
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
            closure(nil, error(with: "Please log in"))
            return
        }
        let query = FetchEventQuery(filter: EventFilter(fbId: fbID))
        operation = client.fetch(query: query, cachePolicy: .returnCacheDataElseFetch, queue: DispatchQueue.main, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let _ = error {
                closure(nil, self.error(with: "Please log in again."))
            } else if let event = result?.data?.allEvents.first {
                closure(EventModel(fbID: event.fbId, type: event.type, id: event.id, workshops: WorkshopModel.workshops(from: event)), error)
            }
        })
    }

    func serchAllEvents(closure: @escaping ([EventModel]?, Error?)->Void) {
        guard let client = loggedInClient else {
            closure(nil, error(with: "Please log in"))
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
            closure(nil, error(with: "Please log in"))
            return
        }
        let input = CreateWorkshopMutation(artist: model.artist, name: model.name, room: model.room, startTime: model.startTime, eventId: model.eventID)
        operation = client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let workshop = result?.data?.createWorkshop {
                closure(WorkshopModel(room: workshop.room, startTime: workshop.startTime, artist: workshop.artist, name: workshop.name, eventID: model.eventID), error)
            }
            closure(nil, nil)
        })
    }

    private func error(with message: String) -> Error {
        return NSError(domain: "Client", code: 0, userInfo: [NSLocalizedDescriptionKey:message])
    }
    
    private func error(from graphQLErrors: [GraphQLError]) -> Error {
        guard let error = graphQLErrors.first else {
            return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:"Unknown error"])
        }
        return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:error.message])
    }
}
