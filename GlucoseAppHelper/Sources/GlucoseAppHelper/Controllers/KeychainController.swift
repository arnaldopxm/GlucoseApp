//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftKeychainWrapper
import GlucoseApp_Core

public class KeychainController: IKeychainController {
    
    public static let singleton: IKeychainController = KeychainController()
    
    private let keychain: IKeychain = Keychain(serviceName: "com.arnaldoquintero.glucoseapp")
    
    public func storeCredentials(username: String, password: String) {
        keychain.setValue(username, forKey: "username")
        keychain.setValue(password, forKey: "password")
    }
    
    public func getCredentials() -> CredentialsState? {
        guard
            let username = keychain.get(key: "username"),
            let password = keychain.get(key: "password")
        else {
            return nil
        }
        return CredentialsState(username: username, password: password)
    }
    
    public func deleteAll() {
        keychain.removeAll()
    }
}
