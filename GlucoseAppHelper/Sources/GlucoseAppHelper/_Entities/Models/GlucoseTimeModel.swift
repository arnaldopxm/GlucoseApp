//
//  File.swift
//
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public struct GlucoseTimeModel: Codable {
    
    public let value: Date?
    
    public init(dateTime: String?) {
        self.value = GlucoseTimeModel.getDate(datetimeString: dateTime)
    }
    
    public init(dateTime: Date) {
        self.value = dateTime
    }
    
    public func Equals(_ obj: GlucoseTimeModel) -> Bool {
        if (value == nil) {
            return obj.value == nil
        } else {
            if (obj.value != nil) {
                return obj.value?.distance(to: value!) == 0
            } else {
                return false
            }
        }
    }
    
    public func getFormattedHourTime() -> String {
    
        guard let date = self.value else {
            return "---"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm 'h'"
        let formatedDate = dateFormatter.string(from: date)
        
        return formatedDate
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
    
    private static func getDate(datetimeString: String?, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date? {
        guard let date = datetimeString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)
    }
    
    
}
