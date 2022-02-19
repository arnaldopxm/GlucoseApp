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
    private var username: String = ""
    private var password: String = ""
    private var cookie: HTTPCookie? = nil
    
    public func validateCredentials(username usr: String, password pwd: String) async throws -> Bool {
        
        if (usr.isEmpty || pwd.isEmpty) {
            return false
        }
        
        var res = false
        if let loginResponseCookie = try? await client.login(username: usr, password: pwd) {
            self.cookie = loginResponseCookie
            self.username = usr
            self.password = pwd
            res = true
        }
        
        return res
    }
    
    public func getLastSensorGlucose() async throws -> DataResponse {
        
        guard try await validateCredentials(username: self.username, password: self.password) else {
            throw HttpErrors.CredentialsError
        }
        
        print("fetching")
        
        let token = cookie!.value
        let country = try await client.getCountrySettings()
        let user = try await client.getUserRole(token: token)
        let data = try await client.getData(
            url: country.blePereodicDataEndpoint,
            username: self.username,
            role: user.apiRole,
            token: token
        )
        
        return data
    }
    
}
