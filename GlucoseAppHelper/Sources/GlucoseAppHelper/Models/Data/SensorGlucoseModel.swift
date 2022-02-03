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
        return SensorGlucose.getSgColor(sg: self.sg)
    }
    
    public static func getSgColor(sg: String) -> Color {
        let sgInt = Int(sg) ?? 0
        return getSgColor(sg: sgInt)
    }
    
    public static func getSgColor(sg: Int) -> Color {
        if (sg > 180) {
            return ColorsConst.SG_HIGH
        }
        if (sg < 70) {
            return ColorsConst.SG_LOW
        }
        return ColorsConst.SG_OK
    }
    
    public static func getDate(datetime: String?) -> Date? {
        guard let date = datetime else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: date)
    }
    
    public static func getTimeOffsetInMinutes(from date: Date?) -> Int? {
        guard let date = date else {
            return nil
        }
        
        let offsetInSeconds = date.distance(to: Date())
        let offsetInMinutes = offsetInSeconds / 60
        return Int(offsetInMinutes)
    }
    
    public static func getTimeOffsetInMinutes(from date: String?) -> Int? {
        guard let date = getDate(datetime: date) else {
            return nil
        }
        return getTimeOffsetInMinutes(from: date)
    }
}
