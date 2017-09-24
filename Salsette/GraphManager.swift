//
//  User.swift
//  Salsette
//
//  Created by Marton Kerekes on 05/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Foundation
import Apollo

class GraphManager {
    private  init() {}
    static let shared = GraphManager()
    lazy var client: ApolloClient = {
        return ApolloClient(url: URL(string: "https://eu-west-1.api.scaphold.io/graphql/dance")!)
    }()
    var isLoggedIn: Bool {
        get {
            return (token != nil) ? true : false
        }
    }
    var token: String? {
        get {
            return KeychainStorage.shared[Keys.graphIdToken]
        }
        set {
            KeychainStorage.shared[Keys.graphIdToken] = newValue
        }
    }
    private var user: Auth0LoginMutation.Data.LoginUserWithAuth0.User?
    private var operation: Cancellable?
    
    func createUser(with token: String, closure: @escaping (Bool, Error?)->Void) {
        let input = LoginUserWithAuth0Input(idToken: token)
        operation = client.perform(mutation: Auth0LoginMutation(token: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(false,serverError.first)
            } else if let auth = result?.data?.loginUserWithAuth0,
                let newUser = auth.user {
                self.token = token
                self.user = newUser
                closure(true, error)
            }
            closure(false, error)
        })
    }
    
    struct CreateEventModel {
        let fbID: String
        let type: Dance
    }
    typealias CretedEvent = CreateEventMutation.Data.CreateEvent.ChangedEvent
    func createEvent(model: CreateEventModel, closure: @escaping (CretedEvent?, Error?)->Void) {
        let input = CreateEventInput(fbId: model.fbID, type: model.type, clientMutationId: nil)
        operation = client.perform(mutation: CreateEventMutation(event: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil,serverError.first)
            } else if let event = result?.data?.createEvent?.changedEvent {
                closure(event, error)
            }
            closure(nil, nil)
        })
    }
    
    typealias EventSearchResult = FetchEventQuery.Data.Viewer.SearchAlgoliaEvent.Hit.Node
    func searchEvent(fbID: String, closure: @escaping (EventSearchResult?, Error?)->Void) {
        
        let query = FetchEventQuery(fbId: fbID)
        operation = client.fetch(query: query, cachePolicy: .returnCacheDataElseFetch, queue: DispatchQueue.main, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, serverError.first)
            } else if let hit = result?.data?.viewer?.searchAlgoliaEvents?.hits?.first,
                let event: EventSearchResult = hit?.node {
                closure(event, error)
            }
            closure(nil, nil)
        })
    }
    
    typealias AllEventsSearchResult = FetchAllEventsQuery.Data.Viewer.AllEvent.Edge.Node
    func serchAllEvents(closure: @escaping ([AllEventsSearchResult]?, Error?)->Void) {
        let query = FetchAllEventsQuery()
        operation = client.fetch(query: query, cachePolicy: .returnCacheDataElseFetch, queue: DispatchQueue.main, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil,serverError.first)
            } else if let edges = result?.data?.viewer?.allEvents?.edges {
                closure(edges.flatMap { return $0?.node }, error)
            }
            closure(nil, nil)
        })
    }
    
    struct CreateWorkshopDataModel {
        let room: String
        let startTime: String
        let artist: String
        let name: String
        let eventID: GraphQLID?
    }
    typealias CretedWorkshop = CreateWorkshopMutation.Data.CreateWorkshop.ChangedWorkshop
    func createWorkshop(model: CreateWorkshopDataModel, closure: @escaping (CretedWorkshop?, Error?)->Void) {
        let input = CreateWorkshopInput(room: model.room, startTime: model.startTime, artist: model.artist, name: model.name, event: nil, eventId: model.eventID, clientMutationId: nil)
        operation = client.perform(mutation: CreateWorkshopMutation(workshop: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, serverError.first)
            } else if let workshop = result?.data?.createWorkshop?.changedWorkshop {
                closure(workshop, error)
            }
            closure(nil, error)
        })
    }
}
