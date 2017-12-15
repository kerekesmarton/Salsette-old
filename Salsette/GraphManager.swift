//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation
import Apollo

extension WorkshopModel {
    fileprivate static func workshops(from event:FetchEventQuery.Data.AllEvent) -> [WorkshopModel]? {
        return event.workshops?.map( { (workshop) -> WorkshopModel in
            let date = WorkshopModel.dateTime(from: workshop.startTime)
            return WorkshopModel(room: workshop.room, startTime: date, artist: workshop.artist, name: workshop.name, eventID: event.id, id: workshop.id)
        })
    }
}

extension EventModel {
    fileprivate static func events(from result: FetchAllEventQuery.Data) -> [EventModel]? {
        return result.allEvents.map({ (event) -> EventModel in
            return EventModel(fbID: event.fbId, type: event.type, id: event.id)
        })
    }
}

class GraphManager {
    private init() {}
    static let shared = GraphManager()
    private static let path = "https://api.graph.cool/simple/v1/salsette"
    let client: ApolloClient = ApolloClient(url: URL(string: GraphManager.path)!)
    
    private var _authorisedClient: ApolloClient?
    private var authorisedClient: ApolloClient? {
        guard let token = token, let url = URL(string: GraphManager.path) else {
            return nil
        }
        guard let client = _authorisedClient else {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
            _authorisedClient =  ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
            return _authorisedClient
        }
        return client
    }
    
    var isLoggedIn: Bool {
        return (token != nil) ? true : false
    }
    
    var token: String? {
        get {
            return KeychainStorage.shared.string(for: GraphManager.tokenKey)
        }
        set {
            KeychainStorage.shared.set(newValue, for: GraphManager.tokenKey)
        }
    }
    private static let tokenKey = "GraphManager.tokenKey"
    
    @discardableResult func createUser(email: String, password: String, closure: @escaping (Bool, Error?)->Void) -> Cancellable {
        let input = AuthProviderSignupData(email: AUTH_PROVIDER_EMAIL(email: email, password: password))
        return client.perform(mutation: CreateUserMutation(data: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(false, self.error(from: serverError))
            } else if let _ = result?.data?.createUser?.id {
                self.signIn(email: email, password: password, closure: closure)
            } else {
                closure(false, error)
            }
        })
    }
    
    @discardableResult func signIn(email: String, password: String, closure: @escaping (Bool, Error?)->Void) -> Cancellable {
        let input = AUTH_PROVIDER_EMAIL(email: email, password: password)
        return client.perform(mutation: LoginMutation(data: input), resultHandler: { (result, error) in
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
    
    func signOut() {
        token = nil
    }
    
    @discardableResult func createEvent(model: EventModel, closure: @escaping (EventModel?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, NSError(with: "Please log in"))
            return nil
        }
        let input = CreateEventMutation(fbId: model.fbID, type: model.type)
        return client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let event = result?.data?.createEvent {
                closure(EventModel(fbID: event.fbId, type: event.type, id: event.id), error)
            }
        })
    }
    
    @discardableResult func searchEvent(fbID: String, closure: @escaping (EventModel?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, NSError(with: "Please log in"))
            return nil
        }
        let query = FetchEventQuery(filter: EventFilter(fbId: fbID))
        return client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, resultHandler: { (result, error) in
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

    @discardableResult func searchEvents(fbIDs: [String], closure: @escaping ([EventModel]?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, NSError(with: "Please log in"))
            return nil
        }
        let query = FetchEventQuery(filter: EventFilter(fbIdIn: fbIDs))
        return client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let _ = error {
                closure(nil, NSError(with: "Please log in again."))
            } else if let events = result?.data?.allEvents {
                let models = events.map({ (event) -> EventModel in
                    EventModel(fbID: event.fbId, type: event.type, id: event.id, workshops: WorkshopModel.workshops(from: event))
                })
                closure(models, nil)
            } else {
                closure(nil, nil)
            }
        })
    }
    
    @discardableResult func serchAllEvents(closure: @escaping ([EventModel]?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, NSError(with: "Please log in"))
            return nil
        }
        return client.fetch(query: FetchAllEventQuery(), cachePolicy: .fetchIgnoringCacheData, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let data = result?.data {
                closure(EventModel.events(from: data), error)
            }
            closure(nil, nil)
        })
    }
    
    @discardableResult func createWorkshop(model: WorkshopModel, eventID: String, closure: @escaping (WorkshopModel?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, NSError(with: "Please log in"))
            return nil
        }
        let input = CreateWorkshopMutation(artist: model.artist!, name: model.name, room: model.room, startTime: model.startTimeToStr, eventId: eventID)
        return client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let workshop = result?.data?.createWorkshop {
                let date = WorkshopModel.dateTime(from: workshop.startTime)
                closure(WorkshopModel(room: workshop.room, startTime: date, artist: workshop.artist, name: workshop.name, eventID: model.eventID, id: workshop.id), nil)
            } else {
                closure(nil, nil)
            }
        })            
    }
    
    @discardableResult func updateWorkshop(model: WorkshopModel, eventID: String, closure: @escaping (WorkshopModel?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, NSError(with: "Please log in"))
            return nil
        }
        let input = UpdateWorkshopMutation(artist: model.artist, name: model.name, room: model.room, startTime: model.startTimeToStr, id: model.id, eventId: eventID)
        return client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let workshop = result?.data?.updateWorkshop {
                let date = WorkshopModel.dateTime(from: workshop.startTime)
                closure(WorkshopModel(room: workshop.room, startTime: date, artist: workshop.artist, name: workshop.name, eventID: model.eventID, id: workshop.id), error)
            } else {
                closure(nil, nil)
            }
        })
    }
    
    
    @discardableResult func deleteWorkshop(id: String, closure: @escaping (Bool?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, NSError(with: "Please log in"))
            return nil
        }
        let input = DeleteWorkshopMutation(id: id)
        return client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(false, self.error(from: serverError))
            } else if result?.data?.deleteWorkshop != nil {
                closure(true, nil)
            } else {
                closure(nil, nil)
            }
        })
    }
    
    
    
    fileprivate func error(from graphQLErrors: [GraphQLError]) -> Error {
        guard let error = graphQLErrors.first else {
            return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:"Unknown error"])
        }
        return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:error.message])
    }
}
