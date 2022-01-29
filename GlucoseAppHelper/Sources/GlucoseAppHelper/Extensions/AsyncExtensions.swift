//
//  AsyncExtensions.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 13/1/22.
//

import Foundation

@available(iOS 15.0, *)
@available(watchOS 8.0, *)
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
}

