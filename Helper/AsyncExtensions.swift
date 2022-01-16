//
//  AsyncExtensions.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 13/1/22.
//

import Foundation

extension CareLinkClient {
    func findLastGlucoseTaskSync(updateHandler: @escaping (_ data: DataResponse) -> () ) {
        Task.init() {
            if let data = try? await getLastSensorGlucose() {
                updateHandler(data)
            }
        }
    }
}

