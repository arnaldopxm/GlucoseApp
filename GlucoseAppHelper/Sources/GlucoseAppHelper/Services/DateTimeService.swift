//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 17/2/22.
//

import Foundation

public struct DateTimeService {
    
    public static func stringToDateTime(stringValue: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: stringValue)
    }
    
    public static func dateToString(date: Date, format: String = "HH:mm 'h'") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
}
