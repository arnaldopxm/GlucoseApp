//
//  DataResponseModels.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 13/1/22.
//

import Foundation

struct DataResponse: Codable {
    let lastSG: SensorGlucose
    let lastSGTrend: SgTrend
}

struct SensorGlucose: Codable {
    let sg: Int
    let datetime: String?
}
