//
//  KeychainStorage.swift
//  Salsette
//
//  Created by Marton Kerekes on 07/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import SimpleKeychain

class KeychainStorage {

    private let keychain = A0SimpleKeychain(service: "Auth0")
    private init() {}

    static let shared = KeychainStorage()

    subscript(key: String) -> String? {
        get {
            return string(for: key)
        }
        set {
            guard let newString = newValue else {
                return
            }
            set(newString, for: key)
        }
    }

    func set(_ value: String?, for key: String) {
        if let value = value {
            keychain.setString(value, forKey: key)
        } else {
            keychain.deleteEntry(forKey: key)
        }
    }

    func string(for key: String) -> String? {
        return keychain.string(forKey: key)
    }

    func clear() {
        A0SimpleKeychain(service: "Auth0").clearAll()
    }
}
