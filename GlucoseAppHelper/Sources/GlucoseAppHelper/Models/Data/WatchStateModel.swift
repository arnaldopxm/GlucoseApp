//
//  WatchStateModel.swift
//
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation
import SwiftUI

public struct WatchStateModel: Codable {
    
    public var sg: String
    public var sgTime: String
    public var sgTrend: SgTrend

    init(sg: String = "---", sgTime: String = "", sgTrend: SgTrend = .NONE) {
        self.sg = sg
        self.sgTime = sgTime
        self.sgTrend = sgTrend
    }
    
    public static func parseFrom(jsonString: String) -> WatchStateModel? {
        guard
            let jsonData = jsonString.data(using: .utf8),
            let json = try? JSONDecoder().decode(WatchStateModel.self, from: jsonData)
        else {
            return nil
        }
        return json
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
}
