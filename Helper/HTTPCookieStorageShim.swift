//
//  File.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 11/1/22.
//
import Foundation

// This class just forwards all public methods to the sharedHTTPCookieStorage to workaround the issue.
class HTTPCookieStorageShim: HTTPCookieStorage {

    func cookies() -> [HTTPCookie]? {
        return HTTPCookieStorage.shared.cookies
    }

    func deleteCookie(cookie: HTTPCookie) {
        HTTPCookieStorage.shared.deleteCookie(cookie)
    }

    func removeCookiesSinceDate(date: Date) {
        HTTPCookieStorage.shared.removeCookies(since: date)
    }

    func cookiesForURL(URL: URL) -> [HTTPCookie]? {
        return HTTPCookieStorage.shared.cookies(for: URL)
    }

    func setCookies(cookies: [HTTPCookie], for URL:URL?, mainDocumentURL:URL?) {
        HTTPCookieStorage.shared.setCookies(cookies, for: URL, mainDocumentURL: mainDocumentURL)
    }

    func cookieAcceptPolicy() -> HTTPCookie.AcceptPolicy {
        return HTTPCookieStorage.shared.cookieAcceptPolicy
    }

    func setCookieAcceptPolicy(cookieAcceptPolicy: HTTPCookie.AcceptPolicy) {
        HTTPCookieStorage.shared.cookieAcceptPolicy = cookieAcceptPolicy
    }

    func sortedCookiesUsingDescriptors(using sortOrder:[NSSortDescriptor]) -> [HTTPCookie]! {
        return HTTPCookieStorage.shared.sortedCookies(using: sortOrder)
    }

    func storeCookies(cookies: [HTTPCookie], for task: URLSessionTask) {
        HTTPCookieStorage.shared.storeCookies(cookies, for: task)
    }

    func getCookiesForTask(task: URLSessionTask, completionHandler: @escaping ([HTTPCookie]?) -> Void) {
        HTTPCookieStorage.shared.getCookiesFor(task, completionHandler: completionHandler)
    }
}
