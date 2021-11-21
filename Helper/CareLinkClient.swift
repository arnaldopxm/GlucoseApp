import Foundation
import SwiftKeychainWrapper


class CareLinkClient: ObservableObject {
    
    @Published var isLoggedIn = false
    private let keychain = KeychainWrapper(serviceName: "com.arnaldoquintero.glucoseapp")

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

    func login(username usr: String? = nil, password pwd: String? = nil) async throws -> Bool {

        if (cookie != nil && cookie?.expiresDate != nil && (cookie?.expiresDate)! >= Date.now) {
            return true
        }
        
        guard
            let usr = usr ?? username,
            let pwd = pwd ?? password
        else {
            return false
        }

        var res = false
        if let loginResponseCookie = try? await loginClient(username: usr, password: pwd) {
            username = usr
            password = pwd
            cookie = loginResponseCookie
            res = true
        }
        setLogin(value: res)
        return res
    }

    func setLogin(value: Bool) {
        DispatchQueue.main.async {
            self.isLoggedIn = value
        }
    }
    
    func getLastSensorGlucose() async throws -> DataResponse {
        if !(try! await reLogin()) {
            throw fatalError("Unauthorized")
        }
        let country = try! await getCountrySettingsClient()
        let token = cookie?.value
        let user = try! await getUserRoleClient(token: token!)
        
        
        let data = try!  await getDataClient(url: country.blePereodicDataEndpoint, username: username!, role: user.apiRole, token: token!)
        return data
    }
}
