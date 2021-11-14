import Foundation

class CareLinkClient: ObservableObject {
    
    @Published var isLoggedIn = false
    
    public private(set) var username: String?
    public private(set) var password: String?
    public private(set) var countryCode: String?
    private var cookie: HTTPCookie?

    func login(username usr: String, password pwd: String) async throws -> Bool {
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
}
