//
//  WatchState.swift
//  
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation
import SwiftUI

public class WatchState: ObservableObject {
    
    private var model = WatchStateModel()
    public static let singleton = WatchState()
    
    
    @Published public var sg: String
    @Published public var sgTime: String
    @Published public var sgColor: Color
    @Published public var sgTrend: SgTrend
    
    public init(sg: String = "---", sgTime: String = "", sgTrend: SgTrend = .NONE) {
        self.sg = sg
        self.sgTime = sgTime
        self.sgTrend = sgTrend
        self.sgColor = SensorGlucose.getSgColor(sg: sg)
        
        self.model.sg = sg
        self.model.sgTime = sgTime
        self.model.sgTrend = sgTrend
    }
    
    private func update(sg: String, sgTime: String, sgTrend: SgTrend) {
        self.model.sg = sg
        self.model.sgTime = sgTime
        self.model.sgTrend = sgTrend
        
        DispatchQueue.main.async {
            self.sg = self.model.sg
            self.sgTime = self.model.sgTime
            self.sgTrend = self.model.sgTrend
            self.sgColor = SensorGlucose.getSgColor(sg: self.model.sg)
        }
    }
    
   public func update(from state: WatchState) {
       update(sg: state.sg, sgTime: state.sgTime, sgTrend: state.sgTrend)
   }
    
    private func update(from state: WatchStateModel) {
        update(sg: state.sg, sgTime: state.sgTime, sgTrend: state.sgTrend)
    }
    
    public func updateFromStateModelString(from json: String) {
        guard
            let model = WatchStateModel.parseFrom(jsonString: json)
        else {
            return
        }
        self.update(from: model)
    }
}
