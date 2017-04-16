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