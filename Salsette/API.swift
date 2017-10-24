//  This file was automatically generated and should not be edited.

import Apollo

public struct LoginUserWithAuth0SocialInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(accessToken: String, connection: ConnectionType, clientMutationId: Optional<String?> = nil) {
    graphQLMap = ["access_token": accessToken, "connection": connection, "clientMutationId": clientMutationId]
  }

  /// The access token of the the social authentication connection. This should be
  /// obtained via an SDK through connections like Facebook, Twitter, or Google.
  public var accessToken: String {
    get {
      return graphQLMap["accessToken"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "accessToken")
    }
  }

  /// The social connection name (i.e. Facebook, Google, Twitter, etc...).
  public var connection: ConnectionType {
    get {
      return graphQLMap["connection"] as! ConnectionType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "connection")
    }
  }

  /// An opaque string used by frontend frameworks like relay to track requests and responses.
  public var clientMutationId: Optional<String?> {
    get {
      return graphQLMap["clientMutationId"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientMutationId")
    }
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

extension ConnectionType: Apollo.JSONDecodable, Apollo.JSONEncodable {}

public struct LoginUserWithAuth0Input: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(idToken: String, clientMutationId: Optional<String?> = nil) {
    graphQLMap = ["idToken": idToken, "clientMutationId": clientMutationId]
  }

  public var idToken: String {
    get {
      return graphQLMap["idToken"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idToken")
    }
  }

  /// An opaque string used by frontend frameworks like relay to track requests and responses.
  public var clientMutationId: Optional<String?> {
    get {
      return graphQLMap["clientMutationId"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientMutationId")
    }
  }
}

public struct CreateEventInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(fbId: Optional<String?> = nil, type: Dance, clientMutationId: Optional<GraphQLID?> = nil) {
    graphQLMap = ["fbID": fbId, "type": type, "clientMutationId": clientMutationId]
  }

  public var fbId: Optional<String?> {
    get {
      return graphQLMap["fbId"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbId")
    }
  }

  public var type: Dance {
    get {
      return graphQLMap["type"] as! Dance
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var clientMutationId: Optional<GraphQLID?> {
    get {
      return graphQLMap["clientMutationId"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientMutationId")
    }
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

extension Dance: Apollo.JSONDecodable, Apollo.JSONEncodable {}

/// Where filter arguments for the Event type
public struct EventWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(modifiedAt: Optional<EventModifiedAtWhereArgs?> = nil, fbId: Optional<EventFbIdWhereArgs?> = nil, id: Optional<EventIdWhereArgs?> = nil, createdAt: Optional<EventCreatedAtWhereArgs?> = nil, workshops: Optional<WorkshopWhereArgs?> = nil, type: Optional<EventTypeWhereArgs?> = nil, or: Optional<[EventWhereArgs?]?> = nil, and: Optional<[EventWhereArgs?]?> = nil) {
    graphQLMap = ["modifiedAt": modifiedAt, "fbID": fbId, "id": id, "createdAt": createdAt, "workshops": workshops, "type": type, "OR": or, "AND": and]
  }

  /// Filter results for on the modifiedAt field.
  public var modifiedAt: Optional<EventModifiedAtWhereArgs?> {
    get {
      return graphQLMap["modifiedAt"] as! Optional<EventModifiedAtWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "modifiedAt")
    }
  }

  /// Filter results for on the fbID field.
  public var fbId: Optional<EventFbIdWhereArgs?> {
    get {
      return graphQLMap["fbId"] as! Optional<EventFbIdWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbId")
    }
  }

  /// Filter results for on the id field.
  public var id: Optional<EventIdWhereArgs?> {
    get {
      return graphQLMap["id"] as! Optional<EventIdWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  /// Filter results for on the createdAt field.
  public var createdAt: Optional<EventCreatedAtWhereArgs?> {
    get {
      return graphQLMap["createdAt"] as! Optional<EventCreatedAtWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  /// Filter results based on a related object via the workshops connection
  public var workshops: Optional<WorkshopWhereArgs?> {
    get {
      return graphQLMap["workshops"] as! Optional<WorkshopWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "workshops")
    }
  }

  /// Filter results for on the type field.
  public var type: Optional<EventTypeWhereArgs?> {
    get {
      return graphQLMap["type"] as! Optional<EventTypeWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  /// Combine mutiple where expressions using the OR operator.
  public var or: Optional<[EventWhereArgs?]?> {
    get {
      return graphQLMap["or"] as! Optional<[EventWhereArgs?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  /// Combine mutiple where expressions using the AND operator.
  public var and: Optional<[EventWhereArgs?]?> {
    get {
      return graphQLMap["and"] as! Optional<[EventWhereArgs?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }
}

public struct EventModifiedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<String?> = nil, ne: Optional<String?> = nil, gt: Optional<String?> = nil, gte: Optional<String?> = nil, lt: Optional<String?> = nil, lte: Optional<String?> = nil, between: Optional<[String?]?> = nil, notBetween: Optional<[String?]?> = nil, `in`: Optional<[String?]?> = nil, notIn: Optional<[String?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<String?> {
    get {
      return graphQLMap["gte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<String?> {
    get {
      return graphQLMap["lte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[String?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[String?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[String?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct EventFbIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<String?> = nil, ne: Optional<String?> = nil, gt: Optional<String?> = nil, gte: Optional<String?> = nil, lt: Optional<String?> = nil, lte: Optional<String?> = nil, between: Optional<[String?]?> = nil, notBetween: Optional<[String?]?> = nil, `in`: Optional<[String?]?> = nil, notIn: Optional<[String?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<String?> {
    get {
      return graphQLMap["gte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<String?> {
    get {
      return graphQLMap["lte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[String?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[String?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[String?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct EventIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<GraphQLID?> = nil, ne: Optional<GraphQLID?> = nil, `in`: Optional<[GraphQLID?]?> = nil, notIn: Optional<[GraphQLID?]?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<GraphQLID?> {
    get {
      return graphQLMap["eq"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<GraphQLID?> {
    get {
      return graphQLMap["ne"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[GraphQLID?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[GraphQLID?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[GraphQLID?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[GraphQLID?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct EventCreatedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<String?> = nil, ne: Optional<String?> = nil, gt: Optional<String?> = nil, gte: Optional<String?> = nil, lt: Optional<String?> = nil, lte: Optional<String?> = nil, between: Optional<[String?]?> = nil, notBetween: Optional<[String?]?> = nil, `in`: Optional<[String?]?> = nil, notIn: Optional<[String?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<String?> {
    get {
      return graphQLMap["gte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<String?> {
    get {
      return graphQLMap["lte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[String?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[String?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[String?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

/// Where filter arguments for the Workshop type
public struct WorkshopWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: Optional<WorkshopIdWhereArgs?> = nil, modifiedAt: Optional<WorkshopModifiedAtWhereArgs?> = nil, room: Optional<WorkshopRoomWhereArgs?> = nil, startTime: Optional<WorkshopStartTimeWhereArgs?> = nil, artist: Optional<WorkshopArtistWhereArgs?> = nil, createdAt: Optional<WorkshopCreatedAtWhereArgs?> = nil, name: Optional<WorkshopNameWhereArgs?> = nil, event: Optional<EventWhereArgs?> = nil, eventId: Optional<WorkshopEventIdWhereArgs?> = nil, or: Optional<[WorkshopWhereArgs?]?> = nil, and: Optional<[WorkshopWhereArgs?]?> = nil) {
    graphQLMap = ["id": id, "modifiedAt": modifiedAt, "room": room, "startTime": startTime, "artist": artist, "createdAt": createdAt, "name": name, "event": event, "eventId": eventId, "OR": or, "AND": and]
  }

  /// Filter results for on the id field.
  public var id: Optional<WorkshopIdWhereArgs?> {
    get {
      return graphQLMap["id"] as! Optional<WorkshopIdWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  /// Filter results for on the modifiedAt field.
  public var modifiedAt: Optional<WorkshopModifiedAtWhereArgs?> {
    get {
      return graphQLMap["modifiedAt"] as! Optional<WorkshopModifiedAtWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "modifiedAt")
    }
  }

  /// Filter results for on the room field.
  public var room: Optional<WorkshopRoomWhereArgs?> {
    get {
      return graphQLMap["room"] as! Optional<WorkshopRoomWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "room")
    }
  }

  /// Filter results for on the startTime field.
  public var startTime: Optional<WorkshopStartTimeWhereArgs?> {
    get {
      return graphQLMap["startTime"] as! Optional<WorkshopStartTimeWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTime")
    }
  }

  /// Filter results for on the artist field.
  public var artist: Optional<WorkshopArtistWhereArgs?> {
    get {
      return graphQLMap["artist"] as! Optional<WorkshopArtistWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artist")
    }
  }

  /// Filter results for on the createdAt field.
  public var createdAt: Optional<WorkshopCreatedAtWhereArgs?> {
    get {
      return graphQLMap["createdAt"] as! Optional<WorkshopCreatedAtWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  /// Filter results for on the name field.
  public var name: Optional<WorkshopNameWhereArgs?> {
    get {
      return graphQLMap["name"] as! Optional<WorkshopNameWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  /// Filter results based on a related object via the event connection
  public var event: Optional<EventWhereArgs?> {
    get {
      return graphQLMap["event"] as! Optional<EventWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "event")
    }
  }

  /// Filter results for on the eventId field.
  public var eventId: Optional<WorkshopEventIdWhereArgs?> {
    get {
      return graphQLMap["eventId"] as! Optional<WorkshopEventIdWhereArgs?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eventId")
    }
  }

  /// Combine mutiple where expressions using the OR operator.
  public var or: Optional<[WorkshopWhereArgs?]?> {
    get {
      return graphQLMap["or"] as! Optional<[WorkshopWhereArgs?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  /// Combine mutiple where expressions using the AND operator.
  public var and: Optional<[WorkshopWhereArgs?]?> {
    get {
      return graphQLMap["and"] as! Optional<[WorkshopWhereArgs?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }
}

public struct WorkshopIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<GraphQLID?> = nil, ne: Optional<GraphQLID?> = nil, `in`: Optional<[GraphQLID?]?> = nil, notIn: Optional<[GraphQLID?]?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<GraphQLID?> {
    get {
      return graphQLMap["eq"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<GraphQLID?> {
    get {
      return graphQLMap["ne"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[GraphQLID?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[GraphQLID?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[GraphQLID?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[GraphQLID?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct WorkshopModifiedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<String?> = nil, ne: Optional<String?> = nil, gt: Optional<String?> = nil, gte: Optional<String?> = nil, lt: Optional<String?> = nil, lte: Optional<String?> = nil, between: Optional<[String?]?> = nil, notBetween: Optional<[String?]?> = nil, `in`: Optional<[String?]?> = nil, notIn: Optional<[String?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<String?> {
    get {
      return graphQLMap["gte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<String?> {
    get {
      return graphQLMap["lte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[String?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[String?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[String?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct WorkshopRoomWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<String?> = nil, ne: Optional<String?> = nil, gt: Optional<String?> = nil, gte: Optional<String?> = nil, lt: Optional<String?> = nil, lte: Optional<String?> = nil, between: Optional<[String?]?> = nil, notBetween: Optional<[String?]?> = nil, `in`: Optional<[String?]?> = nil, notIn: Optional<[String?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<String?> {
    get {
      return graphQLMap["gte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<String?> {
    get {
      return graphQLMap["lte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[String?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[String?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[String?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct WorkshopStartTimeWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<String?> = nil, ne: Optional<String?> = nil, gt: Optional<String?> = nil, gte: Optional<String?> = nil, lt: Optional<String?> = nil, lte: Optional<String?> = nil, between: Optional<[String?]?> = nil, notBetween: Optional<[String?]?> = nil, `in`: Optional<[String?]?> = nil, notIn: Optional<[String?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<String?> {
    get {
      return graphQLMap["gte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<String?> {
    get {
      return graphQLMap["lte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[String?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[String?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[String?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct WorkshopArtistWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<String?> = nil, ne: Optional<String?> = nil, gt: Optional<String?> = nil, gte: Optional<String?> = nil, lt: Optional<String?> = nil, lte: Optional<String?> = nil, between: Optional<[String?]?> = nil, notBetween: Optional<[String?]?> = nil, `in`: Optional<[String?]?> = nil, notIn: Optional<[String?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<String?> {
    get {
      return graphQLMap["gte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<String?> {
    get {
      return graphQLMap["lte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[String?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[String?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[String?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct WorkshopCreatedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<String?> = nil, ne: Optional<String?> = nil, gt: Optional<String?> = nil, gte: Optional<String?> = nil, lt: Optional<String?> = nil, lte: Optional<String?> = nil, between: Optional<[String?]?> = nil, notBetween: Optional<[String?]?> = nil, `in`: Optional<[String?]?> = nil, notIn: Optional<[String?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<String?> {
    get {
      return graphQLMap["gte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<String?> {
    get {
      return graphQLMap["lte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[String?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[String?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[String?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct WorkshopNameWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<String?> = nil, ne: Optional<String?> = nil, gt: Optional<String?> = nil, gte: Optional<String?> = nil, lt: Optional<String?> = nil, lte: Optional<String?> = nil, between: Optional<[String?]?> = nil, notBetween: Optional<[String?]?> = nil, `in`: Optional<[String?]?> = nil, notIn: Optional<[String?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<String?> {
    get {
      return graphQLMap["gte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<String?> {
    get {
      return graphQLMap["lte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[String?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[String?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[String?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct WorkshopEventIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<GraphQLID?> = nil, ne: Optional<GraphQLID?> = nil, `in`: Optional<[GraphQLID?]?> = nil, notIn: Optional<[GraphQLID?]?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<GraphQLID?> {
    get {
      return graphQLMap["eq"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<GraphQLID?> {
    get {
      return graphQLMap["ne"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[GraphQLID?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[GraphQLID?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[GraphQLID?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[GraphQLID?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct EventTypeWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Optional<Dance?> = nil, ne: Optional<Dance?> = nil, gt: Optional<Dance?> = nil, gte: Optional<Dance?> = nil, lt: Optional<Dance?> = nil, lte: Optional<Dance?> = nil, between: Optional<[Dance?]?> = nil, notBetween: Optional<[Dance?]?> = nil, `in`: Optional<[Dance?]?> = nil, notIn: Optional<[Dance?]?> = nil, like: Optional<String?> = nil, notLike: Optional<String?> = nil, isNull: Optional<Bool?> = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }

  /// Equal to. This takes a higher precedence than the other operators.
  public var eq: Optional<Dance?> {
    get {
      return graphQLMap["eq"] as! Optional<Dance?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  /// Not equal to.
  public var ne: Optional<Dance?> {
    get {
      return graphQLMap["ne"] as! Optional<Dance?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  /// Greater than.
  public var gt: Optional<Dance?> {
    get {
      return graphQLMap["gt"] as! Optional<Dance?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  /// Greater than or equal to.
  public var gte: Optional<Dance?> {
    get {
      return graphQLMap["gte"] as! Optional<Dance?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gte")
    }
  }

  /// Less than.
  public var lt: Optional<Dance?> {
    get {
      return graphQLMap["lt"] as! Optional<Dance?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  /// Less than or equal to.
  public var lte: Optional<Dance?> {
    get {
      return graphQLMap["lte"] as! Optional<Dance?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lte")
    }
  }

  /// A two element tuple describing a range of values.
  public var between: Optional<[Dance?]?> {
    get {
      return graphQLMap["between"] as! Optional<[Dance?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  /// A two element tuple describing an excluded range of values.
  public var notBetween: Optional<[Dance?]?> {
    get {
      return graphQLMap["notBetween"] as! Optional<[Dance?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notBetween")
    }
  }

  /// A list of values to include.
  public var `in`: Optional<[Dance?]?> {
    get {
      return graphQLMap["`in`"] as! Optional<[Dance?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "`in`")
    }
  }

  /// A list of values to exclude.
  public var notIn: Optional<[Dance?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[Dance?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }

  /// A pattern to match for likeness.
  public var like: Optional<String?> {
    get {
      return graphQLMap["like"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "like")
    }
  }

  /// A pattern to match for likeness and exclude.
  public var notLike: Optional<String?> {
    get {
      return graphQLMap["notLike"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notLike")
    }
  }

  /// Filters for null values. This takes precedence after 'eq' but before all other fields
  public var isNull: Optional<Bool?> {
    get {
      return graphQLMap["isNull"] as! Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isNull")
    }
  }
}

public struct CreateWorkshopInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(room: String, startTime: String, artist: Optional<String?> = nil, name: String, event: Optional<CreateEventInput?> = nil, eventId: Optional<GraphQLID?> = nil, clientMutationId: Optional<GraphQLID?> = nil) {
    graphQLMap = ["room": room, "startTime": startTime, "artist": artist, "name": name, "event": event, "eventId": eventId, "clientMutationId": clientMutationId]
  }

  public var room: String {
    get {
      return graphQLMap["room"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "room")
    }
  }

  public var startTime: String {
    get {
      return graphQLMap["startTime"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTime")
    }
  }

  public var artist: Optional<String?> {
    get {
      return graphQLMap["artist"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artist")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var event: Optional<CreateEventInput?> {
    get {
      return graphQLMap["event"] as! Optional<CreateEventInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "event")
    }
  }

  public var eventId: Optional<GraphQLID?> {
    get {
      return graphQLMap["eventId"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eventId")
    }
  }

  public var clientMutationId: Optional<GraphQLID?> {
    get {
      return graphQLMap["clientMutationId"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientMutationId")
    }
  }
}

public final class LoginMutation: GraphQLMutation {
  public static let operationString =
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

  public var token: LoginUserWithAuth0SocialInput

  public init(token: LoginUserWithAuth0SocialInput) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("loginUserWithAuth0Social", arguments: ["input": Variable("token")], type: .object(LoginUserWithAuth0Social.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(loginUserWithAuth0Social: LoginUserWithAuth0Social? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "loginUserWithAuth0Social": loginUserWithAuth0Social])
    }

    /// The input object type used to log in a user with Auth0 Social
    public var loginUserWithAuth0Social: LoginUserWithAuth0Social? {
      get {
        return (snapshot["loginUserWithAuth0Social"]! as! Snapshot?).flatMap { LoginUserWithAuth0Social(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "loginUserWithAuth0Social")
      }
    }

    public struct LoginUserWithAuth0Social: GraphQLSelectionSet {
      public static let possibleTypes = ["LoginUserWithAuth0SocialPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .scalar(String.self)),
        GraphQLField("user", type: .object(User.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(token: String? = nil, user: User? = nil) {
        self.init(snapshot: ["__typename": "LoginUserWithAuth0SocialPayload", "token": token, "user": user])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The id token of the logged in user issued from the
      /// social authentication connection.
      public var token: String? {
        get {
          return snapshot["token"]! as! String?
        }
        set {
          snapshot.updateValue(newValue, forKey: "token")
        }
      }

      /// The mutated User.
      public var user: User? {
        get {
          return (snapshot["user"]! as! Snapshot?).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("username", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, username: String) {
          self.init(snapshot: ["__typename": "User", "id": id, "username": username])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A globally unique ID.
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// The user's username.
        public var username: String {
          get {
            return snapshot["username"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "username")
          }
        }
      }
    }
  }
}

public final class Auth0LoginMutation: GraphQLMutation {
  public static let operationString =
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

  public var token: LoginUserWithAuth0Input

  public init(token: LoginUserWithAuth0Input) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("loginUserWithAuth0", arguments: ["input": Variable("token")], type: .object(LoginUserWithAuth0.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(loginUserWithAuth0: LoginUserWithAuth0? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "loginUserWithAuth0": loginUserWithAuth0])
    }

    public var loginUserWithAuth0: LoginUserWithAuth0? {
      get {
        return (snapshot["loginUserWithAuth0"]! as! Snapshot?).flatMap { LoginUserWithAuth0(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "loginUserWithAuth0")
      }
    }

    public struct LoginUserWithAuth0: GraphQLSelectionSet {
      public static let possibleTypes = ["LoginUserWithAuth0Payload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("user", type: .object(User.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(user: User? = nil) {
        self.init(snapshot: ["__typename": "LoginUserWithAuth0Payload", "user": user])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The mutated User.
      public var user: User? {
        get {
          return (snapshot["user"]! as! Snapshot?).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("username", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, username: String) {
          self.init(snapshot: ["__typename": "User", "id": id, "username": username])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A globally unique ID.
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// The user's username.
        public var username: String {
          get {
            return snapshot["username"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "username")
          }
        }
      }
    }
  }
}

public final class CreateEventMutation: GraphQLMutation {
  public static let operationString =
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

  public var event: CreateEventInput

  public init(event: CreateEventInput) {
    self.event = event
  }

  public var variables: GraphQLMap? {
    return ["event": event]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createEvent", arguments: ["input": Variable("event")], type: .object(CreateEvent.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createEvent: CreateEvent? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createEvent": createEvent])
    }

    /// Create objects of type Event.
    public var createEvent: CreateEvent? {
      get {
        return (snapshot["createEvent"]! as! Snapshot?).flatMap { CreateEvent(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createEvent")
      }
    }

    public struct CreateEvent: GraphQLSelectionSet {
      public static let possibleTypes = ["CreateEventPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("changedEvent", type: .object(ChangedEvent.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(changedEvent: ChangedEvent? = nil) {
        self.init(snapshot: ["__typename": "CreateEventPayload", "changedEvent": changedEvent])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The mutated Event.
      public var changedEvent: ChangedEvent? {
        get {
          return (snapshot["changedEvent"]! as! Snapshot?).flatMap { ChangedEvent(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "changedEvent")
        }
      }

      public struct ChangedEvent: GraphQLSelectionSet {
        public static let possibleTypes = ["Event"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(Dance.self))),
          GraphQLField("fbID", type: .scalar(String.self)),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(type: Dance, fbId: String? = nil, id: GraphQLID) {
          self.init(snapshot: ["__typename": "Event", "type": type, "fbID": fbId, "id": id])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var type: Dance {
          get {
            return snapshot["type"]! as! Dance
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var fbId: String? {
          get {
            return snapshot["fbID"]! as! String?
          }
          set {
            snapshot.updateValue(newValue, forKey: "fbID")
          }
        }

        /// A globally unique ID.
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

public final class FetchEventQuery: GraphQLQuery {
  public static let operationString =
    "query FetchEvent($where: EventWhereArgs!) {" +
    "  viewer {" +
    "    __typename" +
    "    allEvents(where: $where) {" +
    "      __typename" +
    "      edges {" +
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

  public var `where`: EventWhereArgs

  public init(`where`: EventWhereArgs) {
    self.`where` = `where`
  }

  public var variables: GraphQLMap? {
    return ["where": `where`]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("viewer", type: .object(Viewer.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(viewer: Viewer? = nil) {
      self.init(snapshot: ["__typename": "Query", "viewer": viewer])
    }

    public var viewer: Viewer? {
      get {
        return (snapshot["viewer"]! as! Snapshot?).flatMap { Viewer(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes = ["Viewer"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("allEvents", arguments: ["where": Variable("where")], type: .object(AllEvent.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(allEvents: AllEvent? = nil) {
        self.init(snapshot: ["__typename": "Viewer", "allEvents": allEvents])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Sift through all objects of type 'Event'.
      public var allEvents: AllEvent? {
        get {
          return (snapshot["allEvents"]! as! Snapshot?).flatMap { AllEvent(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "allEvents")
        }
      }

      public struct AllEvent: GraphQLSelectionSet {
        public static let possibleTypes = ["EventConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .list(.object(Edge.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(edges: [Edge?]? = nil) {
          self.init(snapshot: ["__typename": "EventConnection", "edges": edges])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The set of edges in this page.
        public var edges: [Edge?]? {
          get {
            return (snapshot["edges"]! as! [Snapshot?]?).flatMap { $0.map { $0.flatMap { Edge(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes = ["EventEdge"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .nonNull(.object(Node.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(node: Node) {
            self.init(snapshot: ["__typename": "EventEdge", "node": node])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The node value for the edge.
          public var node: Node {
            get {
              return Node(snapshot: snapshot["node"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes = ["Event"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(Dance.self))),
              GraphQLField("fbID", type: .scalar(String.self)),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("workshops", type: .object(Workshop.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(type: Dance, fbId: String? = nil, id: GraphQLID, workshops: Workshop? = nil) {
              self.init(snapshot: ["__typename": "Event", "type": type, "fbID": fbId, "id": id, "workshops": workshops])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var type: Dance {
              get {
                return snapshot["type"]! as! Dance
              }
              set {
                snapshot.updateValue(newValue, forKey: "type")
              }
            }

            public var fbId: String? {
              get {
                return snapshot["fbID"]! as! String?
              }
              set {
                snapshot.updateValue(newValue, forKey: "fbID")
              }
            }

            /// A globally unique ID.
            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            public var workshops: Workshop? {
              get {
                return (snapshot["workshops"]! as! Snapshot?).flatMap { Workshop(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "workshops")
              }
            }

            public struct Workshop: GraphQLSelectionSet {
              public static let possibleTypes = ["WorkshopConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("edges", type: .list(.object(Edge.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(edges: [Edge?]? = nil) {
                self.init(snapshot: ["__typename": "WorkshopConnection", "edges": edges])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The set of edges in this page.
              public var edges: [Edge?]? {
                get {
                  return (snapshot["edges"]! as! [Snapshot?]?).flatMap { $0.map { $0.flatMap { Edge(snapshot: $0) } } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "edges")
                }
              }

              public struct Edge: GraphQLSelectionSet {
                public static let possibleTypes = ["WorkshopEdge"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("node", type: .nonNull(.object(Node.self))),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(node: Node) {
                  self.init(snapshot: ["__typename": "WorkshopEdge", "node": node])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The node value for the edge.
                public var node: Node {
                  get {
                    return Node(snapshot: snapshot["node"]! as! Snapshot)
                  }
                  set {
                    snapshot.updateValue(newValue.snapshot, forKey: "node")
                  }
                }

                public struct Node: GraphQLSelectionSet {
                  public static let possibleTypes = ["Workshop"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("startTime", type: .nonNull(.scalar(String.self))),
                    GraphQLField("artist", type: .scalar(String.self)),
                    GraphQLField("room", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(name: String, startTime: String, artist: String? = nil, room: String, id: GraphQLID) {
                    self.init(snapshot: ["__typename": "Workshop", "name": name, "startTime": startTime, "artist": artist, "room": room, "id": id])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var name: String {
                    get {
                      return snapshot["name"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "name")
                    }
                  }

                  public var startTime: String {
                    get {
                      return snapshot["startTime"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "startTime")
                    }
                  }

                  public var artist: String? {
                    get {
                      return snapshot["artist"]! as! String?
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "artist")
                    }
                  }

                  public var room: String {
                    get {
                      return snapshot["room"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "room")
                    }
                  }

                  /// A globally unique ID.
                  public var id: GraphQLID {
                    get {
                      return snapshot["id"]! as! GraphQLID
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "id")
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
}

public final class FetchEventAlgoliaQuery: GraphQLQuery {
  public static let operationString =
    "query FetchEventAlgolia($fbID: String!) {" +
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

  public var fbID: String

  public init(fbID: String) {
    self.fbID = fbID
  }

  public var variables: GraphQLMap? {
    return ["fbID": fbID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("viewer", type: .object(Viewer.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(viewer: Viewer? = nil) {
      self.init(snapshot: ["__typename": "Query", "viewer": viewer])
    }

    public var viewer: Viewer? {
      get {
        return (snapshot["viewer"]! as! Snapshot?).flatMap { Viewer(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes = ["Viewer"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("searchAlgoliaEvents", arguments: ["query": Variable("fbID")], type: .object(SearchAlgoliaEvent.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(searchAlgoliaEvents: SearchAlgoliaEvent? = nil) {
        self.init(snapshot: ["__typename": "Viewer", "searchAlgoliaEvents": searchAlgoliaEvents])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Searches Algolia for the Event type by query term
      public var searchAlgoliaEvents: SearchAlgoliaEvent? {
        get {
          return (snapshot["searchAlgoliaEvents"]! as! Snapshot?).flatMap { SearchAlgoliaEvent(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "searchAlgoliaEvents")
        }
      }

      public struct SearchAlgoliaEvent: GraphQLSelectionSet {
        public static let possibleTypes = ["SearchAlgoliaEventByQueryResults"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("hits", type: .list(.object(Hit.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(hits: [Hit?]? = nil) {
          self.init(snapshot: ["__typename": "SearchAlgoliaEventByQueryResults", "hits": hits])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Search results hit provided by Algolia.
        public var hits: [Hit?]? {
          get {
            return (snapshot["hits"]! as! [Snapshot?]?).flatMap { $0.map { $0.flatMap { Hit(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "hits")
          }
        }

        public struct Hit: GraphQLSelectionSet {
          public static let possibleTypes = ["AlgoliaEventSearchHit"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(node: Node? = nil) {
            self.init(snapshot: ["__typename": "AlgoliaEventSearchHit", "node": node])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The Event object
          public var node: Node? {
            get {
              return (snapshot["node"]! as! Snapshot?).flatMap { Node(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes = ["Event"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(Dance.self))),
              GraphQLField("fbID", type: .scalar(String.self)),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("workshops", type: .object(Workshop.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(type: Dance, fbId: String? = nil, id: GraphQLID, workshops: Workshop? = nil) {
              self.init(snapshot: ["__typename": "Event", "type": type, "fbID": fbId, "id": id, "workshops": workshops])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var type: Dance {
              get {
                return snapshot["type"]! as! Dance
              }
              set {
                snapshot.updateValue(newValue, forKey: "type")
              }
            }

            public var fbId: String? {
              get {
                return snapshot["fbID"]! as! String?
              }
              set {
                snapshot.updateValue(newValue, forKey: "fbID")
              }
            }

            /// A globally unique ID.
            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            public var workshops: Workshop? {
              get {
                return (snapshot["workshops"]! as! Snapshot?).flatMap { Workshop(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "workshops")
              }
            }

            public struct Workshop: GraphQLSelectionSet {
              public static let possibleTypes = ["WorkshopConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("edges", type: .list(.object(Edge.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(edges: [Edge?]? = nil) {
                self.init(snapshot: ["__typename": "WorkshopConnection", "edges": edges])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The set of edges in this page.
              public var edges: [Edge?]? {
                get {
                  return (snapshot["edges"]! as! [Snapshot?]?).flatMap { $0.map { $0.flatMap { Edge(snapshot: $0) } } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "edges")
                }
              }

              public struct Edge: GraphQLSelectionSet {
                public static let possibleTypes = ["WorkshopEdge"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("node", type: .nonNull(.object(Node.self))),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(node: Node) {
                  self.init(snapshot: ["__typename": "WorkshopEdge", "node": node])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The node value for the edge.
                public var node: Node {
                  get {
                    return Node(snapshot: snapshot["node"]! as! Snapshot)
                  }
                  set {
                    snapshot.updateValue(newValue.snapshot, forKey: "node")
                  }
                }

                public struct Node: GraphQLSelectionSet {
                  public static let possibleTypes = ["Workshop"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("startTime", type: .nonNull(.scalar(String.self))),
                    GraphQLField("artist", type: .scalar(String.self)),
                    GraphQLField("room", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(name: String, startTime: String, artist: String? = nil, room: String, id: GraphQLID) {
                    self.init(snapshot: ["__typename": "Workshop", "name": name, "startTime": startTime, "artist": artist, "room": room, "id": id])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var name: String {
                    get {
                      return snapshot["name"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "name")
                    }
                  }

                  public var startTime: String {
                    get {
                      return snapshot["startTime"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "startTime")
                    }
                  }

                  public var artist: String? {
                    get {
                      return snapshot["artist"]! as! String?
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "artist")
                    }
                  }

                  public var room: String {
                    get {
                      return snapshot["room"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "room")
                    }
                  }

                  /// A globally unique ID.
                  public var id: GraphQLID {
                    get {
                      return snapshot["id"]! as! GraphQLID
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "id")
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
}

public final class FetchAllEventsQuery: GraphQLQuery {
  public static let operationString =
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

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("viewer", type: .object(Viewer.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(viewer: Viewer? = nil) {
      self.init(snapshot: ["__typename": "Query", "viewer": viewer])
    }

    public var viewer: Viewer? {
      get {
        return (snapshot["viewer"]! as! Snapshot?).flatMap { Viewer(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes = ["Viewer"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("allEvents", type: .object(AllEvent.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(allEvents: AllEvent? = nil) {
        self.init(snapshot: ["__typename": "Viewer", "allEvents": allEvents])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Sift through all objects of type 'Event'.
      public var allEvents: AllEvent? {
        get {
          return (snapshot["allEvents"]! as! Snapshot?).flatMap { AllEvent(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "allEvents")
        }
      }

      public struct AllEvent: GraphQLSelectionSet {
        public static let possibleTypes = ["EventConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .list(.object(Edge.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(edges: [Edge?]? = nil) {
          self.init(snapshot: ["__typename": "EventConnection", "edges": edges])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The set of edges in this page.
        public var edges: [Edge?]? {
          get {
            return (snapshot["edges"]! as! [Snapshot?]?).flatMap { $0.map { $0.flatMap { Edge(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes = ["EventEdge"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .nonNull(.object(Node.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(node: Node) {
            self.init(snapshot: ["__typename": "EventEdge", "node": node])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The node value for the edge.
          public var node: Node {
            get {
              return Node(snapshot: snapshot["node"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes = ["Event"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(Dance.self))),
              GraphQLField("fbID", type: .scalar(String.self)),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(type: Dance, fbId: String? = nil, id: GraphQLID) {
              self.init(snapshot: ["__typename": "Event", "type": type, "fbID": fbId, "id": id])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var type: Dance {
              get {
                return snapshot["type"]! as! Dance
              }
              set {
                snapshot.updateValue(newValue, forKey: "type")
              }
            }

            public var fbId: String? {
              get {
                return snapshot["fbID"]! as! String?
              }
              set {
                snapshot.updateValue(newValue, forKey: "fbID")
              }
            }

            /// A globally unique ID.
            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }
          }
        }
      }
    }
  }
}

public final class CreateWorkshopMutation: GraphQLMutation {
  public static let operationString =
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

  public var workshop: CreateWorkshopInput

  public init(workshop: CreateWorkshopInput) {
    self.workshop = workshop
  }

  public var variables: GraphQLMap? {
    return ["workshop": workshop]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createWorkshop", arguments: ["input": Variable("workshop")], type: .object(CreateWorkshop.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createWorkshop: CreateWorkshop? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createWorkshop": createWorkshop])
    }

    /// Create objects of type Workshop.
    public var createWorkshop: CreateWorkshop? {
      get {
        return (snapshot["createWorkshop"]! as! Snapshot?).flatMap { CreateWorkshop(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createWorkshop")
      }
    }

    public struct CreateWorkshop: GraphQLSelectionSet {
      public static let possibleTypes = ["CreateWorkshopPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("changedWorkshop", type: .object(ChangedWorkshop.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(changedWorkshop: ChangedWorkshop? = nil) {
        self.init(snapshot: ["__typename": "CreateWorkshopPayload", "changedWorkshop": changedWorkshop])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The mutated Workshop.
      public var changedWorkshop: ChangedWorkshop? {
        get {
          return (snapshot["changedWorkshop"]! as! Snapshot?).flatMap { ChangedWorkshop(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "changedWorkshop")
        }
      }

      public struct ChangedWorkshop: GraphQLSelectionSet {
        public static let possibleTypes = ["Workshop"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("event", type: .object(Event.self)),
          GraphQLField("startTime", type: .nonNull(.scalar(String.self))),
          GraphQLField("room", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(name: String, event: Event? = nil, startTime: String, room: String) {
          self.init(snapshot: ["__typename": "Workshop", "name": name, "event": event, "startTime": startTime, "room": room])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        /// The reverse field of 'workshops' in M:1 connection
        /// with type 'Workshop'.
        public var event: Event? {
          get {
            return (snapshot["event"]! as! Snapshot?).flatMap { Event(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "event")
          }
        }

        public var startTime: String {
          get {
            return snapshot["startTime"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "startTime")
          }
        }

        public var room: String {
          get {
            return snapshot["room"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "room")
          }
        }

        public struct Event: GraphQLSelectionSet {
          public static let possibleTypes = ["Event"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID) {
            self.init(snapshot: ["__typename": "Event", "id": id])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// A globally unique ID.
          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }
        }
      }
    }
  }
}