//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftKeychainWrapper

public protocol IKeychain {
    
    init(serviceName: String)
    
    @discardableResult func setValue(_ value: String, forKey key: String) -> Bool
    func removeKey(_ key: String)
    func removeAll()
    func get(key: String) -> String?
    
}
