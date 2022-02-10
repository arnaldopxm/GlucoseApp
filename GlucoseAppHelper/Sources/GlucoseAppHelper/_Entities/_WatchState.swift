//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class _WatchState: Codable {
    
    public var gs: GlucoseModel
    public var gsTrend: GlucoseTrendModel
    public var gsTime: GlucoseTimeModel
    
    public init(gs: GlucoseModel, gsTrend: GlucoseTrendModel, gsTime: GlucoseTimeModel) {
        self.gs = gs
        self.gsTrend = gsTrend
        self.gsTime = gsTime
    }
    
    public func isValid() -> Bool {
        let offset = self.gsTime.getPastTimeSinceNow() ?? 6
        return offset <= 5
    }
    
    public func updateNeededFields(from data: _WatchState) {
        if (!self.gs.Equals(data.gs)) {
            self.gs = data.gs
        }
        
        if (!self.gsTime.Equals(data.gsTime)) {
            self.gsTime = data.gsTime
        }
        
        if (!self.gsTrend.Equals(data.gsTrend)) {
            self.gsTrend = data.gsTrend
        }
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
    
    public static func parseFrom(jsonString: String) -> _WatchState? {
        guard
            let jsonData = jsonString.data(using: .utf8),
            let json = try? JSONDecoder().decode(_WatchState.self, from: jsonData)
        else {
            return nil
        }
        return json
    }
    
}
