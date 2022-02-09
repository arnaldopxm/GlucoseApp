//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftKeychainWrapper

public class KeychainController: IKeychainController {
    
    public static let singleton: IKeychainController = KeychainController()
    
    private let keychain: IKeychain = Keychain(serviceName: "com.arnaldoquintero.glucoseapp")
    
    public func store(username: String, password: String) {
        keychain.setValue(username, forKey: "username")
        keychain.setValue(password, forKey: "password")
    }
}
