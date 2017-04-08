// Auth0Manager.swift
// Auth0Sample
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import SimpleKeychain
import Auth0

fileprivate enum Auth0Keys {
    static let idToken = "idToken"
    static let refreshToken = "refreshToken"
}

enum Auth0ManagerError: Error {
    case noIdToken
    case noRefreshToken
}

class Auth0Manager {
    static let shared = Auth0Manager()
    var profile: Profile?

    private init () { }

    var idToken: String? {
        get {
            return KeychainStorage.shared[Auth0Keys.idToken]
        }
        set {
            KeychainStorage.shared[Auth0Keys.idToken] = newValue
        }
    }

    var refreshToken: String? {
        get {
            return KeychainStorage.shared[Auth0Keys.refreshToken]
        }
        set {
            KeychainStorage.shared[Auth0Keys.refreshToken] = newValue
        }
    }

    func storeTokens(_ idToken: String, refreshToken: String? = nil) {

        self.idToken = idToken
        if let existingRefreshToken = refreshToken {
            self.refreshToken = existingRefreshToken
        }
    }

    func retrieveProfile(_ callback: @escaping (Error?) -> ()) {
        guard let idToken = self.idToken else {
            return callback(Auth0ManagerError.noIdToken)
        }
        Auth0
            .authentication()
            .userInfo(token: idToken)
            .start { result in
                switch(result) {
                case .success(let profile):
                    self.profile = profile
                    callback(nil)
                case .failure(_):
                    self.refreshToken(callback)
                }
        }
    }

    func refreshToken(_ callback: @escaping (Error?) -> ()) {
        guard let refreshToken = self.refreshToken else {
            return callback(Auth0ManagerError.noRefreshToken)
        }
        Auth0
            .authentication()
            .delegation(withParameters: ["refresh_token": refreshToken,
                                         "scope": "openid email",
                                         "api_type": "app"])
            .start { result in
                switch(result) {
                case .success(let credentials):
                    guard let idToken = credentials["id_token"] as? String else { return }
                    self.storeTokens(idToken)
                    self.retrieveProfile(callback)
                case .failure(let error):
                    callback(error)
                    self.logout()
                }
        }
    }

    func logout() {
        KeychainStorage.shared.clear()
    }
    
}
