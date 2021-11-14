import Foundation

public struct CareLinkClient {
    
    public private(set) var username: String
    public private(set) var password: String
    public private(set) var countryCode: String
    public var loginCookie: HTTPCookie?

    init(username u: String, password p: String, countryCode c: String) {
        username = u
        password = p
        countryCode = c
        let cookie = login(username: username, password: password)
        loginCookie = cookie
    }

    func login(username: String, password: String) -> HTTPCookie? {
        
        var params: [(String, String)] = []
        var cookieResponse: HTTPCookie? = nil
        
        let group = DispatchGroup()
        let formEncodedHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        let url = "https://carelink.minimed.eu"
        
        makeRequest(url: url + "/patient/sso/login?country=es&lang=en", group: group) { data, response in
            params = extractFromBody(body: data)
            params += [
                ("username", username),
                ("password", password),
                ("actionButton", "Log in")
            ]
        }
        
        let baseUrl = "https://mdtlogin.medtronic.com/mmcl/auth/oauth/v2/authorize"
        makeRequest(url: baseUrl + "/login?country=es&locale=en", method: .POST, headers: formEncodedHeaders, params: params, group: group) { data, response in
            params = extractFromBody(body: data)
        }
        
        makeRequest(url: baseUrl + "/consent", method: .POST, headers: formEncodedHeaders, params: params, group: group) { data, response in
            let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies! as [HTTPCookie]
            guard let cookie = cookies.first( where: { $0.name == "auth_tmp_token" }) else{
                return
            }
            cookieResponse = cookie
        }
        return cookieResponse
    }
}
