//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class StoreCredentials {
    public static let singleton = StoreCredentials()
    private let keychainController: IKeychainController = KeychainController.singleton
    
    public func store(username: String, password: String) {
        keychainController.store(username: username, password: password)
    }
}
