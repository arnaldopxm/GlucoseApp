//
//  SensorGlucoseModel.swift
//  
//
//  Created by Arnaldo Quintero on 29/1/22.
//

import Foundation
import SwiftUI

public struct SensorGlucose: Codable {
    
    internal init(sg: Int, datetime: String?, sensorState: String? = nil) {
        self.sg = sg
        self.datetime = datetime
        self.sensorState = sensorState
    }
    
    public let sg: Int
    public let datetime: String?
    public let sensorState: String?
}

extension SensorGlucose {
    public var sgColor: Color {
        if (self.sg >= 250) {
            return ColorsConst.SG_HIGH
        }
        if (self.sg < 70) {
            return ColorsConst.SG_LOW
        }
        return ColorsConst.SG_OK
    }
}
