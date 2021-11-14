import Foundation

class CareLinkClient: ObservableObject {
    
    @Published var isLoggedIn = false
    
    public private(set) var username: String?
    public private(set) var password: String?
    public private(set) var countryCode: String?
    private var cookie: HTTPCookie?
    
    init(username u: String? = nil, password p: String? = nil, countryCode cc: String? = nil){
        username = u ?? username
        password = p ?? password
        countryCode = cc ?? countryCode
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
    
    func getData() async throws -> String {
        guard try! await checkLogin() else {
            throw fatalError("Unauthorized")
        }
        let country = try! await getCountrySettingsClient()
        let token = cookie?.value
        let user = try! await getUserRoleClient(token: token!)
        
        
        let data = try!  await getDataClient(url: country.blePereodicDataEndpoint, username: username!, role: user.apiRole, token: token!)
        return data
    }
}
