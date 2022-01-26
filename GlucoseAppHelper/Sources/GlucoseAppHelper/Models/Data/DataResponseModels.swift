//
//  DataResponseModels.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 13/1/22.
//

import Foundation

public struct DataResponse: Codable {
    public let lastSG: SensorGlucose
    public let lastSGTrend: SgTrend
}

public struct SensorGlucose: Codable {
    public let sg: Int
    public let datetime: String?
}
