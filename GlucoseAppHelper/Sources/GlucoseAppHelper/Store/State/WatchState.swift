//
//  WatchState.swift
//  
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation
import SwiftUI

public class WatchState: ObservableObject {
    
    public static let singleton = AppState.singleton.getWatchState()
    
    public init(sg: String, sgTime: String, sgTrend: SgTrend) {
        self.sg = sg
        self.sgTime = sgTime
        self.sgColor = SensorGlucose.getSgColor(sg: sg)
        self.sgTrend = sgTrend
    }
    
    convenience init(appState state: AppState) {
        self.init(
            sg: state.sg,
            sgTime: state.lastSG?.datetime ?? "",
            sgTrend: state.sgTrend
        )
    }
    
    public func update(from state: WatchState) {
        DispatchQueue.main.async {
            self.sg = state.sg
            self.sgTime = state.sgTime
            self.sgColor = SensorGlucose.getSgColor(sg: state.sg)
            self.sgTrend = state.sgTrend
        }
    }
    
    func update(from state: WatchStateModel) {
        DispatchQueue.main.async {
            self.sg = state.sg
            self.sgTime = state.sgTime
            self.sgColor = SensorGlucose.getSgColor(sg: state.sg)
            self.sgTrend = state.sgTrend
        }
    }
    
    public func update(from json: String) {
        guard
            let jsonData = json.data(using: .utf8),
            let json = try? JSONDecoder().decode(WatchStateModel.self, from: jsonData)
        else {
            return
        }
        self.update(from: json)
    }
    
    @Published public var sg: String
    @Published public var sgTime: String
    @Published public var sgColor: Color
    @Published public var sgTrend: SgTrend
    
    private func getStateModel() -> WatchStateModel {
        return WatchStateModel(from: self)
    }
    
    public func getStringSerialized() -> String {
        guard
            let jsonData = try? JSONEncoder().encode(self.getStateModel()),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return ""
        }
        return jsonString
    }
}
