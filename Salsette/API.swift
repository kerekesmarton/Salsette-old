//  This file was automatically generated and should not be edited.

import Apollo

public final class CurrentUserQuery: GraphQLQuery {
  public static let operationDefinition =
    "query CurrentUser {" +
    "  user {" +
    "    __typename" +
    "    createdAt" +
    "  }" +
    "}"
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let user: User?

    public init(reader: GraphQLResultReader) throws {
      user = try reader.optionalValue(for: Field(responseName: "user"))
    }

    public struct User: GraphQLMappable {
      public let __typename: String
      public let createdAt: String

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        createdAt = try reader.value(for: Field(responseName: "createdAt"))
      }
    }
  }
}

public final class CreateUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateUser($idToken: String!) {" +
    "  createUser(authProvider: {auth0: {idToken: $idToken}}) {" +
    "    __typename" +
    "    id" +
    "  }" +
    "}"

  public let idToken: String

  public init(idToken: String) {
    self.idToken = idToken
  }

  public var variables: GraphQLMap? {
    return ["idToken": idToken]
  }

  public struct Data: GraphQLMappable {
    public let createUser: CreateUser?

    public init(reader: GraphQLResultReader) throws {
      createUser = try reader.optionalValue(for: Field(responseName: "createUser", arguments: ["authProvider": ["auth0": ["idToken": reader.variables["idToken"]]]]))
    }

    public struct CreateUser: GraphQLMappable {
      public let __typename: String
      public let id: GraphQLID

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        id = try reader.value(for: Field(responseName: "id"))
      }
    }
  }
}

public final class SingInUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation SingInUser($idToken: String!) {" +
    "  signinUser(auth0: {idToken: $idToken}) {" +
    "    __typename" +
    "    token" +
    "  }" +
    "}"

  public let idToken: String

  public init(idToken: String) {
    self.idToken = idToken
  }

  public var variables: GraphQLMap? {
    return ["idToken": idToken]
  }

  public struct Data: GraphQLMappable {
    public let signinUser: SigninUser

    public init(reader: GraphQLResultReader) throws {
      signinUser = try reader.value(for: Field(responseName: "signinUser", arguments: ["auth0": ["idToken": reader.variables["idToken"]]]))
    }

    public struct SigninUser: GraphQLMappable {
      public let __typename: String
      public let token: String?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        token = try reader.optionalValue(for: Field(responseName: "token"))
      }
    }
  }
}