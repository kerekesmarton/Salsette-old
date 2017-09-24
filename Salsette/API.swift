//  This file was automatically generated and should not be edited.

import Apollo

public struct LoginUserWithAuth0SocialInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(accessToken: String, connection: ConnectionType, clientMutationId: String? = nil) {
    graphQLMap = ["access_token": accessToken, "connection": connection, "clientMutationId": clientMutationId]
  }
}

/// Values for the ConnectionType enum
public enum ConnectionType: String {
  case ad = "ad"
  case adfs = "adfs"
  case amazon = "amazon"
  case dropbox = "dropbox"
  case bitbucket = "bitbucket"
  case aol = "aol"
  case auth0Adldap = "auth0_adldap"
  case auth0Oidc = "auth0_oidc"
  case auth0 = "auth0"
  case baidu = "baidu"
  case bitly = "bitly"
  case box = "box"
  case custom = "custom"
  case dwolla = "dwolla"
  case email = "email"
  case evernoteSandbox = "evernote_sandbox"
  case evernote = "evernote"
  case exact = "exact"
  case facebook = "facebook"
  case fitbit = "fitbit"
  case flickr = "flickr"
  case github = "github"
  case googleApps = "google_apps"
  case googleOauth2 = "google_oauth2"
  case guardian = "guardian"
  case instagram = "instagram"
  case ip = "ip"
  case linkedin = "linkedin"
  case miicard = "miicard"
  case oauth1 = "oauth1"
  case oauth2 = "oauth2"
  case office365 = "office365"
  case paypal = "paypal"
  case pingfederate = "pingfederate"
  case planningcenter = "planningcenter"
  case renren = "renren"
  case salesforceCommunity = "salesforce_community"
  case salesforceSandbox = "salesforce_sandbox"
  case salesforce = "salesforce"
  case samlp = "samlp"
  case sharepoint = "sharepoint"
  case shopify = "shopify"
  case sms = "sms"
  case soundcloud = "soundcloud"
  case thecitySandbox = "thecity_sandbox"
  case thecity = "thecity"
  case thirtysevensignals = "thirtysevensignals"
  case twitter = "twitter"
  case untappd = "untappd"
  case vkontakte = "vkontakte"
  case waad = "waad"
  case weibo = "weibo"
  case windowslive = "windowslive"
  case wordpress = "wordpress"
  case yahoo = "yahoo"
  case yammer = "yammer"
  case yandex = "yandex"
}

extension ConnectionType: JSONDecodable, JSONEncodable {}

public struct LoginUserWithAuth0Input: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(idToken: String, clientMutationId: String? = nil) {
    graphQLMap = ["idToken": idToken, "clientMutationId": clientMutationId]
  }
}

public struct CreateEventInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(fbId: String? = nil, type: Dance, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["fbID": fbId, "type": type, "clientMutationId": clientMutationId]
  }
}

/// Values for the Dance enum
public enum Dance: String {
  case salsa = "Salsa"
  case bachata = "Bachata"
  case kizomba = "Kizomba"
  case tango = "Tango"
  case dance = "Dance"
}

extension Dance: JSONDecodable, JSONEncodable {}

public struct CreateWorkshopInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(room: String, startTime: String, artist: String? = nil, name: String, event: CreateEventInput? = nil, eventId: GraphQLID? = nil, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["room": room, "startTime": startTime, "artist": artist, "name": name, "event": event, "eventId": eventId, "clientMutationId": clientMutationId]
  }
}

public final class LoginMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation Login($token: LoginUserWithAuth0SocialInput!) {" +
    "  loginUserWithAuth0Social(input: $token) {" +
    "    __typename" +
    "    token" +
    "    user {" +
    "      __typename" +
    "      id" +
    "      username" +
    "    }" +
    "  }" +
    "}"

  public let token: LoginUserWithAuth0SocialInput

  public init(token: LoginUserWithAuth0SocialInput) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLMappable {
    public let loginUserWithAuth0Social: LoginUserWithAuth0Social?

    public init(reader: GraphQLResultReader) throws {
      loginUserWithAuth0Social = try reader.optionalValue(for: Field(responseName: "loginUserWithAuth0Social", arguments: ["input": reader.variables["token"]]))
    }

    public struct LoginUserWithAuth0Social: GraphQLMappable {
      public let __typename: String
      public let token: String?
      public let user: User?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        token = try reader.optionalValue(for: Field(responseName: "token"))
        user = try reader.optionalValue(for: Field(responseName: "user"))
      }

      public struct User: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID
        public let username: String

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
          username = try reader.value(for: Field(responseName: "username"))
        }
      }
    }
  }
}

