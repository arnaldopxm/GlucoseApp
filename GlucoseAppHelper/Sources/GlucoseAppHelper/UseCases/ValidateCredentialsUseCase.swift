//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

class ValidateCredentials {
    public static let singleton = ValidateCredentials()
    private let carelinkController: ICareLinkController = CareLinkController.singleton
    
    public func validate(username: String, password: String) async -> Bool {
        let result = try? await carelinkController.validateCredentials(username: username, password: password)
        return result ?? false
    }
}
