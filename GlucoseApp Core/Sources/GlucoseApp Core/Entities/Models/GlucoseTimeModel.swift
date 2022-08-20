//
//  GlucoseTimeModel.swift
//
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public struct GlucoseTimeModel: Codable, Equatable, CustomStringConvertible {
    
    public let value: Date?
    
    public init(dateTime: String?) {
        guard let date = dateTime else {
            self.value = nil
            return
        }
        self.value = DateTimeService.stringToDateTime(stringValue: date)
    }
    
    public init(dateTime: Date) {
        self.value = dateTime
    }
    
    public static func == (lhs: GlucoseTimeModel, rhs: GlucoseTimeModel) -> Bool {
        if (lhs.value == nil) {
            return rhs.value == nil
        } else {
            if (rhs.value != nil) {
                return rhs.value?.distance(to: lhs.value!) == 0
            } else {
                return false
            }
        }
    }
    
    public func getFormattedHourTime() -> String {
    
        guard let date = self.value else {
            return "---"
        }
        return DateTimeService.dateToString(date: date)
    }
    
    public func getPastTimeSinceNowString() -> String {
        guard let minutes = getPastTimeSinceNow() else {
            return "---"
        }
        return "Hace \(minutes) min."
    }
    
    internal func getPastTimeSinceNow() -> Int? {
        guard let date = value else {
            return nil
        }
        
        let offsetInSeconds = date.distance(to: Date())
        let offsetInMinutes = offsetInSeconds / 60
        return Int(offsetInMinutes)
    }
    
    public var description: String {
        return "Time: \(self.value?.ISO8601Format() ?? "X")"
    }
    
}
