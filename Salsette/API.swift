//  This file was automatically generated and should not be edited.

import Apollo

public struct AuthProviderSignupData: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(email: Optional<AUTH_PROVIDER_EMAIL?> = nil, auth0: Optional<AUTH_PROVIDER_AUTH0?> = nil) {
    graphQLMap = ["email": email, "auth0": auth0]
  }

  public var email: Optional<AUTH_PROVIDER_EMAIL?> {
    get {
      return graphQLMap["email"] as! Optional<AUTH_PROVIDER_EMAIL?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var auth0: Optional<AUTH_PROVIDER_AUTH0?> {
    get {
      return graphQLMap["auth0"] as! Optional<AUTH_PROVIDER_AUTH0?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "auth0")
    }
  }
}

public struct AUTH_PROVIDER_EMAIL: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(email: String, password: String) {
    graphQLMap = ["email": email, "password": password]
  }

  public var email: String {
    get {
      return graphQLMap["email"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }
}

public struct AUTH_PROVIDER_AUTH0: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(idToken: String) {
    graphQLMap = ["idToken": idToken]
  }

  /// Is returned when calling any of the Auth0 functions which invoke authentication. This includes calls to the Lock widget, to the auth0.js library, or the libraries for other languages. See https://auth0.com/docs/tokens/id_token for more detail
  public var idToken: String {
    get {
      return graphQLMap["idToken"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idToken")
    }
  }
}

public enum Dance: String, Apollo.JSONDecodable, Apollo.JSONEncodable {
  case salsa = "Salsa"
  case bachata = "Bachata"
  case kizomba = "Kizomba"
  case tango = "Tango"
  case dance = "Dance"
}

public struct EventFilter: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(and: Optional<[EventFilter]?> = nil, or: Optional<[EventFilter]?> = nil, fbId: Optional<String?> = nil, fbIdNot: Optional<String?> = nil, fbIdIn: Optional<[String]?> = nil, fbIdNotIn: Optional<[String]?> = nil, fbIdLt: Optional<String?> = nil, fbIdLte: Optional<String?> = nil, fbIdGt: Optional<String?> = nil, fbIdGte: Optional<String?> = nil, fbIdContains: Optional<String?> = nil, fbIdNotContains: Optional<String?> = nil, fbIdStartsWith: Optional<String?> = nil, fbIdNotStartsWith: Optional<String?> = nil, fbIdEndsWith: Optional<String?> = nil, fbIdNotEndsWith: Optional<String?> = nil, id: Optional<GraphQLID?> = nil, idNot: Optional<GraphQLID?> = nil, idIn: Optional<[GraphQLID]?> = nil, idNotIn: Optional<[GraphQLID]?> = nil, idLt: Optional<GraphQLID?> = nil, idLte: Optional<GraphQLID?> = nil, idGt: Optional<GraphQLID?> = nil, idGte: Optional<GraphQLID?> = nil, idContains: Optional<GraphQLID?> = nil, idNotContains: Optional<GraphQLID?> = nil, idStartsWith: Optional<GraphQLID?> = nil, idNotStartsWith: Optional<GraphQLID?> = nil, idEndsWith: Optional<GraphQLID?> = nil, idNotEndsWith: Optional<GraphQLID?> = nil, type: Optional<Dance?> = nil, typeNot: Optional<Dance?> = nil, typeIn: Optional<[Dance]?> = nil, typeNotIn: Optional<[Dance]?> = nil, workshopsEvery: Optional<WorkshopFilter?> = nil, workshopsSome: Optional<WorkshopFilter?> = nil, workshopsNone: Optional<WorkshopFilter?> = nil) {
    graphQLMap = ["AND": and, "OR": or, "fbID": fbId, "fbID_not": fbIdNot, "fbID_in": fbIdIn, "fbID_not_in": fbIdNotIn, "fbID_lt": fbIdLt, "fbID_lte": fbIdLte, "fbID_gt": fbIdGt, "fbID_gte": fbIdGte, "fbID_contains": fbIdContains, "fbID_not_contains": fbIdNotContains, "fbID_starts_with": fbIdStartsWith, "fbID_not_starts_with": fbIdNotStartsWith, "fbID_ends_with": fbIdEndsWith, "fbID_not_ends_with": fbIdNotEndsWith, "id": id, "id_not": idNot, "id_in": idIn, "id_not_in": idNotIn, "id_lt": idLt, "id_lte": idLte, "id_gt": idGt, "id_gte": idGte, "id_contains": idContains, "id_not_contains": idNotContains, "id_starts_with": idStartsWith, "id_not_starts_with": idNotStartsWith, "id_ends_with": idEndsWith, "id_not_ends_with": idNotEndsWith, "type": type, "type_not": typeNot, "type_in": typeIn, "type_not_in": typeNotIn, "workshops_every": workshopsEvery, "workshops_some": workshopsSome, "workshops_none": workshopsNone]
  }

  /// Logical AND on all given filters.
  public var and: Optional<[EventFilter]?> {
    get {
      return graphQLMap["and"] as! Optional<[EventFilter]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  /// Logical OR on all given filters.
  public var or: Optional<[EventFilter]?> {
    get {
      return graphQLMap["or"] as! Optional<[EventFilter]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var fbId: Optional<String?> {
    get {
      return graphQLMap["fbId"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbId")
    }
  }

  /// All values that are not equal to given value.
  public var fbIdNot: Optional<String?> {
    get {
      return graphQLMap["fbIdNot"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdNot")
    }
  }

  /// All values that are contained in given list.
  public var fbIdIn: Optional<[String]?> {
    get {
      return graphQLMap["fbIdIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdIn")
    }
  }

  /// All values that are not contained in given list.
  public var fbIdNotIn: Optional<[String]?> {
    get {
      return graphQLMap["fbIdNotIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdNotIn")
    }
  }

  /// All values less than the given value.
  public var fbIdLt: Optional<String?> {
    get {
      return graphQLMap["fbIdLt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdLt")
    }
  }

  /// All values less than or equal the given value.
  public var fbIdLte: Optional<String?> {
    get {
      return graphQLMap["fbIdLte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdLte")
    }
  }

  /// All values greater than the given value.
  public var fbIdGt: Optional<String?> {
    get {
      return graphQLMap["fbIdGt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdGt")
    }
  }

  /// All values greater than or equal the given value.
  public var fbIdGte: Optional<String?> {
    get {
      return graphQLMap["fbIdGte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdGte")
    }
  }

  /// All values containing the given string.
  public var fbIdContains: Optional<String?> {
    get {
      return graphQLMap["fbIdContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdContains")
    }
  }

  /// All values not containing the given string.
  public var fbIdNotContains: Optional<String?> {
    get {
      return graphQLMap["fbIdNotContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdNotContains")
    }
  }

  /// All values starting with the given string.
  public var fbIdStartsWith: Optional<String?> {
    get {
      return graphQLMap["fbIdStartsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdStartsWith")
    }
  }

  /// All values not starting with the given string.
  public var fbIdNotStartsWith: Optional<String?> {
    get {
      return graphQLMap["fbIdNotStartsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdNotStartsWith")
    }
  }

  /// All values ending with the given string.
  public var fbIdEndsWith: Optional<String?> {
    get {
      return graphQLMap["fbIdEndsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdEndsWith")
    }
  }

  /// All values not ending with the given string.
  public var fbIdNotEndsWith: Optional<String?> {
    get {
      return graphQLMap["fbIdNotEndsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fbIdNotEndsWith")
    }
  }

  public var id: Optional<GraphQLID?> {
    get {
      return graphQLMap["id"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  /// All values that are not equal to given value.
  public var idNot: Optional<GraphQLID?> {
    get {
      return graphQLMap["idNot"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNot")
    }
  }

  /// All values that are contained in given list.
  public var idIn: Optional<[GraphQLID]?> {
    get {
      return graphQLMap["idIn"] as! Optional<[GraphQLID]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idIn")
    }
  }

  /// All values that are not contained in given list.
  public var idNotIn: Optional<[GraphQLID]?> {
    get {
      return graphQLMap["idNotIn"] as! Optional<[GraphQLID]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNotIn")
    }
  }

  /// All values less than the given value.
  public var idLt: Optional<GraphQLID?> {
    get {
      return graphQLMap["idLt"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idLt")
    }
  }

  /// All values less than or equal the given value.
  public var idLte: Optional<GraphQLID?> {
    get {
      return graphQLMap["idLte"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idLte")
    }
  }

  /// All values greater than the given value.
  public var idGt: Optional<GraphQLID?> {
    get {
      return graphQLMap["idGt"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idGt")
    }
  }

  /// All values greater than or equal the given value.
  public var idGte: Optional<GraphQLID?> {
    get {
      return graphQLMap["idGte"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idGte")
    }
  }

  /// All values containing the given string.
  public var idContains: Optional<GraphQLID?> {
    get {
      return graphQLMap["idContains"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idContains")
    }
  }

  /// All values not containing the given string.
  public var idNotContains: Optional<GraphQLID?> {
    get {
      return graphQLMap["idNotContains"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNotContains")
    }
  }

  /// All values starting with the given string.
  public var idStartsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["idStartsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idStartsWith")
    }
  }

  /// All values not starting with the given string.
  public var idNotStartsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["idNotStartsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNotStartsWith")
    }
  }

  /// All values ending with the given string.
  public var idEndsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["idEndsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idEndsWith")
    }
  }

  /// All values not ending with the given string.
  public var idNotEndsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["idNotEndsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNotEndsWith")
    }
  }

  public var type: Optional<Dance?> {
    get {
      return graphQLMap["type"] as! Optional<Dance?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  /// All values that are not equal to given value.
  public var typeNot: Optional<Dance?> {
    get {
      return graphQLMap["typeNot"] as! Optional<Dance?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "typeNot")
    }
  }

  /// All values that are contained in given list.
  public var typeIn: Optional<[Dance]?> {
    get {
      return graphQLMap["typeIn"] as! Optional<[Dance]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "typeIn")
    }
  }

  /// All values that are not contained in given list.
  public var typeNotIn: Optional<[Dance]?> {
    get {
      return graphQLMap["typeNotIn"] as! Optional<[Dance]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "typeNotIn")
    }
  }

  public var workshopsEvery: Optional<WorkshopFilter?> {
    get {
      return graphQLMap["workshopsEvery"] as! Optional<WorkshopFilter?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "workshopsEvery")
    }
  }

  public var workshopsSome: Optional<WorkshopFilter?> {
    get {
      return graphQLMap["workshopsSome"] as! Optional<WorkshopFilter?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "workshopsSome")
    }
  }

  public var workshopsNone: Optional<WorkshopFilter?> {
    get {
      return graphQLMap["workshopsNone"] as! Optional<WorkshopFilter?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "workshopsNone")
    }
  }
}

public struct WorkshopFilter: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(and: Optional<[WorkshopFilter]?> = nil, or: Optional<[WorkshopFilter]?> = nil, artist: Optional<String?> = nil, artistNot: Optional<String?> = nil, artistIn: Optional<[String]?> = nil, artistNotIn: Optional<[String]?> = nil, artistLt: Optional<String?> = nil, artistLte: Optional<String?> = nil, artistGt: Optional<String?> = nil, artistGte: Optional<String?> = nil, artistContains: Optional<String?> = nil, artistNotContains: Optional<String?> = nil, artistStartsWith: Optional<String?> = nil, artistNotStartsWith: Optional<String?> = nil, artistEndsWith: Optional<String?> = nil, artistNotEndsWith: Optional<String?> = nil, id: Optional<GraphQLID?> = nil, idNot: Optional<GraphQLID?> = nil, idIn: Optional<[GraphQLID]?> = nil, idNotIn: Optional<[GraphQLID]?> = nil, idLt: Optional<GraphQLID?> = nil, idLte: Optional<GraphQLID?> = nil, idGt: Optional<GraphQLID?> = nil, idGte: Optional<GraphQLID?> = nil, idContains: Optional<GraphQLID?> = nil, idNotContains: Optional<GraphQLID?> = nil, idStartsWith: Optional<GraphQLID?> = nil, idNotStartsWith: Optional<GraphQLID?> = nil, idEndsWith: Optional<GraphQLID?> = nil, idNotEndsWith: Optional<GraphQLID?> = nil, name: Optional<String?> = nil, nameNot: Optional<String?> = nil, nameIn: Optional<[String]?> = nil, nameNotIn: Optional<[String]?> = nil, nameLt: Optional<String?> = nil, nameLte: Optional<String?> = nil, nameGt: Optional<String?> = nil, nameGte: Optional<String?> = nil, nameContains: Optional<String?> = nil, nameNotContains: Optional<String?> = nil, nameStartsWith: Optional<String?> = nil, nameNotStartsWith: Optional<String?> = nil, nameEndsWith: Optional<String?> = nil, nameNotEndsWith: Optional<String?> = nil, room: Optional<String?> = nil, roomNot: Optional<String?> = nil, roomIn: Optional<[String]?> = nil, roomNotIn: Optional<[String]?> = nil, roomLt: Optional<String?> = nil, roomLte: Optional<String?> = nil, roomGt: Optional<String?> = nil, roomGte: Optional<String?> = nil, roomContains: Optional<String?> = nil, roomNotContains: Optional<String?> = nil, roomStartsWith: Optional<String?> = nil, roomNotStartsWith: Optional<String?> = nil, roomEndsWith: Optional<String?> = nil, roomNotEndsWith: Optional<String?> = nil, startTime: Optional<String?> = nil, startTimeNot: Optional<String?> = nil, startTimeIn: Optional<[String]?> = nil, startTimeNotIn: Optional<[String]?> = nil, startTimeLt: Optional<String?> = nil, startTimeLte: Optional<String?> = nil, startTimeGt: Optional<String?> = nil, startTimeGte: Optional<String?> = nil, event: Optional<EventFilter?> = nil) {
    graphQLMap = ["AND": and, "OR": or, "artist": artist, "artist_not": artistNot, "artist_in": artistIn, "artist_not_in": artistNotIn, "artist_lt": artistLt, "artist_lte": artistLte, "artist_gt": artistGt, "artist_gte": artistGte, "artist_contains": artistContains, "artist_not_contains": artistNotContains, "artist_starts_with": artistStartsWith, "artist_not_starts_with": artistNotStartsWith, "artist_ends_with": artistEndsWith, "artist_not_ends_with": artistNotEndsWith, "id": id, "id_not": idNot, "id_in": idIn, "id_not_in": idNotIn, "id_lt": idLt, "id_lte": idLte, "id_gt": idGt, "id_gte": idGte, "id_contains": idContains, "id_not_contains": idNotContains, "id_starts_with": idStartsWith, "id_not_starts_with": idNotStartsWith, "id_ends_with": idEndsWith, "id_not_ends_with": idNotEndsWith, "name": name, "name_not": nameNot, "name_in": nameIn, "name_not_in": nameNotIn, "name_lt": nameLt, "name_lte": nameLte, "name_gt": nameGt, "name_gte": nameGte, "name_contains": nameContains, "name_not_contains": nameNotContains, "name_starts_with": nameStartsWith, "name_not_starts_with": nameNotStartsWith, "name_ends_with": nameEndsWith, "name_not_ends_with": nameNotEndsWith, "room": room, "room_not": roomNot, "room_in": roomIn, "room_not_in": roomNotIn, "room_lt": roomLt, "room_lte": roomLte, "room_gt": roomGt, "room_gte": roomGte, "room_contains": roomContains, "room_not_contains": roomNotContains, "room_starts_with": roomStartsWith, "room_not_starts_with": roomNotStartsWith, "room_ends_with": roomEndsWith, "room_not_ends_with": roomNotEndsWith, "startTime": startTime, "startTime_not": startTimeNot, "startTime_in": startTimeIn, "startTime_not_in": startTimeNotIn, "startTime_lt": startTimeLt, "startTime_lte": startTimeLte, "startTime_gt": startTimeGt, "startTime_gte": startTimeGte, "event": event]
  }

  /// Logical AND on all given filters.
  public var and: Optional<[WorkshopFilter]?> {
    get {
      return graphQLMap["and"] as! Optional<[WorkshopFilter]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  /// Logical OR on all given filters.
  public var or: Optional<[WorkshopFilter]?> {
    get {
      return graphQLMap["or"] as! Optional<[WorkshopFilter]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
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

  /// All values that are not equal to given value.
  public var artistNot: Optional<String?> {
    get {
      return graphQLMap["artistNot"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistNot")
    }
  }

  /// All values that are contained in given list.
  public var artistIn: Optional<[String]?> {
    get {
      return graphQLMap["artistIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistIn")
    }
  }

  /// All values that are not contained in given list.
  public var artistNotIn: Optional<[String]?> {
    get {
      return graphQLMap["artistNotIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistNotIn")
    }
  }

  /// All values less than the given value.
  public var artistLt: Optional<String?> {
    get {
      return graphQLMap["artistLt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistLt")
    }
  }

  /// All values less than or equal the given value.
  public var artistLte: Optional<String?> {
    get {
      return graphQLMap["artistLte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistLte")
    }
  }

  /// All values greater than the given value.
  public var artistGt: Optional<String?> {
    get {
      return graphQLMap["artistGt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistGt")
    }
  }

  /// All values greater than or equal the given value.
  public var artistGte: Optional<String?> {
    get {
      return graphQLMap["artistGte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistGte")
    }
  }

  /// All values containing the given string.
  public var artistContains: Optional<String?> {
    get {
      return graphQLMap["artistContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistContains")
    }
  }

  /// All values not containing the given string.
  public var artistNotContains: Optional<String?> {
    get {
      return graphQLMap["artistNotContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistNotContains")
    }
  }

  /// All values starting with the given string.
  public var artistStartsWith: Optional<String?> {
    get {
      return graphQLMap["artistStartsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistStartsWith")
    }
  }

  /// All values not starting with the given string.
  public var artistNotStartsWith: Optional<String?> {
    get {
      return graphQLMap["artistNotStartsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistNotStartsWith")
    }
  }

  /// All values ending with the given string.
  public var artistEndsWith: Optional<String?> {
    get {
      return graphQLMap["artistEndsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistEndsWith")
    }
  }

  /// All values not ending with the given string.
  public var artistNotEndsWith: Optional<String?> {
    get {
      return graphQLMap["artistNotEndsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "artistNotEndsWith")
    }
  }

  public var id: Optional<GraphQLID?> {
    get {
      return graphQLMap["id"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  /// All values that are not equal to given value.
  public var idNot: Optional<GraphQLID?> {
    get {
      return graphQLMap["idNot"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNot")
    }
  }

  /// All values that are contained in given list.
  public var idIn: Optional<[GraphQLID]?> {
    get {
      return graphQLMap["idIn"] as! Optional<[GraphQLID]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idIn")
    }
  }

  /// All values that are not contained in given list.
  public var idNotIn: Optional<[GraphQLID]?> {
    get {
      return graphQLMap["idNotIn"] as! Optional<[GraphQLID]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNotIn")
    }
  }

  /// All values less than the given value.
  public var idLt: Optional<GraphQLID?> {
    get {
      return graphQLMap["idLt"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idLt")
    }
  }

  /// All values less than or equal the given value.
  public var idLte: Optional<GraphQLID?> {
    get {
      return graphQLMap["idLte"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idLte")
    }
  }

  /// All values greater than the given value.
  public var idGt: Optional<GraphQLID?> {
    get {
      return graphQLMap["idGt"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idGt")
    }
  }

  /// All values greater than or equal the given value.
  public var idGte: Optional<GraphQLID?> {
    get {
      return graphQLMap["idGte"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idGte")
    }
  }

  /// All values containing the given string.
  public var idContains: Optional<GraphQLID?> {
    get {
      return graphQLMap["idContains"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idContains")
    }
  }

  /// All values not containing the given string.
  public var idNotContains: Optional<GraphQLID?> {
    get {
      return graphQLMap["idNotContains"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNotContains")
    }
  }

  /// All values starting with the given string.
  public var idStartsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["idStartsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idStartsWith")
    }
  }

  /// All values not starting with the given string.
  public var idNotStartsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["idNotStartsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNotStartsWith")
    }
  }

  /// All values ending with the given string.
  public var idEndsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["idEndsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idEndsWith")
    }
  }

  /// All values not ending with the given string.
  public var idNotEndsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["idNotEndsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "idNotEndsWith")
    }
  }

  public var name: Optional<String?> {
    get {
      return graphQLMap["name"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  /// All values that are not equal to given value.
  public var nameNot: Optional<String?> {
    get {
      return graphQLMap["nameNot"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameNot")
    }
  }

  /// All values that are contained in given list.
  public var nameIn: Optional<[String]?> {
    get {
      return graphQLMap["nameIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameIn")
    }
  }

  /// All values that are not contained in given list.
  public var nameNotIn: Optional<[String]?> {
    get {
      return graphQLMap["nameNotIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameNotIn")
    }
  }

  /// All values less than the given value.
  public var nameLt: Optional<String?> {
    get {
      return graphQLMap["nameLt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameLt")
    }
  }

  /// All values less than or equal the given value.
  public var nameLte: Optional<String?> {
    get {
      return graphQLMap["nameLte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameLte")
    }
  }

  /// All values greater than the given value.
  public var nameGt: Optional<String?> {
    get {
      return graphQLMap["nameGt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameGt")
    }
  }

  /// All values greater than or equal the given value.
  public var nameGte: Optional<String?> {
    get {
      return graphQLMap["nameGte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameGte")
    }
  }

  /// All values containing the given string.
  public var nameContains: Optional<String?> {
    get {
      return graphQLMap["nameContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameContains")
    }
  }

  /// All values not containing the given string.
  public var nameNotContains: Optional<String?> {
    get {
      return graphQLMap["nameNotContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameNotContains")
    }
  }

  /// All values starting with the given string.
  public var nameStartsWith: Optional<String?> {
    get {
      return graphQLMap["nameStartsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameStartsWith")
    }
  }

  /// All values not starting with the given string.
  public var nameNotStartsWith: Optional<String?> {
    get {
      return graphQLMap["nameNotStartsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameNotStartsWith")
    }
  }

  /// All values ending with the given string.
  public var nameEndsWith: Optional<String?> {
    get {
      return graphQLMap["nameEndsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameEndsWith")
    }
  }

  /// All values not ending with the given string.
  public var nameNotEndsWith: Optional<String?> {
    get {
      return graphQLMap["nameNotEndsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameNotEndsWith")
    }
  }

  public var room: Optional<String?> {
    get {
      return graphQLMap["room"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "room")
    }
  }

  /// All values that are not equal to given value.
  public var roomNot: Optional<String?> {
    get {
      return graphQLMap["roomNot"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomNot")
    }
  }

  /// All values that are contained in given list.
  public var roomIn: Optional<[String]?> {
    get {
      return graphQLMap["roomIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomIn")
    }
  }

  /// All values that are not contained in given list.
  public var roomNotIn: Optional<[String]?> {
    get {
      return graphQLMap["roomNotIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomNotIn")
    }
  }

  /// All values less than the given value.
  public var roomLt: Optional<String?> {
    get {
      return graphQLMap["roomLt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomLt")
    }
  }

  /// All values less than or equal the given value.
  public var roomLte: Optional<String?> {
    get {
      return graphQLMap["roomLte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomLte")
    }
  }

  /// All values greater than the given value.
  public var roomGt: Optional<String?> {
    get {
      return graphQLMap["roomGt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomGt")
    }
  }

  /// All values greater than or equal the given value.
  public var roomGte: Optional<String?> {
    get {
      return graphQLMap["roomGte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomGte")
    }
  }

  /// All values containing the given string.
  public var roomContains: Optional<String?> {
    get {
      return graphQLMap["roomContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomContains")
    }
  }

  /// All values not containing the given string.
  public var roomNotContains: Optional<String?> {
    get {
      return graphQLMap["roomNotContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomNotContains")
    }
  }

  /// All values starting with the given string.
  public var roomStartsWith: Optional<String?> {
    get {
      return graphQLMap["roomStartsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomStartsWith")
    }
  }

  /// All values not starting with the given string.
  public var roomNotStartsWith: Optional<String?> {
    get {
      return graphQLMap["roomNotStartsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomNotStartsWith")
    }
  }

  /// All values ending with the given string.
  public var roomEndsWith: Optional<String?> {
    get {
      return graphQLMap["roomEndsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomEndsWith")
    }
  }

  /// All values not ending with the given string.
  public var roomNotEndsWith: Optional<String?> {
    get {
      return graphQLMap["roomNotEndsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "roomNotEndsWith")
    }
  }

  public var startTime: Optional<String?> {
    get {
      return graphQLMap["startTime"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTime")
    }
  }

  /// All values that are not equal to given value.
  public var startTimeNot: Optional<String?> {
    get {
      return graphQLMap["startTimeNot"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTimeNot")
    }
  }

  /// All values that are contained in given list.
  public var startTimeIn: Optional<[String]?> {
    get {
      return graphQLMap["startTimeIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTimeIn")
    }
  }

  /// All values that are not contained in given list.
  public var startTimeNotIn: Optional<[String]?> {
    get {
      return graphQLMap["startTimeNotIn"] as! Optional<[String]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTimeNotIn")
    }
  }

  /// All values less than the given value.
  public var startTimeLt: Optional<String?> {
    get {
      return graphQLMap["startTimeLt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTimeLt")
    }
  }

  /// All values less than or equal the given value.
  public var startTimeLte: Optional<String?> {
    get {
      return graphQLMap["startTimeLte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTimeLte")
    }
  }

  /// All values greater than the given value.
  public var startTimeGt: Optional<String?> {
    get {
      return graphQLMap["startTimeGt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTimeGt")
    }
  }

  /// All values greater than or equal the given value.
  public var startTimeGte: Optional<String?> {
    get {
      return graphQLMap["startTimeGte"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startTimeGte")
    }
  }

  public var event: Optional<EventFilter?> {
    get {
      return graphQLMap["event"] as! Optional<EventFilter?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "event")
    }
  }
}

public final class CreateUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateUser($data: AuthProviderSignupData!) {\n  createUser(authProvider: $data) {\n    __typename\n    id\n    auth0UserId\n  }\n}"

  public var data: AuthProviderSignupData

  public init(data: AuthProviderSignupData) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createUser", arguments: ["authProvider": GraphQLVariable("data")], type: .object(CreateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createUser: CreateUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createUser": createUser.flatMap { $0.snapshot }])
    }

    public var createUser: CreateUser? {
      get {
        return (snapshot["createUser"] as? Snapshot).flatMap { CreateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createUser")
      }
    }

    public struct CreateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("auth0UserId", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, auth0UserId: String? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "auth0UserId": auth0UserId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var auth0UserId: String? {
        get {
          return snapshot["auth0UserId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "auth0UserId")
        }
      }
    }
  }
}

public final class LoginMutation: GraphQLMutation {
  public static let operationString =
    "mutation Login($data: AUTH_PROVIDER_EMAIL) {\n  signinUser(email: $data) {\n    __typename\n    token\n    user {\n      __typename\n      id\n    }\n  }\n}"

  public var data: AUTH_PROVIDER_EMAIL?

  public init(data: AUTH_PROVIDER_EMAIL? = nil) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("signinUser", arguments: ["email": GraphQLVariable("data")], type: .nonNull(.object(SigninUser.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(signinUser: SigninUser) {
      self.init(snapshot: ["__typename": "Mutation", "signinUser": signinUser.snapshot])
    }

    public var signinUser: SigninUser {
      get {
        return SigninUser(snapshot: snapshot["signinUser"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "signinUser")
      }
    }

    public struct SigninUser: GraphQLSelectionSet {
      public static let possibleTypes = ["SigninPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .scalar(String.self)),
        GraphQLField("user", type: .object(User.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(token: String? = nil, user: User? = nil) {
        self.init(snapshot: ["__typename": "SigninPayload", "token": token, "user": user.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String? {
        get {
          return snapshot["token"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "token")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
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
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID) {
          self.init(snapshot: ["__typename": "User", "id": id])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

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

public final class CreateEventMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateEvent($fbId: String!, $type: Dance!) {\n  createEvent(fbID: $fbId, type: $type) {\n    __typename\n    id\n    fbID\n    type\n  }\n}"

  public var fbId: String
  public var type: Dance

  public init(fbId: String, type: Dance) {
    self.fbId = fbId
    self.type = type
  }

  public var variables: GraphQLMap? {
    return ["fbId": fbId, "type": type]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createEvent", arguments: ["fbID": GraphQLVariable("fbId"), "type": GraphQLVariable("type")], type: .object(CreateEvent.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createEvent: CreateEvent? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createEvent": createEvent.flatMap { $0.snapshot }])
    }

    public var createEvent: CreateEvent? {
      get {
        return (snapshot["createEvent"] as? Snapshot).flatMap { CreateEvent(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createEvent")
      }
    }

    public struct CreateEvent: GraphQLSelectionSet {
      public static let possibleTypes = ["Event"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fbID", type: .nonNull(.scalar(String.self))),
        GraphQLField("type", type: .nonNull(.scalar(Dance.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fbId: String, type: Dance) {
        self.init(snapshot: ["__typename": "Event", "id": id, "fbID": fbId, "type": type])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fbId: String {
        get {
          return snapshot["fbID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fbID")
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
    }
  }
}

public final class FetchEventQuery: GraphQLQuery {
  public static let operationString =
    "query FetchEvent($filter: EventFilter!) {\n  allEvents(filter: $filter) {\n    __typename\n    id\n    fbID\n    type\n    workshops {\n      __typename\n      name\n      startTime\n      artist\n      room\n      id\n    }\n  }\n}"

  public var filter: EventFilter

  public init(filter: EventFilter) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("allEvents", arguments: ["filter": GraphQLVariable("filter")], type: .nonNull(.list(.nonNull(.object(AllEvent.selections))))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(allEvents: [AllEvent]) {
      self.init(snapshot: ["__typename": "Query", "allEvents": allEvents.map { $0.snapshot }])
    }

    public var allEvents: [AllEvent] {
      get {
        return (snapshot["allEvents"] as! [Snapshot]).map { AllEvent(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "allEvents")
      }
    }

    public struct AllEvent: GraphQLSelectionSet {
      public static let possibleTypes = ["Event"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fbID", type: .nonNull(.scalar(String.self))),
        GraphQLField("type", type: .nonNull(.scalar(Dance.self))),
        GraphQLField("workshops", type: .list(.nonNull(.object(Workshop.selections)))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fbId: String, type: Dance, workshops: [Workshop]? = nil) {
        self.init(snapshot: ["__typename": "Event", "id": id, "fbID": fbId, "type": type, "workshops": workshops.flatMap { $0.map { $0.snapshot } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fbId: String {
        get {
          return snapshot["fbID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fbID")
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

      public var workshops: [Workshop]? {
        get {
          return (snapshot["workshops"] as? [Snapshot]).flatMap { $0.map { Workshop(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "workshops")
        }
      }

      public struct Workshop: GraphQLSelectionSet {
        public static let possibleTypes = ["Workshop"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("startTime", type: .nonNull(.scalar(String.self))),
          GraphQLField("artist", type: .nonNull(.scalar(String.self))),
          GraphQLField("room", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(name: String, startTime: String, artist: String, room: String, id: GraphQLID) {
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

        public var artist: String {
          get {
            return snapshot["artist"]! as! String
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

public final class FetchAllEventQuery: GraphQLQuery {
  public static let operationString =
    "query FetchAllEvent {\n  allEvents {\n    __typename\n    id\n    fbID\n    type\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("allEvents", type: .nonNull(.list(.nonNull(.object(AllEvent.selections))))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(allEvents: [AllEvent]) {
      self.init(snapshot: ["__typename": "Query", "allEvents": allEvents.map { $0.snapshot }])
    }

    public var allEvents: [AllEvent] {
      get {
        return (snapshot["allEvents"] as! [Snapshot]).map { AllEvent(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "allEvents")
      }
    }

    public struct AllEvent: GraphQLSelectionSet {
      public static let possibleTypes = ["Event"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fbID", type: .nonNull(.scalar(String.self))),
        GraphQLField("type", type: .nonNull(.scalar(Dance.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fbId: String, type: Dance) {
        self.init(snapshot: ["__typename": "Event", "id": id, "fbID": fbId, "type": type])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fbId: String {
        get {
          return snapshot["fbID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fbID")
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
    }
  }
}

public final class CreateWorkshopMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateWorkshop($artist: String!, $name: String!, $room: String!, $startTime: DateTime!, $eventId: ID) {\n  createWorkshop(artist: $artist, name: $name, room: $room, startTime: $startTime, eventId: $eventId) {\n    __typename\n    name\n    startTime\n    artist\n    room\n    id\n  }\n}"

  public var artist: String
  public var name: String
  public var room: String
  public var startTime: String
  public var eventId: GraphQLID?

  public init(artist: String, name: String, room: String, startTime: String, eventId: GraphQLID? = nil) {
    self.artist = artist
    self.name = name
    self.room = room
    self.startTime = startTime
    self.eventId = eventId
  }

  public var variables: GraphQLMap? {
    return ["artist": artist, "name": name, "room": room, "startTime": startTime, "eventId": eventId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createWorkshop", arguments: ["artist": GraphQLVariable("artist"), "name": GraphQLVariable("name"), "room": GraphQLVariable("room"), "startTime": GraphQLVariable("startTime"), "eventId": GraphQLVariable("eventId")], type: .object(CreateWorkshop.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createWorkshop: CreateWorkshop? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createWorkshop": createWorkshop.flatMap { $0.snapshot }])
    }

    public var createWorkshop: CreateWorkshop? {
      get {
        return (snapshot["createWorkshop"] as? Snapshot).flatMap { CreateWorkshop(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createWorkshop")
      }
    }

    public struct CreateWorkshop: GraphQLSelectionSet {
      public static let possibleTypes = ["Workshop"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("startTime", type: .nonNull(.scalar(String.self))),
        GraphQLField("artist", type: .nonNull(.scalar(String.self))),
        GraphQLField("room", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(name: String, startTime: String, artist: String, room: String, id: GraphQLID) {
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

      public var artist: String {
        get {
          return snapshot["artist"]! as! String
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

public final class UpdateWorkshopMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateWorkshop($artist: String, $name: String, $room: String, $startTime: DateTime, $id: ID!, $eventId: ID) {\n  updateWorkshop(artist: $artist, name: $name, room: $room, startTime: $startTime, id: $id, eventId: $eventId) {\n    __typename\n    name\n    startTime\n    artist\n    room\n    id\n  }\n}"

  public var artist: String?
  public var name: String?
  public var room: String?
  public var startTime: String?
  public var id: GraphQLID
  public var eventId: GraphQLID?

  public init(artist: String? = nil, name: String? = nil, room: String? = nil, startTime: String? = nil, id: GraphQLID, eventId: GraphQLID? = nil) {
    self.artist = artist
    self.name = name
    self.room = room
    self.startTime = startTime
    self.id = id
    self.eventId = eventId
  }

  public var variables: GraphQLMap? {
    return ["artist": artist, "name": name, "room": room, "startTime": startTime, "id": id, "eventId": eventId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateWorkshop", arguments: ["artist": GraphQLVariable("artist"), "name": GraphQLVariable("name"), "room": GraphQLVariable("room"), "startTime": GraphQLVariable("startTime"), "id": GraphQLVariable("id"), "eventId": GraphQLVariable("eventId")], type: .object(UpdateWorkshop.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateWorkshop: UpdateWorkshop? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateWorkshop": updateWorkshop.flatMap { $0.snapshot }])
    }

    public var updateWorkshop: UpdateWorkshop? {
      get {
        return (snapshot["updateWorkshop"] as? Snapshot).flatMap { UpdateWorkshop(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateWorkshop")
      }
    }

    public struct UpdateWorkshop: GraphQLSelectionSet {
      public static let possibleTypes = ["Workshop"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("startTime", type: .nonNull(.scalar(String.self))),
        GraphQLField("artist", type: .nonNull(.scalar(String.self))),
        GraphQLField("room", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(name: String, startTime: String, artist: String, room: String, id: GraphQLID) {
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

      public var artist: String {
        get {
          return snapshot["artist"]! as! String
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

public final class DeleteWorkshopMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteWorkshop($id: ID!) {\n  deleteWorkshop(id: $id) {\n    __typename\n    id\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteWorkshop", arguments: ["id": GraphQLVariable("id")], type: .object(DeleteWorkshop.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteWorkshop: DeleteWorkshop? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteWorkshop": deleteWorkshop.flatMap { $0.snapshot }])
    }

    public var deleteWorkshop: DeleteWorkshop? {
      get {
        return (snapshot["deleteWorkshop"] as? Snapshot).flatMap { DeleteWorkshop(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteWorkshop")
      }
    }

    public struct DeleteWorkshop: GraphQLSelectionSet {
      public static let possibleTypes = ["Workshop"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID) {
        self.init(snapshot: ["__typename": "Workshop", "id": id])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

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