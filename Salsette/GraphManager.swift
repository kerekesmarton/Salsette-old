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
            return EventModel(fbID: event.fbId, type: event.type, name: event.name, date: event.date, id: event.id)
        })
    }
}

extension PlaceModel {
    fileprivate static func place(from result: CreateEventMutation.Data.CreateEvent.Place?) -> PlaceModel? {
        guard let result = result else { return nil }
        return PlaceModel(address: result.address, city: result.city, country: result.country, lat: result.lat, lon: result.lon, name: result.name, zip: result.zip)
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
    
    @discardableResult func createEvent(model: EventModel, place: PlaceModel, closure: @escaping (EventModel?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, NSError(with: "Please log in"))
            return nil
        }
        var eventPlace = EventplacePlace(address: place.address, city: place.city, country: place.country, lat: place.lat, lon: place.lon, name: place.name, zip: place.zip)
        eventPlace.graphQLMap["lat"] = Float(String(place.lat))
        eventPlace.graphQLMap["lon"] = Float(String(place.lon))
        let input = CreateEventMutation(date: model.date, fbId: model.fbID, name: model.name, type: model.type, place: eventPlace)
        return client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let event = result?.data?.createEvent, let place = PlaceModel.place(from: event.place) {
                closure(EventModel(fbID: event.fbId, type: event.type, name: event.name, date: event.date, id: event.id, place: place), error)
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
                closure(EventModel(fbID: event.fbId, type: event.type, name: event.name, date: event.date, id: event.id, workshops: WorkshopModel.workshops(from: event)), error)
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
                    EventModel(fbID: event.fbId, type: event.type, name: event.name, date: event.date, id: event.id, workshops: WorkshopModel.workshops(from: event))
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
    
    @discardableResult func deleteEvent(graphID: String, closure: @escaping (Bool?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, NSError(with: "Please log in"))
            return nil
        }
        let input = DeleteEventMutation(id: graphID)
        return client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let _ = error {
                closure(nil, NSError(with: "Please log in again."))
            } else if (result?.data?.deleteEvent?.id) != nil {
                closure(true,nil)
            } else {
                closure(false, nil)
            }
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
    
    
//    @discardableResult func createPlace(model: PlaceModel, closure: @escaping (PlaceModel?, Error?)->()) -> Cancellable? {
//        guard let client = authorisedClient else {
//            closure(nil, NSError(with: "Please log in"))
//            return nil
//        }
//        let input = CreatePlaceMutation(address: model.address, city: model.city, country: model.country, lat: model.lat, lon: model.lon, name: model.name, zip: model.zip, event: )
//        return client.perform(mutation: input) { (result, error) in
//            if let serverError = result?.errors {
//                closure(nil, self.error(from: serverError))
//            } else if let place = result?.data?.createPlace {
//                closure(PlaceModel(address: place.address, city: place.city, country: place.country, lat: place.lat, lon: place.lon, name: place.name, zip: place.zip), error)
//            } else {
//                closure(nil, nil)
//            }
//        }
//    }
    
    fileprivate func error(from graphQLErrors: [GraphQLError]) -> Error {
        guard let error = graphQLErrors.first else {
            return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:"Unknown error"])
        }
        return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:error.message])
    }
}
