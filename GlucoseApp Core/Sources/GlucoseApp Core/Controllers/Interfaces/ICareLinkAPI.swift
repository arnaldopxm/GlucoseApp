//
//  ICareLinkAPI.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public protocol ICareLinkAPI {
    func login(username: String, password: String) async throws -> HTTPCookie
    
    func getCountrySettings() async throws -> CountrySettings
    
    func getUserRole(token t: String) async throws -> UserSettings
    
    func getData(url dataUrl: String, username: String, role: String, token t: String) async throws -> DataResponse
}
