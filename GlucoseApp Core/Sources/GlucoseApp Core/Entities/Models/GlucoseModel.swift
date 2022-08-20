//
//  GlucoseModel.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public struct GlucoseModel: Codable, Equatable, CustomStringConvertible {
    
    public let value: Int
    
    public init(value: Int) {
        self.value = value
    }
    
    public var description: String {
        return "GS: \(value)"
    }
}
