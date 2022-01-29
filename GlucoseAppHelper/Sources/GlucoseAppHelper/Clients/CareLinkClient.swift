import Foundation
import SwiftKeychainWrapper


@available(macOS 12.0, *)
@available(iOS 15.0.0, *)
@available(watchOS 8.0.0, *)
public class CareLinkClient {
    
    static public var singleton = CareLinkClient()
    private let keychain = KeychainWrapper(serviceName: "com.arnaldoquintero.glucoseapp")
    public private(set) var countryCode: String?
    private var cookie: HTTPCookie?
    
    var username: String?
    {
        get {
            return keychain.string(forKey: "username")
        }
        set (val) {
            if val != nil && !val!.isEmpty {
                keychain.set(val!, forKey: "username")
            }
        }
    }
    var password: String?
    {
        get {
            return keychain.string(forKey: "password")
        }
        set (val) {
            if val != nil && !val!.isEmpty {
                keychain.set(val!, forKey: "password")
            }
        }
    }
    
    
    init(username u: String? = nil, password p: String? = nil, countryCode cc: String? = nil){
        
        if (u != nil && u!.isEmpty) {
            username = u
        }
        
        if (p != nil && p!.isEmpty) {
            password = p
        }
        
        if (cc != nil && cc!.isEmpty) {
            countryCode = cc
        }
        
        Task.init() {
            try? await checkLogin()
        }
    }
    
    private func checkLogin() async throws -> Bool {
        guard
            let username = self.username,
            let password = self.password
        else {
            return false
        }
        return try await login(username: username, password: password)
        
    }

    public func login(username usr: String, password pwd: String) async throws -> Bool {
        
        if (cookie != nil && cookie?.expiresDate != nil && (cookie?.expiresDate)! >= Date(timeIntervalSinceNow: 0)) {
            AppState.singleton.setLogin(value: true)
            return true
        }
        
        var res = false
        if let loginResponseCookie = try? await ClientService.loginClient(username: usr, password: pwd) {
            self.username = usr
            self.password = pwd
            self.cookie = loginResponseCookie
            res = true
        }
        AppState.singleton.setLogin(value: res)
        return res
    }
    
    public func getLastSensorGlucose() async throws -> DataResponse {
        
        guard try await checkLogin(), let token = cookie?.value else {
            throw HttpErrors.GetLastSensorGlucoseError
        }
        let country = try await ClientService.getCountrySettingsClient()
        let user = try await ClientService.getUserRoleClient(token: token)
        let data = try await ClientService.getDataClient(url: country.blePereodicDataEndpoint, username: username!, role: user.apiRole, token: token)
        
        return data
    }
    
    public func logout() {
        keychain.removeAllKeys()
        AppState.singleton.clear()
    }
}
