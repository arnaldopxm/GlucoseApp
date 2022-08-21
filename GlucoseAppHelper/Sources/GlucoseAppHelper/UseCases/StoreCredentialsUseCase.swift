//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import GlucoseApp_Core


class StoreCredentials {
    public static let singleton = StoreCredentials()
    private let keychainController: IKeychainController = KeychainController.singleton
    
    public func store(username: String, password: String, provider: ProvidersEnum) {
        keychainController.storeCredentials(username: username, password: password, provider: provider)
    }
    
    public func getCredentials(provider: ProvidersEnum) -> CredentialsState? {
        return  keychainController.getCredentials(provider: provider)
    }
}
