//
//  AsyncExtensions.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 13/1/22.
//

import Foundation

extension CareLinkClient {
    public func findLastGlucoseTaskSync(updateHandler: @escaping (_ data: DataResponse) -> () ) {
        Task.init() {
            do {
                let data = try await getLastSensorGlucose()
                print("Data received: ", data)
                updateHandler(data)
            } catch {
                print("ERROR FETCHING: \(error)")
            }
        }
    }
    
    public func loginSync(username: String, password: String, _ completion: @escaping (_ loggedIn: Bool) -> () ) {
        Task.init() {
            do {
                let data = try await login(username: username, password: password)
                completion(data)
            } catch {
                completion(false)
            }
        }
    }
    
    public func checkLoginSync(_ completion: @escaping (_ loggedIn: Bool) -> () ) {
        Task.init() {
            do {
                let data = try await checkLogin()
                completion(data)
            } catch {
                completion(false)
            }
        }
    }
}

