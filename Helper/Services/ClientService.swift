//
//  ClientService.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import Foundation

let url = "https://carelink.minimed.eu"

func loginClient(username: String, password: String) async throws -> HTTPCookie? {
    
    var params: [(String, String)] = []
    let formEncodedHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
    
    var (data, _) = try await makeRequest(url: url + "/patient/sso/login?country=es&lang=en")
    params = extractFromBody(body: data)
    params += [
        ("username", username),
        ("password", password),
        ("actionButton", "Log in")
    ]
    
    let baseUrl = "https://mdtlogin.medtronic.com/mmcl/auth/oauth/v2/authorize"
    (data, _) = try await makeRequest(url: baseUrl + "/login?country=es&locale=en", method: .POST, headers: formEncodedHeaders, params: params)
    params = extractFromBody(body: data)
    
    (data, _) = try await makeRequest(url: baseUrl + "/consent", method: .POST, headers: formEncodedHeaders, params: params)
    let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies! as [HTTPCookie]
    guard let cookie = cookies.first( where: { $0.name == "auth_tmp_token" }) else {
        throw fatalError("Invalid Login")
    }
    
    return cookie
}

func getCountrySettingsClient() async throws -> CountrySettings {
    let queryParams = [
        ("countryCode","es"),
        ("language","en")
    ]
    
    let (data, _) = try await makeRequest(url: url + "/patient/countries/settings", queryParams: queryParams)
    
    let stringData = data.data(using: .utf8)!
    let json = try! JSONDecoder().decode(CountrySettings.self, from: stringData)
    
    return json
}

func getUserRoleClient(token t: String) async throws -> UserSettings {
    
    let headers = ["Authorization": "Bearer \(t)"]
    
    let (data, _) = try await makeRequest(url: url + "/patient/users/me", headers: headers)
    
    let stringData = data.data(using: .utf8)!
    let json = try! JSONDecoder().decode(UserSettings.self, from: stringData)
    
    return json
}

func getDataClient(url: String, username: String, role: String, token t: String) async throws -> DataResponse {
    let headers = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(t)"
    ]
    let body = [
        "username": username,
        "role": role
    ]
    let jsonBody = try? JSONEncoder().encode(body)
    
    let (data, _) = try await makeRequest(url: url, method: .POST, headers: headers, body: jsonBody!)
    
    let stringData = data.data(using: .utf8)!
    let json = try! JSONDecoder().decode(DataResponse.self, from: stringData)
    
    return json
}
