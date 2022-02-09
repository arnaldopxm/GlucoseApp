//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class CareLinkAPI: ICareLinkAPI {
    
    public static let singleton: ICareLinkAPI = CareLinkAPI()
    
    public func loginClient(username: String, password: String) async throws -> HTTPCookie {
        
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
}
