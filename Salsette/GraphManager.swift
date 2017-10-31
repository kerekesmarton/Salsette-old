//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation
import Apollo

class GraphManager {
    private init() {}
    static let shared = GraphManager()
    private let path = "https://eu-west-1.api.scaphold.io/graphql/dance"
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
    
    private var user: Auth0LoginMutation.Data.LoginUserWithAuth0.User?
    private var operation: Cancellable?
    
    func createUser(with token: String, closure: @escaping (Bool, Error?)->Void) {
        let input = LoginUserWithAuth0Input(idToken: token)
        operation = client.perform(mutation: Auth0LoginMutation(token: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(false, self.error(from: serverError))
            } else if let auth = result?.data?.loginUserWithAuth0, let newUser = auth.user, let url = URL(string: self.path) {
                self.token = token
                self.user = newUser
                let configuration = URLSessionConfiguration.default
                configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
                self.loggedInClient = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
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
        guard let client = loggedInClient else {
            closure(nil, error(with: "Please log in"))
            return
        }
        let input = CreateEventInput(fbId: model.fbID, type: model.type, clientMutationId: nil)
        operation = client.perform(mutation: CreateEventMutation(event: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let event = result?.data?.createEvent?.changedEvent {
                closure(event, error)
            }
        })
    }
    
    typealias EventSearchResult = FetchEventQuery.Data.Viewer.AllEvent.Edge.Node
    //FetchEventAlgoliaQuery.Data.Viewer.SearchAlgoliaEvent.Hit.Node

    func searchEvent(fbID: String, closure: @escaping (EventSearchResult?, Error?)->Void) {
        guard let client = loggedInClient else {
            closure(nil, error(with: "Please log in"))
            return
        }
//         let query = FetchEventAlgoliaQuery(fbID: fbID)
        let arg = EventFbIdWhereArgs(eq: fbID)
        let query = FetchEventQuery(where: EventWhereArgs(fbId:arg))
        operation = client.fetch(query: query, cachePolicy: .returnCacheDataElseFetch, queue: DispatchQueue.main, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let _ = error {
                closure(nil, self.error(with: "Please log in again."))
            } else if let edge = result?.data?.viewer?.allEvents?.edges?.first, /* result?.data?.viewer?.searchAlgoliaEvents?.hits?.first */
                let event: EventSearchResult = edge?.node {
                closure(event, error)
            }
        })
    }
    
    typealias AllEventsSearchResult = FetchAllEventsQuery.Data.Viewer.AllEvent.Edge.Node
    func serchAllEvents(closure: @escaping ([AllEventsSearchResult]?, Error?)->Void) {
        guard let client = loggedInClient else {
            closure(nil, error(with: "Please log in"))
            return
        }
        let query = FetchAllEventsQuery()
        operation = client.fetch(query: query, cachePolicy: .returnCacheDataElseFetch, queue: DispatchQueue.main, resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
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
        guard let client = loggedInClient else {
            closure(nil, error(with: "Please log in"))
            return
        }
        let input = CreateWorkshopInput(room: model.room, startTime: model.startTime, artist: model.artist, name: model.name, event: nil, eventId: model.eventID, clientMutationId: nil)
        operation = client.perform(mutation: CreateWorkshopMutation(workshop: input), resultHandler: { (result, error) in
            if let serverError = result?.errors {
                closure(nil, self.error(from: serverError))
            } else if let workshop = result?.data?.createWorkshop?.changedWorkshop {
                closure(workshop, error)
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