public final class Auth0LoginMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation Auth0Login($token: LoginUserWithAuth0Input!) {" +
    "  loginUserWithAuth0(input: $token) {" +
    "    __typename" +
    "    user {" +
    "      __typename" +
    "      id" +
    "      username" +
    "    }" +
    "  }" +
    "}"

  public let token: LoginUserWithAuth0Input

  public init(token: LoginUserWithAuth0Input) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLMappable {
    public let loginUserWithAuth0: LoginUserWithAuth0?

    public init(reader: GraphQLResultReader) throws {
      loginUserWithAuth0 = try reader.optionalValue(for: Field(responseName: "loginUserWithAuth0", arguments: ["input": reader.variables["token"]]))
    }

    public struct LoginUserWithAuth0: GraphQLMappable {
      public let __typename: String
      public let user: User?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        user = try reader.optionalValue(for: Field(responseName: "user"))
      }

      public struct User: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID
        public let username: String

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
          username = try reader.value(for: Field(responseName: "username"))
        }
      }
    }
  }
}

public final class CreateEventMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateEvent($event: CreateEventInput!) {" +
    "  createEvent(input: $event) {" +
    "    __typename" +
    "    changedEvent {" +
    "      __typename" +
    "      type" +
    "      fbID" +
    "      id" +
    "    }" +
    "  }" +
    "}"

  public let event: CreateEventInput

  public init(event: CreateEventInput) {
    self.event = event
  }

  public var variables: GraphQLMap? {
    return ["event": event]
  }

  public struct Data: GraphQLMappable {
    public let createEvent: CreateEvent?

    public init(reader: GraphQLResultReader) throws {
      createEvent = try reader.optionalValue(for: Field(responseName: "createEvent", arguments: ["input": reader.variables["event"]]))
    }

    public struct CreateEvent: GraphQLMappable {
      public let __typename: String
      public let changedEvent: ChangedEvent?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        changedEvent = try reader.optionalValue(for: Field(responseName: "changedEvent"))
      }

      public struct ChangedEvent: GraphQLMappable {
        public let __typename: String
        public let type: Dance
        public let fbId: String?
        public let id: GraphQLID

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          type = try reader.value(for: Field(responseName: "type"))
          fbId = try reader.optionalValue(for: Field(responseName: "fbID"))
          id = try reader.value(for: Field(responseName: "id"))
        }
      }
    }
  }
}

public final class FetchEventQuery: GraphQLQuery {
  public static let operationDefinition =
    "query FetchEvent($fbID: String!) {" +
    "  viewer {" +
    "    __typename" +
    "    searchAlgoliaEvents(query: $fbID) {" +
    "      __typename" +
    "      hits {" +
    "        __typename" +
    "        node {" +
    "          __typename" +
    "          type" +
    "          fbID" +
    "          id" +
    "          workshops {" +
    "            __typename" +
    "            edges {" +
    "              __typename" +
    "              node {" +
    "                __typename" +
    "                name" +
    "                startTime" +
    "                artist" +
    "                room" +
    "                id" +
    "              }" +
    "            }" +
    "          }" +
    "        }" +
    "      }" +
    "    }" +
    "  }" +
    "}"

  public let fbId: String

  public init(fbId: String) {
    self.fbId = fbId
  }

  public var variables: GraphQLMap? {
    return ["fbID": fbId]
  }

  public struct Data: GraphQLMappable {
    public let viewer: Viewer?

    public init(reader: GraphQLResultReader) throws {
      viewer = try reader.optionalValue(for: Field(responseName: "viewer"))
    }

    public struct Viewer: GraphQLMappable {
      public let __typename: String
      public let searchAlgoliaEvents: SearchAlgoliaEvent?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        searchAlgoliaEvents = try reader.optionalValue(for: Field(responseName: "searchAlgoliaEvents", arguments: ["query": reader.variables["fbID"]]))
      }

      public struct SearchAlgoliaEvent: GraphQLMappable {
        public let __typename: String
        public let hits: [Hit?]?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          hits = try reader.optionalList(for: Field(responseName: "hits"))
        }

