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

func makeRequest(url u: String, method: HttpMethod = .GET, headers: [String: String]? = nil, queryParams: [(String, String)] = [], params: [(String, String)] = [], group: DispatchGroup? = nil,completion: @escaping (String, URLResponse) -> Void ) {
    group?.enter()
    
    guard var url = URLComponents(string: u) else { return }
    
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
    
    URLSession.shared.dataTask(with: req) { data, response, error in
        guard
            let data = String(data:data!, encoding: .utf8),
            let response = response
        else {
            return
        }
        completion(data, response)
        group?.leave()
    }.resume()
    group?.wait()
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

