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
    
    public func login(username: String, password: String, completion: ((_ loggedIn: Bool) -> Void)? = nil) {
        Task.init {
            let loggedIn = await validateCredentials.validate(username: username, password: password)
            if (completion != nil) {
                completion!(loggedIn)
            }
        }
    }
}