        public struct Hit: GraphQLMappable {
          public let __typename: String
          public let node: Node?

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))
            node = try reader.optionalValue(for: Field(responseName: "node"))
          }

          public struct Node: GraphQLMappable {
            public let __typename: String
            public let type: Dance
            public let fbId: String?
            public let id: GraphQLID
            public let workshops: Workshop?

            public init(reader: GraphQLResultReader) throws {
              __typename = try reader.value(for: Field(responseName: "__typename"))
              type = try reader.value(for: Field(responseName: "type"))
              fbId = try reader.optionalValue(for: Field(responseName: "fbID"))
              id = try reader.value(for: Field(responseName: "id"))
              workshops = try reader.optionalValue(for: Field(responseName: "workshops"))
            }

            public struct Workshop: GraphQLMappable {
              public let __typename: String
              public let edges: [Edge?]?

              public init(reader: GraphQLResultReader) throws {
                __typename = try reader.value(for: Field(responseName: "__typename"))
                edges = try reader.optionalList(for: Field(responseName: "edges"))
              }

              public struct Edge: GraphQLMappable {
                public let __typename: String
                public let node: Node

                public init(reader: GraphQLResultReader) throws {
                  __typename = try reader.value(for: Field(responseName: "__typename"))
                  node = try reader.value(for: Field(responseName: "node"))
                }

                public struct Node: GraphQLMappable {
                  public let __typename: String
                  public let name: String
                  public let startTime: String
                  public let artist: String?
                  public let room: String
                  public let id: GraphQLID

                  public init(reader: GraphQLResultReader) throws {
                    __typename = try reader.value(for: Field(responseName: "__typename"))
                    name = try reader.value(for: Field(responseName: "name"))
                    startTime = try reader.value(for: Field(responseName: "startTime"))
                    artist = try reader.optionalValue(for: Field(responseName: "artist"))
                    room = try reader.value(for: Field(responseName: "room"))
                    id = try reader.value(for: Field(responseName: "id"))
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class FetchAllEventsQuery: GraphQLQuery {
  public static let operationDefinition =
    "query FetchAllEvents {" +
    "  viewer {" +
    "    __typename" +
    "    allEvents {" +
    "      __typename" +
    "      edges {" +
    "        __typename" +
    "        node {" +
    "          __typename" +
    "          type" +
    "          fbID" +
    "          id" +
    "        }" +
    "      }" +
    "    }" +
    "  }" +
    "}"
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let viewer: Viewer?

    public init(reader: GraphQLResultReader) throws {
      viewer = try reader.optionalValue(for: Field(responseName: "viewer"))
    }

    public struct Viewer: GraphQLMappable {
      public let __typename: String
      public let allEvents: AllEvent?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        allEvents = try reader.optionalValue(for: Field(responseName: "allEvents"))
      }

      public struct AllEvent: GraphQLMappable {
        public let __typename: String
        public let edges: [Edge?]?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          edges = try reader.optionalList(for: Field(responseName: "edges"))
        }

        public struct Edge: GraphQLMappable {
          public let __typename: String
          public let node: Node

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))
            node = try reader.value(for: Field(responseName: "node"))
          }

          public struct Node: GraphQLMappable {
            public let __typename: String
            public let type: Dance
            public let fbId: String?
            public let id: GraphQLID

            public init(reader: GraphQLResultReader) throws {
              __typename = try reader.value(for: Field(responseName: "__typename"))
              type = try reader.value(for: Field(responseName: "type"))
              fbId = try reader.optionalValue(for: Field(responseName: "fbID"))
              id = try reader.value(for: Field(responseName: "id"))
            }
          }
        }
      }
    }
  }
}

public final class CreateWorkshopMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateWorkshop($workshop: CreateWorkshopInput!) {" +
    "  createWorkshop(input: $workshop) {" +
    "    __typename" +
    "    changedWorkshop {" +
    "      __typename" +
    "      name" +
    "      event {" +
    "        __typename" +
    "        id" +
    "      }" +
    "      startTime" +
    "      room" +
    "    }" +
    "  }" +
    "}"

  public let workshop: CreateWorkshopInput

  public init(workshop: CreateWorkshopInput) {
    self.workshop = workshop
  }

  public var variables: GraphQLMap? {
    return ["workshop": workshop]
  }

  public struct Data: GraphQLMappable {
    public let createWorkshop: CreateWorkshop?

    public init(reader: GraphQLResultReader) throws {
      createWorkshop = try reader.optionalValue(for: Field(responseName: "createWorkshop", arguments: ["input": reader.variables["workshop"]]))
    }

    public struct CreateWorkshop: GraphQLMappable {
      public let __typename: String
      public let changedWorkshop: ChangedWorkshop?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        changedWorkshop = try reader.optionalValue(for: Field(responseName: "changedWorkshop"))
      }

      public struct ChangedWorkshop: GraphQLMappable {
        public let __typename: String
        public let name: String
        public let event: Event?
        public let startTime: String
        public let room: String

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          name = try reader.value(for: Field(responseName: "name"))
          event = try reader.optionalValue(for: Field(responseName: "event"))
          startTime = try reader.value(for: Field(responseName: "startTime"))
          room = try reader.value(for: Field(responseName: "room"))
        }

        public struct Event: GraphQLMappable {
          public let __typename: String
          public let id: GraphQLID

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))
            id = try reader.value(for: Field(responseName: "id"))
          }
        }
      }
    }
  }
}