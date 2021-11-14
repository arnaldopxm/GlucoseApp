import Foundation

public struct CareLinkClient {
    
    public private(set) var username: String
    public private(set) var password: String
    public private(set) var countryCode: String
    public var loginCookie: HTTPCookie?

    init(username u: String, password p: String, countryCode c: String) async throws {
        username = u
        password = p
        countryCode = c
        let cookie = try await login(username: username, password: password)
        loginCookie = cookie
    }

    func login(username: String, password: String) async throws -> HTTPCookie? {
        return try await loginClient(username: username, password: password)
    }
}
