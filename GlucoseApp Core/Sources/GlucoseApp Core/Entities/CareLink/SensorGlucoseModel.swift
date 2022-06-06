//
//  SensorGlucoseModel.swift
//  
//
//  Created by Arnaldo Quintero on 29/1/22.
//

import Foundation

public struct SensorGlucose: Codable {
    
    public init(sg: Int, datetime: String?, sensorState: String? = nil) {
        self.sg = sg
        self.datetime = datetime
        self.sensorState = sensorState
    }
    
    public let sg: Int
    public let datetime: String?
    public let sensorState: String?
}
