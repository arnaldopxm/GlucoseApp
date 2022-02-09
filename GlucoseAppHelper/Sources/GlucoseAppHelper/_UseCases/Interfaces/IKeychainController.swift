//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public protocol IKeychainController {
    
    func store(username: String, password: String)
    
    func deleteAll()
}
