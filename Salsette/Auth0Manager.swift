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

enum Auth0ManagerError: Error {
    case noIdToken
    case noRefreshToken
}

class Auth0Manager {
    static let shared = Auth0Manager()
    var profile: Profile? {
        didSet {
            userId = profile?.id
        }
    }
    private init () { }

    var isLoggedIn: Bool {
        get {
            return (accessToken != nil) ? true : false
        }
    }
    var accessToken: String?

    func auth0LoginUsingFacebook(token tokenString: String, callback: @escaping (Bool, Error?) -> ()) {
        Auth0
            .authentication()
            .loginSocial(token: tokenString, connection: "facebook", scope: "openid", parameters: [:])
            .start { result in
                switch(result) {
                case .success(let credentials):
                    self.accessToken = credentials.accessToken
                    self.auth0Token = credentials.idToken
                    DispatchQueue.main.async {
                        callback(true, nil)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        callback(false, error)
                    }
                }
        }
    }
    
    func logout() {
        KeychainStorage.shared.clear()
    }
}

extension Auth0Manager {

    var auth0Token: String? {
        get {
            return KeychainStorage.shared[Keys.auth0Token]
        }
        set {
            KeychainStorage.shared[Keys.auth0Token] = newValue
        }
    }

    var refreshToken: String? {
        get {
            return KeychainStorage.shared[Keys.refreshToken]
        }
        set {
            KeychainStorage.shared[Keys.refreshToken] = newValue
        }
    }

    var expiresIn: Date? {
        get {
            return UserDefaults.standard.value(forKey: Keys.expiresIn) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.expiresIn)
        }
    }

    var userId: String? {
        get {
            return KeychainStorage.shared[Keys.userId]
        }
        set {
            KeychainStorage.shared[Keys.userId] = newValue
        }
    }
}
