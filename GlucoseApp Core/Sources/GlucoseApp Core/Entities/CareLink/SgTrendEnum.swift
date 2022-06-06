//
//  SgTrendEnum.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 13/1/22.
//

import Foundation

public enum SgTrend: String, Codable, CaseIterable {
    case NONE
    case DOWN
    case DOWN_DOUBLE
    case DOWN_TRIPLE
    case UP
    case UP_DOUBLE
    case UP_TRIPLE
}
