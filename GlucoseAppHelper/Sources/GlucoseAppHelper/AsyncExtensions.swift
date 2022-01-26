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
            if let data = try? await getLastSensorGlucose() {
                updateHandler(data)
            }
        }
    }
}

