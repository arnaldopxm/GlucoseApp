//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftUI
public struct GlucoseTrendModel: Codable, Equatable, CustomStringConvertible {
    
    internal let _value: SgTrend
    
    public var value: String {
        return _value.rawValue
    }
    
    public init(trend: SgTrend) {
        self._value = trend
    }
    
    public func getArrows() -> String {
        switch _value {
        case .DOWN: return "↓"
        case .DOWN_DOUBLE: return "↓↓"
        case .DOWN_TRIPLE: return "↓↓↓"
        case .UP: return "↑"
        case .UP_DOUBLE: return "↑↑"
        case .UP_TRIPLE: return "↑↑↑"
        case .NONE: return ""
        }
    }
    
    public var description: String {
        return "Trend: \(value)"
    }
}
