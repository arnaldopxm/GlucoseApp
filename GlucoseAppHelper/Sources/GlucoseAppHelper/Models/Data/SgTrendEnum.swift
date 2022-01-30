//
//  SgTrendEnum.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 13/1/22.
//

import Foundation
import SwiftUI

public enum SgTrend: String, Codable {
    case NONE
    case DOWN
    case DOWN_DOUBLE
    case DOWN_TRIPLE
    case UP
    case UP_DOUBLE
    case UP_TRIPLE
}

public extension SgTrend {
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


public extension SgTrend {
    var stacked_icons: some View {
        switch self {
        case .DOWN: return AnyView(VStack{ Image(systemName:"chevron.down") })
        case .DOWN_DOUBLE: return AnyView(VStack{
            Image(systemName:"chevron.down")
            Image(systemName:"chevron.down")
        })
        case .DOWN_TRIPLE: return AnyView(VStack{
            Image(systemName:"chevron.down")
            Image(systemName:"chevron.down")
            Image(systemName:"chevron.down")
        })
        case .UP: return AnyView(VStack{ Image(systemName:"chevron.up") })
        case .UP_DOUBLE: return AnyView(VStack{
            Image(systemName:"chevron.up")
            Image(systemName:"chevron.up")
        })
        case .UP_TRIPLE: return AnyView(VStack{
            Image(systemName:"chevron.up")
            Image(systemName:"chevron.up")
            Image(systemName:"chevron.up")
        })
        case .NONE: return AnyView(VStack{})
        }
    }
}
