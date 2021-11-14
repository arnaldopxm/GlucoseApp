//
//  File.swift
//
//
//  Created by Arnaldo Quintero on 14/11/21.
//s

import Foundation


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




func makeRequest(url u: String, method: HttpMethod = .GET, headers: [String: String]? = nil, queryParams: [(String, String)] = [], params: [(String, String)] = []) async throws -> (String, URLResponse) {
    
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
    
    req.allHTTPHeaderFields = headers
    
    let (data, response) = try await URLSession.shared.data(for: req)
    guard let dataString = String(data:data, encoding: .utf8) else {
        throw fatalError("Impossible to parse data")
    }
    return (dataString, response)
}
