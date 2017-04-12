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

    var idToken: String? {
        get {
            return KeychainStorage.shared[Keys.idToken]
        }
        set {
            KeychainStorage.shared[Keys.idToken] = newValue
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
    
    var accessToken: String? {
        get {
            return KeychainStorage.shared[Keys.accessToken]
        }
        set {
            KeychainStorage.shared[Keys.accessToken] = newValue
        }
    }
    
    var expiresIn: String? {
        get {
            return KeychainStorage.shared[Keys.expiresIn]
        }
        set {
            KeychainStorage.shared[Keys.expiresIn] = newValue
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

    func getToken(with callback: @escaping (Bool, Error?) -> ()) {

        let headers = ["content-type": "application/json"]
        let parameters = [
            "grant_type": "client_credentials",
            "client_id": "nrZxfSdXoKwkp7qZ2kWEiwSZeqStauTb",
            "client_secret": "WMyQ00fMIctPz1Uxeo_wnd3e4UTN5-1RJuNRNsmrrhsrwNxcEGAZ7CxypvyMEjiE",
            "audience": "https://mkerekes.eu.auth0.com/api/v2/"
        ]

        var postData: Data?
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error)
        }

        guard let url = URL(string: "https://mkerekes.eu.auth0.com/oauth/token") else {
            return
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if response != nil {
                let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(json)
                callback(true, nil)
            }
            if let error = error {
                callback(false, error)
            }
        })
        task.resume()
    }

    func getUserProfile(with token: String, userID: String, callback: @escaping (Bool, Error?) -> ()) {

        let headers = ["authorization": "Bearer \(token)"]

        guard let url = URL(string: "https://mkerekes.eu.auth0.com/api/v2/users/\(userID)") else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if response != nil {
                let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(json)
                callback(true, nil)
            }
            if let error = error {
                callback(false, error)
            }
        })
        task.resume()
    }
    
    func use(fbToken: String, with callback: @escaping (Bool, Error?) -> ()) throws {
//        Auth0
//            .authentication()
//            .loginSocial(token: fbToken, connection: "facebook", scope: "openid", parameters: [:])
//            .start { result in
//                switch (result) {
//                case .success(let credentials):
//                    callback(true, nil)
//                case .failure(let error):
//                    callback(false, error)
//                }
//        }

        
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
        let headers = [
            "content-type": "application/json",
            "authorization": "Bearer \(fbToken)"
        ]
        let dict = ["client_id": "nrZxfSdXoKwkp7qZ2kWEiwSZeqStauTb",
                    "access_token": fbToken,
                    "connection": "facebook",
                    "scope": "openid"]
        
        let json: JSON = JSON(dict)
        
        guard let url = URL(string: "https://mkerekes.eu.auth0.com/oauth/access_token") else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.httpBody = try json.rawData()
        request.allHTTPHeaderFields = headers
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if response != nil {
                let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(json)
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
