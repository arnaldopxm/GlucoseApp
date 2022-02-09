//
//  File.swift
//
//
//  Created by Arnaldo Quintero on 14/11/21.
//s

import Foundation

func extractFromBody(body: String, pattern: String = HttpTranspontConst.ExtractInputKeyValuePairRegex) -> [(String,String)] {
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

func makeRequest(
    url u: String,
    method: HttpMethod = .GET,
    headers: [String: String]? = nil, queryParams: [(String, String)] = [], params: [(String, String)] = [], body: Data? = nil) async throws -> (String, URLResponse) {
        
        guard var url = URLComponents(string: u), url.url != nil else {
            throw HttpErrors.WrongUrlFormatError
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
        
        req.allHTTPHeaderFields = headers
        
        guard let (data, response) = try? await URLSession.shared.data(for: req) else {
            throw HttpErrors.HttpRequestFailError
        }
        let dataString = dataToString(data: data)
//        guard let res = response as? HTTPURLResponse, res.statusCode != 200 else {
//            throw HttpErrors.HttpRequestNotOkError
//        }
        return (dataString, response)
    }

func dataToString(data: Data?) -> String {
    if data == nil{
        return ""
    }
    guard let dataString = String(data:data!, encoding: .utf8) else {
        return ""
    }
    return dataString
}
