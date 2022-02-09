//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftKeychainWrapper

public class Keychain: KeychainWrapper, IKeychain {
    
    public required init(serviceName: String) {
        super.init(serviceName: serviceName)
    }
    
    public func setValue(_ value: String, forKey key: String) -> Bool {
        return set(value, forKey: key)
    }
    
    
}
