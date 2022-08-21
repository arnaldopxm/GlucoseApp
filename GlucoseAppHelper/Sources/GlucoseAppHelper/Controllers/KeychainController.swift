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
    
    public func storeCredentials(username: String, password: String, provider: ProvidersEnum) {
        keychain.setValue(username, forKey: "\(provider)_username")
        keychain.setValue(password, forKey: "\(provider)_password")
    }
    
    public func getCredentials(provider: ProvidersEnum) -> CredentialsState? {
        guard
            let username = keychain.get(key: "\(provider)_username"),
            let password = keychain.get(key: "\(provider)_password")
        else {
            return nil
        }
        return CredentialsState(username: username, password: password)
    }
    
    public func deleteCredentialsFrom(provider: ProvidersEnum) {
        keychain.removeKey("\(provider)_username")
        keychain.removeKey("\(provider)_password")
    }
}
