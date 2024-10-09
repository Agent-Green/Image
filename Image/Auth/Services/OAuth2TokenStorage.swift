//
//  OAuth2TokenStorage.swift
//  Image
//
//  Created by Алиса  Грищенкова on 10.09.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "bearerToken")
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: "bearerToken")
            }
        }
    }
}
