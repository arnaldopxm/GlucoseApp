//
//  AppState.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class AppState: Codable, CustomStringConvertible {
    
    public var gs: GlucoseModel
    public var gsTrend: GlucoseTrendModel
    public var gsTime: GlucoseTimeModel
    public var sensorState: String?
    
    public init(gs: GlucoseModel, gsTrend: GlucoseTrendModel, gsTime: GlucoseTimeModel, sensorState: String? = nil) {
        self.gs = gs
        self.gsTrend = gsTrend
        self.gsTime = gsTime
        self.sensorState = sensorState
    }
    
    public func isValid() -> Bool {
        let offset = self.gsTime.getPastTimeSinceNow() ?? 6
        return offset <= 5
    }
    
    public func updateNeededFields(from data: AppState) {
        if self.gs != data.gs {
            self.gs = data.gs
        }
        
        if (self.gsTime != data.gsTime) {
            self.gsTime = data.gsTime
        }
        
        if (self.gsTrend != data.gsTrend) {
            self.gsTrend = data.gsTrend
        }
        
        self.sensorState = data.sensorState
    }
    
    public func getStringSerialized() -> String {
        guard
            let jsonData = try? JSONEncoder().encode(self),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return ""
        }
        return jsonString
    }
    
    public static func parseFrom(jsonString: String) -> AppState? {
        guard
            let jsonData = jsonString.data(using: .utf8),
            let json = try? JSONDecoder().decode(AppState.self, from: jsonData)
        else {
            return nil
        }
        return json
    }
    
    public var description: String {
        return "\(self.gs) \(self.gsTrend) \(self.gsTime)"
    }
    
}
