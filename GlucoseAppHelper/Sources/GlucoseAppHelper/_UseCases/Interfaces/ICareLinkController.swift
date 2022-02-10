//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public protocol ICareLinkController {

    func validateCredentials(username: String, password: String) async throws -> Bool
    
    func getLastSensorGlucose() async throws -> DataResponse
}
