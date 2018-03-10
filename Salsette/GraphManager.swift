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
    
    fileprivate static func event(from placeResult: CreatePlaceMutation.Data.CreatePlace.Event?) -> EventModel? {
        guard let event = placeResult else { return nil }
        return EventModel(fbID: event.fbId, type: event.type, name: event.name, date: event.date, id: event.id)
    }
    
    fileprivate static func events(from result: FetchPlacesQuery.Data) -> [EventModel]? {
        return result.allPlaces.flatMap({ (place) -> EventModel? in
            guard let event = place.event else {
                return nil
            }
            let placeModel = PlaceModel(address: place.address, city: place.city, country: place.country, name: place.name, zip: place.zip)
            return EventModel(fbID: event.fbId, type: event.type, name: event.name, date: event.date, id: event.id, place: placeModel)
        })
    }
}

extension PlaceModel {
    fileprivate static func place(from result: CreateEventMutation.Data.CreateEvent.Place?) -> PlaceModel? {
        guard let result = result else { return nil }
        return PlaceModel(address: result.address, city: result.city, country: result.country, name: result.name, zip: result.zip)
    }
}

class GraphManager {
    private init() {}
    static let shared = GraphManager()
    private static let path = "https://api.graph.cool/simple/v1/salsette"
    let client: ApolloClient = ApolloClient(url: URL(string: GraphManager.path)!)
    let graphLoginError: NSError = NSError(domain: "Graph", code: 80, userInfo: [NSLocalizedDescriptionKey:"Please log in"])
    
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
    
    func setToken(_ value: String) {
        token = value
    }
    
    func signOut() {
        token = nil
    }
    
    @discardableResult func createEvent(model: EventModel, place: PlaceModel, closure: @escaping (EventModel?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, graphLoginError)
            return nil
        }
        let eventPlace = EventplacePlace(address: place.address, city: place.city, country: place.country, name: place.name, zip: place.zip)
        let input = CreateEventMutation(date: model.date, fbId: model.fbID, name: model.name, type: model.type, place: eventPlace)
        return client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let event = result?.data?.createEvent, let place = PlaceModel.place(from: event.place) {
                closure(EventModel(fbID: event.fbId, type: event.type, name: event.name, date: event.date, id: event.id, place: place), error)
            }
        })
    }
    
    fileprivate func filter(with parameter: SearchParameters) -> PlaceFilter {
        let startFilter = DateFormatters.graphDateTimeFormatter.string(from: parameter.startDate ?? Date.distantPast)
        let endFilter = DateFormatters.graphDateTimeFormatter.string(from: parameter.endDate ?? Date.distantFuture)
        let eventFilter = EventFilter(dateLte: endFilter, dateGte: startFilter, type: parameter.type)
        let city = parameter.location?.graphLocation()
        return PlaceFilter(cityContains: city, event:eventFilter)
    }
    
    @discardableResult func searchEvent(parameters: SearchParameters, closure: @escaping ([EventModel]?, Error?)->()) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, graphLoginError)
            return nil
        }
        let query = FetchPlacesQuery(filter: filter(with: parameters))
        return client.fetch(query: query) { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let data = result?.data {
                closure(EventModel.events(from: data), nil)
            } else {
                closure(nil, nil)
            }
        }
    }
    
    @discardableResult func searchEvent(fbID: String, closure: @escaping (EventModel?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, graphLoginError)
            return nil
        }
        let query = FetchEventQuery(filter: EventFilter(fbId: fbID))
        return client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let event = result?.data?.allEvents.first {
                closure(EventModel(fbID: event.fbId, type: event.type, name: event.name, date: event.date, id: event.id, workshops: WorkshopModel.workshops(from: event)), error)
            } else {
                closure(nil, nil)
            }
        })
    }

    @discardableResult func searchEvents(fbIDs: [String], closure: @escaping ([EventModel]?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, graphLoginError)
            return nil
        }
        let query = FetchEventQuery(filter: EventFilter(fbIdIn: fbIDs))
        return client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let _ = error {
                closure(nil, self.graphLoginError)
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
            closure(nil, graphLoginError)
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
            closure(nil, graphLoginError)
            return nil
        }
        let input = DeleteEventMutation(id: graphID)
        return client.perform(mutation: input, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let _ = error {
                closure(nil, self.graphLoginError)
            } else if (result?.data?.deleteEvent?.id) != nil {
                closure(true,nil)
            } else {
                closure(false, nil)
            }
        })
    }
    
    @discardableResult func createWorkshop(model: WorkshopModel, eventID: String, closure: @escaping (WorkshopModel?, Error?)->Void) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, graphLoginError)
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
            closure(nil, graphLoginError)
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
            closure(nil, graphLoginError)
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
    
    
    @discardableResult func createPlaceAndEvent(placeModel: PlaceModel, eventModel: EventModel, closure: @escaping (EventModel?, Error?)->()) -> Cancellable? {
        guard let client = authorisedClient else {
            closure(nil, graphLoginError)
            return nil
        }
        
        let eventInput = PlaceeventEvent(date: eventModel.date, fbId: eventModel.fbID, name: eventModel.name, type: eventModel.type)
        let placeInput = CreatePlaceMutation(address: placeModel.address, city: placeModel.city, country: placeModel.country, name: placeModel.name, zip: placeModel.zip, event: eventInput)
        return client.perform(mutation: placeInput) { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let place = result?.data?.createPlace {
                var event = EventModel.event(from: place.event)
                event?.place = PlaceModel(address: place.address, city: place.city, country: place.country, name: place.name, zip: place.zip)
                closure(event, error)
            } else {
                closure(nil, nil)
            }
        }
    }
    
    fileprivate func error(from graphQLErrors: [GraphQLError]) -> Error {
        guard let error = graphQLErrors.first else {
            return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:"Unknown error"])
        }
        return NSError(domain: "Apollo", code: 0, userInfo: [NSLocalizedDescriptionKey:error.message])
    }
}
