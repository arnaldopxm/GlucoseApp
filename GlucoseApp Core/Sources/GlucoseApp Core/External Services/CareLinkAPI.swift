//
//  CareLinkAPI.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class CareLinkAPI: ICareLinkAPI {
    
    public static let singleton: ICareLinkAPI = CareLinkAPI()
    
    public func login(username: String, password: String) async throws -> HTTPCookie {
        
        var params: [(String, String)] = []
        let formEncodedHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        
        guard let (data, _) = try? await makeRequest(url: HttpTranspontConst.CarelinkUrl + "/patient/sso/login?country=es&lang=en")
        else {
            throw HttpErrors.LoginError
        }
        
        params = extractFromBody(body: data)
        params += [
            ("username", username),
            ("password", password),
            ("actionButton", "Log in")
        ]
        
        let baseUrl = "https://mdtlogin.medtronic.com/mmcl/auth/oauth/v2/authorize"
        guard let (data, _) = try? await makeRequest(url: baseUrl + "/login?country=es&locale=en", method: .POST, headers: formEncodedHeaders, params: params) else {
            throw HttpErrors.CredentialsError
        }
        
        params = extractFromBody(body: data)
        
        guard let (_, _) = try? await makeRequest(url: baseUrl + "/consent", method: .POST, headers: formEncodedHeaders, params: params)
        else {
            throw HttpErrors.ConsentError
        }
        
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            throw HttpErrors.CookieStorageMissingError
        }
        guard let cookie = cookies.first( where: { $0.name == "auth_tmp_token" }) else {
            throw HttpErrors.CookieNotFoundError
        }
        
        return cookie
    }

    public func getCountrySettings() async throws -> CountrySettings {
        let queryParams = [
            ("countryCode","es"),
            ("language","en")
        ]
        guard let (data, _) = try? await makeRequest(url: HttpTranspontConst.CarelinkUrl + "/patient/countries/settings", queryParams: queryParams) else {
            throw HttpErrors.GetSettingsError
        }
        
        let stringData = data.data(using: .utf8)!
        guard let json = try? JSONDecoder().decode(CountrySettings.self, from: stringData) else {
            throw HttpErrors.JsonSerializationError
        }
        
        return json
    }
    
    public func getUserRole(token t: String) async throws -> UserSettings {
        let headers = ["Authorization": "Bearer \(t)"]
        
        guard let (data, _) = try? await makeRequest(url: HttpTranspontConst.CarelinkUrl + "/patient/users/me", headers: headers) else {
            throw HttpErrors.GetUserRoleError
        }
        
        let stringData = data.data(using: .utf8)!
        guard let json = try? JSONDecoder().decode(UserSettings.self, from: stringData) else {
            throw HttpErrors.JsonSerializationError
        }
        
        return json
    }
    
    public func getData(url dataUrl: String, username: String, role: String, token t: String) async throws -> DataResponse {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(t)"
        ]
        let body = [
            "username": username,
            "role": role
        ]
        guard let jsonBody = try? JSONEncoder().encode(body) else {
            throw HttpErrors.JsonSerializationError
        }
        
        guard let (data, _) = try? await makeRequest(url: dataUrl, method: .POST, headers: headers, body: jsonBody) else {
            throw HttpErrors.GetDataError
        }
        
        let stringData =  data.data(using: .utf8)!
        guard let json = try? JSONDecoder().decode(DataResponse.self, from: stringData)
        else {
            throw HttpErrors.JsonSerializationError
        }
        
        return json
    }

}
