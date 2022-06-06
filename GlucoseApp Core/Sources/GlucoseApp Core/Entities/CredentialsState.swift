//
//  CredentialsState.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class CredentialsState: Codable {
    
    public let username: String
    public let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
