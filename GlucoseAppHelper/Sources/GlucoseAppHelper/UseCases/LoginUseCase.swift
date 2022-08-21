//
//  LoginUseCase.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class LoginUseCase {
    
    public static let singleton = LoginUseCase()
    private let validateCredentials = ValidateCredentials.singleton
    private let storeCredentials = StoreCredentials.singleton
    
    public func loginFromSavedCredentials(provider: ProvidersEnum, completion: ((_ loggedIn: Bool) -> Void)? = nil) {
        guard
            let credentials = storeCredentials.getCredentials(provider: provider)
        else {
            if (completion != nil) {
                completion!(false)
            }
            return
        }
        
        login(username: credentials.username, password: credentials.password, provider: provider, completion: completion)
    }
    
    public func login(username: String, password: String, provider: ProvidersEnum, completion: ((_ loggedIn: Bool) -> Void)? = nil) {
        Task.init {
            let loggedIn = await validateCredentials.validate(username: username, password: password)
            if (loggedIn) {
                storeCredentials.store(username: username, password: password, provider: provider)
            }
            if (completion != nil) {
                completion!(loggedIn)
            }
        }
    }
}
