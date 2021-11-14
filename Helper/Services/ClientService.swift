//
//  ClientService.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import Foundation

func loginClient(username: String, password: String) async throws -> HTTPCookie? {
    
    var params: [(String, String)] = []
    let formEncodedHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
    let url = "https://carelink.minimed.eu"
    
    var (data, response) = try await makeRequest(url: url + "/patient/sso/login?country=es&lang=en")
    params = extractFromBody(body: data)
    params += [
        ("username", username),
        ("password", password),
        ("actionButton", "Log in")
    ]
    
    let baseUrl = "https://mdtlogin.medtronic.com/mmcl/auth/oauth/v2/authorize"
    (data, response) = try await makeRequest(url: baseUrl + "/login?country=es&locale=en", method: .POST, headers: formEncodedHeaders, params: params)
    params = extractFromBody(body: data)
    
    (data, response) = try await makeRequest(url: baseUrl + "/consent", method: .POST, headers: formEncodedHeaders, params: params)
    let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies! as [HTTPCookie]
    guard let cookie = cookies.first( where: { $0.name == "auth_tmp_token" }) else {
        throw fatalError("Invalid Login")
    }

    return cookie
}
