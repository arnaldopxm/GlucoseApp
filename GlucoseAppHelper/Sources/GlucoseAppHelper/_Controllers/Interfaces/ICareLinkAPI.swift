//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public protocol ICareLinkAPI {
    func loginClient(username: String, password: String) async throws -> HTTPCookie
}
