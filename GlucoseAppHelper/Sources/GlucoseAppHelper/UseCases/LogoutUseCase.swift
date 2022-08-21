//
//  LoginUseCase.swift
//
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class LogoutUseCase {
    
    public static let singleton = LogoutUseCase()
    private let deleteCredentials = DeleteCredentials.singleton
    
    public func logout(provider: ProvidersEnum) {
        deleteCredentials.delete(provider: provider)
    }
}
