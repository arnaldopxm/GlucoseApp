//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

class DeleteCredentials {
    public static let singleton = DeleteCredentials()
    private let keychainController: IKeychainController = KeychainController.singleton
    
    public func delete(provider: ProvidersEnum) {
        keychainController.deleteCredentialsFrom(provider: provider)
    }
}
