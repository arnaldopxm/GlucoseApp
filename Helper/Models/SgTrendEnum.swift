//
//  SgTrendEnum.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 13/1/22.
//

import Foundation

enum SgTrend: String, Codable {
    case NONE
    case DOWN
    case DOWN_DOUBLE
    case DOWN_TRIPLE
    case UP
    case UP_DOUBLE
    case UP_TRIPLE
}

extension SgTrend {
    var icon: String {
        switch self {
        case .DOWN: return "↓"
        case .DOWN_DOUBLE: return "↓↓"
        case .DOWN_TRIPLE: return "↓↓↓"
        case .UP: return "↑"
        case .UP_DOUBLE: return "↑↑"
        case .UP_TRIPLE: return "↑↑↑"
        case .NONE: return ""
        }
    }
}
