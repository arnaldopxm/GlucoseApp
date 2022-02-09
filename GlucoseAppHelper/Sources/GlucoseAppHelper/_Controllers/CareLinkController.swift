//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class CareLinkController: ICareLinkController {
    
    public static let singleton: ICareLinkController = CareLinkController()

    private let client: ICareLinkAPI = CareLinkAPI.singleton
    private var cookie: HTTPCookie?
    
    public func validateCredentials(username usr: String, password pwd: String) async throws -> Bool {
        
        if (usr.isEmpty || pwd.isEmpty) {
            return false
        }
        
        if (cookie != nil && cookie?.expiresDate != nil && (cookie?.expiresDate)! >= Date(timeIntervalSinceNow: 0)) {
            return true
        }
        
        var res = false
        if let loginResponseCookie = try? await client.loginClient(username: usr, password: pwd) {
            self.cookie = loginResponseCookie
            res = true
        }

        return res
    }

}
