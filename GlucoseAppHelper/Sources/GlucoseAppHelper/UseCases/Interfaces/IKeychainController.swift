//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import GlucoseApp_Core

public protocol IKeychainController {
    
    func storeCredentials(username: String, password: String, provider: ProvidersEnum)
    
    func getCredentials(provider: ProvidersEnum) -> CredentialsState?
    
    func deleteCredentialsFrom(provider: ProvidersEnum)
}
