//
//  ClientService.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import Foundation

let url = "https://carelink.minimed.eu"
let reqHelper = RequestHelper()

func loginClient(username: String, password: String) async throws -> HTTPCookie? {
    
    var params: [(String, String)] = []
    let formEncodedHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
    
    var (data, response, cookies) = try await reqHelper.makeRequest(url: url + "/patient/sso/login?country=es&lang=en")
    params = extractFromBody(body: data)
    params += [
        ("username", username),
        ("password", password),
        ("actionButton", "Log in")
    ]
    
    let baseUrl = "https://mdtlogin.medtronic.com/mmcl/auth/oauth/v2/authorize"
    (data, response, cookies) = try await reqHelper.makeRequest(url: baseUrl + "/login?country=es&locale=en", method: .POST, headers: formEncodedHeaders, params: params)
    params = extractFromBody(body: data)
    
    (data, response, cookies) = try await reqHelper.makeRequest(url: baseUrl + "/consent", method: .POST, headers: formEncodedHeaders, params: params)
    
    if let location = response.allHeaderFields["Location"] as? String {
        (data, response, cookies) = try await reqHelper.makeRequest(url: location, method: .GET)
    }
    
    
    for cookie:HTTPCookie in cookies as [HTTPCookie] {
        print(cookie.name, cookie.value)
    }
    
    
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
    
    let (data, _, _) = try await reqHelper.makeRequest(url: url + "/patient/countries/settings", queryParams: queryParams)
    
    let stringData = data.data(using: .utf8)!
    let json = try! JSONDecoder().decode(CountrySettings.self, from: stringData)
    
    return json
}

func getUserRoleClient(token t: String) async throws -> UserSettings {
    
    let headers = ["Authorization": "Bearer \(t)"]
    
    let (data, _, _) = try await reqHelper.makeRequest(url: url + "/patient/users/me", headers: headers)
    
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
    
    let (data, _, _) = try await reqHelper.makeRequest(url: url, method: .POST, headers: headers, body: jsonBody!)
    
    let stringData = data.data(using: .utf8)!
    let json = try! JSONDecoder().decode(DataResponse.self, from: stringData)
    
    return json
}


//---------
enum SgTrend: String, Codable {
    case NONE
    case DOWN
    case DOWN_DOUBLE
    case DOWN_TRIPLE
    case UP
    case UP_DOUBLE
    case UP_TRIPLE
}

extension SgTrend {
    var icon: String {
        switch self {
        case .DOWN: return "↓"
        case .DOWN_DOUBLE: return "↓↓"
        case .DOWN_TRIPLE: return "↓↓↓"
        case .UP: return "↑"
        case .UP_DOUBLE: return "↑↑"
        case .UP_TRIPLE: return "↑↑↑"
        case .NONE: return ""
        }
    }
}

struct SensorGlucose: Codable {
    let sg: Int
    let datetime: String
}

struct DataResponse: Codable {
    let lastSG: SensorGlucose
    let lastSGTrend: SgTrend
}

struct CountrySettings: Codable {
    let blePereodicDataEndpoint: String
}

enum UserRoles: String {
    case ROLE_CARE_PARTNER = "CARE_PARTNER"
    case ROLE_CARE_PARTNER_OUS = "CARE_PARTNER_OUS"
    case USER_ROLE_CARE_PARTNER = "carepartner"
    case USER_ROLE_PATIENT = "patient"
}

struct UserSettings: Codable {
    let role: String
    var apiRole: String {
        if role == UserRoles.ROLE_CARE_PARTNER.rawValue || role == UserRoles.ROLE_CARE_PARTNER.rawValue {
            return UserRoles.USER_ROLE_CARE_PARTNER.rawValue
        } else {
            return UserRoles.USER_ROLE_PATIENT.rawValue
        }
    }
}
