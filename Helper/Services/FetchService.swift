//
//  File.swift
//
//
//  Created by Arnaldo Quintero on 14/11/21.
//s

import Foundation
import Alamofire

extension Dictionary {
    static func += (left: inout Dictionary, right: Dictionary) {
        for (key, value) in right {
            left[key] = value
        }
    }
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
}

func extractFromBody(body: String, pattern: String = "<input type=\"hidden\" name=\"([^\"]*)\" value=\"([^\"]*)\"") -> [(String,String)] {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
        return []
    }
    
    let nsBody = body as NSString
    let range = NSRange(location: 0, length: nsBody.length)
    
    let regexMatches = regex.matches(in: body, options: [], range: range)
    let parsedMatches = regexMatches.map() { (match) -> (String, String) in
        let key = nsBody.substring(with: match.range(at: 1))
        let value = nsBody.substring(with: match.range(at: 2))
        return (key, value)
    }
    return parsedMatches
}

class RequestHelper: NSObject, URLSessionDelegate {
    
    private var session = URLSession.shared
    private let basicHeaders = [
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive"
    ]
    
    override init() {
        super.init()
        let shim = HTTPCookieStorageShim() as HTTPCookieStorage
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage = shim
        configuration.httpCookieAcceptPolicy = .always
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }
    
    func makeRequest(url u: String, method: HttpMethod = .GET, headers: [String: String]? = nil, queryParams: [(String, String)] = [], params: [(String, String)] = [], body: Data? = nil) async throws -> (String, HTTPURLResponse, [HTTPCookie]) {
        
        guard var url = URLComponents(string: u) else {
            throw fatalError("Invalid URL")
        }
        
        if !queryParams.isEmpty {
            let parsedParams = queryParams.map { URLQueryItem(name: $0, value: $1) }
            url.queryItems = parsedParams
        }
        
        var req = URLRequest(url: url.url!)
        req.httpMethod = method.rawValue
        
        if !params.isEmpty {
            var body = URLComponents()
            body.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
            req.httpBody = body.query?.data(using: .utf8)
        }
        
        if (body != nil) {
            req.httpBody = body
        }
        
        req.allHTTPHeaderFields = basicHeaders
        if (headers != nil && !headers!.isEmpty) {
            req.allHTTPHeaderFields! += headers!
        }
        
        
        let (data, res) = try await session.data(for: req)
        let response = res as! HTTPURLResponse
        let cookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies ?? []
        guard let dataString = String(data:data, encoding: .utf8) else {
            throw fatalError("Impossible to parse data")
        }
        return (dataString, response, cookies)
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.serverTrust == nil {
            completionHandler(.useCredential, nil)
        } else {
            let trust: SecTrust = challenge.protectionSpace.serverTrust!
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        }
    }

}
