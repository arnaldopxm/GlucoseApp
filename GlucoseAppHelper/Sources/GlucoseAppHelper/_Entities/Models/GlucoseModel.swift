//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftUI

public struct GlucoseModel {
    
    public let value: Int
    
    public init(value: Int) {
        self.value = value
    }
    
    public func Equals(_ obj: GlucoseModel) -> Bool {
        return obj.value == value
    }
    
    public func getColor() -> Color {
        if (value > 180) {
            return ColorsConst.SG_HIGH
        }
        if (value < 70) {
            return ColorsConst.SG_LOW
        }
        return ColorsConst.SG_OK
    }
}
