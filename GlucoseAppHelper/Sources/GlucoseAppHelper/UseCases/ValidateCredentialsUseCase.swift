//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import GlucoseApp_Core

class ValidateCredentials {
    public static let singleton = ValidateCredentials()
    private let carelinkController: ICareLinkController = CareLinkController.singleton
    
    public func validate(username: String, password: String) async -> Bool {
        #if DEBUG
        if CommandLine.arguments.contains(TestingConst.TESTING_FLAG) {
            if username == TestingConst.TESTING_USERNAME && password == TestingConst.TESTING_PASSWORD {
                return true
            }
            return false
        }
        #endif

        let result = try? await carelinkController.validateCredentials(username: username, password: password)
        return result ?? false
    }
}
