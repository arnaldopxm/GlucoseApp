import Foundation
import SwiftKeychainWrapper


@available(iOS 15.0.0, *)
@available(watchOS 8.0.0, *)
public class CareLinkClient {
    
    private let keychain = KeychainWrapper(serviceName: "com.arnaldoquintero.glucoseapp")
    static public var singleton = CareLinkClient()

    var username: String? {
        get {
            return keychain.string(forKey: "username")
        }
        set (val) {
            if val != nil && !val!.isEmpty {
                keychain.set(val!, forKey: "username")
            }
        }
    }
    var password: String? {
        get {
            return keychain.string(forKey: "password")
        }
        set (val) {
            if val != nil && !val!.isEmpty {
                keychain.set(val!, forKey: "password")
            }
        }
    }
    public private(set) var countryCode: String?
    private var cookie: HTTPCookie?
    
    
    init(username u: String? = nil, password p: String? = nil, countryCode cc: String? = nil){
        username = u ?? username
        password = p ?? password
        countryCode = cc ?? countryCode
        Task.init() {
            try? await checkLogin()
        }
    }
    
    private func checkLogin() async throws -> Bool {
        guard
            let username = username,
            let password = password
        else {
            return false
        }
        return try await login(username: username, password: password)

    }
    
    private func reLogin() async throws -> Bool {
        return try await login(username: username!, password: password!)
    }

    public func login(username usr: String? = nil, password pwd: String? = nil) async throws -> Bool {

        if (cookie != nil && cookie?.expiresDate != nil && (cookie?.expiresDate)! >= Date(timeIntervalSinceNow: 0)) {
            return true
        }
        
        guard
            let usr = usr ?? username,
            let pwd = pwd ?? password
        else {
            return false
        }

        var res = false
        if let loginResponseCookie = try? await ClientService.loginClient(username: usr, password: pwd) {
            username = usr
            password = pwd
            cookie = loginResponseCookie
            res = true
        }
        AppState.singleton.setLogin(value: res)
        return res
    }
    
    public func getLastSensorGlucose() async throws -> DataResponse? {
        
        guard
            try await reLogin(),
            let country = try? await ClientService.getCountrySettingsClient(),
            let token = cookie?.value,
            let user = try? await ClientService.getUserRoleClient(token: token),
            let data = try? await ClientService.getDataClient(url: country.blePereodicDataEndpoint, username: username!, role: user.apiRole, token: token)
        else {
            print("Error fetching last glucose")
            return nil
        }
                    
                
        return data
    }
}
