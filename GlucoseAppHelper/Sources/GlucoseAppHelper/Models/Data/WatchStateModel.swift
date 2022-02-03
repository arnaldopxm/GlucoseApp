//
//  WatchStateModel.swift
//
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation
import SwiftUI

public struct WatchStateModel: Codable {

    init(sg: String, sgTime: String, sgTrend: SgTrend) {
        self.sg = sg
        self.sgTime = sgTime
        self.sgTrend = sgTrend
    }
    
    init(from state: WatchState) {
        self.init(
            sg: state.sg,
            sgTime: state.sgTime,
            sgTrend: state.sgTrend
        )
    }
    
    public var sg: String
    public var sgTime: String
    public var sgTrend: SgTrend
}

