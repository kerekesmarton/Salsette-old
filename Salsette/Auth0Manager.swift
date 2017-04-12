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
    static let accessToken = "accessToken"
    static let expiresIn = "expiresIn"
    static let userId = "userId"
}

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
    
    var accessToken: String? {
        get {
            return KeychainStorage.shared[Auth0Keys.accessToken]
        }
        set {
            KeychainStorage.shared[Auth0Keys.accessToken] = newValue
        }
    }
    
    var expiresIn: String? {
        get {
            return KeychainStorage.shared[Auth0Keys.expiresIn]
        }
        set {
            KeychainStorage.shared[Auth0Keys.expiresIn] = newValue
        }
    }
    
    var userId: String? {
        get {
            return KeychainStorage.shared[Auth0Keys.userId]
        }
        set {
            KeychainStorage.shared[Auth0Keys.userId] = newValue
        }
    }

    func storeTokens(_ idToken: String?, refreshToken: String? = nil, accessToken: String? = nil, expiresIn: Date? = nil) {

        if let token = idToken {
            self.idToken = token
        }
        if let existingRefreshToken = refreshToken {
            self.refreshToken = existingRefreshToken
        }
        if let existingAccessToken = accessToken {
            self.accessToken = existingAccessToken
        }
        if let accessToken = accessToken {
            self.accessToken = accessToken
        }
        if let date  = expiresIn {
            let expiryDate = DateFormatters.dateTimeFormatter.string(from: date)
            self.expiresIn = expiryDate
        }
    }
    
    func use(fbToken: String, with callback: @escaping (Bool, Error?) -> ()) throws {
        Auth0
            .authentication()
            .loginSocial(token: fbToken, connection: "facebook", scope: "openid", parameters: [:])
            .start { result in
                switch (result) {
                case .success(let credentials):
                    callback(true, nil)
                case .failure(let error):
                    callback(false, error)
                }
        }
        
        
        /*
         POST https://mkerekes.eu.auth0.com/oauth/access_token
         Content-Type: 'application/json'
         {
             "client_id": "HYFb2FNqiyPdhCwxUVMiQOnf3QA1kAtA",
             "access_token": "ACCESS_TOKEN",
             "connection": "CONNECTION",
             "scope": "SCOPE"
         }
         */
        let dict = ["client_id": "nrZxfSdXoKwkp7qZ2kWEiwSZeqStauTb",
                    "access_token": fbToken,
                    "connection": "facebook",
                    "scope": "openid"]
        
        let json: JSON = JSON(dict)
        
        guard let url = URL(string: "https://mkerekes.eu.auth0.com/oauth/access_token") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try json.rawData()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if response != nil {
                let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                callback(true, nil)
            }
            if let error = error {
                callback(false, error)
            }
        })
        task.resume()
    }

    func retrieveProfile(_ callback: @escaping (Bool, Error?) -> ()) {
        guard let savedToken = accessToken else {
            callback(false, nil)
            return
        }
        Auth0.authentication()
            .userInfo(token: savedToken)
            .start { result in
                switch(result) {
                case .success(let profile):
                    self.profile = profile
                    callback(true, nil)
                case .failure(let error):
                    callback(false, error)
                }
        }
    }
    
    func logout() {
        KeychainStorage.shared.clear()
    }
    
}
