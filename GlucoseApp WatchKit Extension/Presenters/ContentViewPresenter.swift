//
//  ContentViewPresenter.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 10/2/22.
//

import Foundation
import SwiftUI
import GlucoseAppHelper
import ClockKit

public class ContentViewPresenter: ObservableObject {
    
    public static let singleton = ContentViewPresenter()
    private let getWatchData = GetWatchDataUseCase.singleton
    
    @Published public var sgValue: String = "---"
    @Published public var sgColor: Color = ColorsConst.SG_HIGH
    @Published public var sgTime: String = "---"
    @Published public var sgTimeOffset: String = "Hace X min."
    @Published public var sgTrend: GlucoseTrendModel = GlucoseTrendModel(trend: .NONE)
    
    init() {
        getWatchData.setOnNewDataHandler(self.updateData)
    }
    
    func getData() {
        getWatchData.getLatestData() { newState in
            self.updateData(from: newState)
        }
    }
    
    func updateData(from newState: AppState) {
        DispatchQueue.main.async {
            self.sgValue = newState.gs.value.formatted()
            self.sgColor = newState.gs.getColor()
            self.sgTrend = newState.gsTrend
            self.sgTime = newState.gsTime.getFormattedHourTime()
            self.sgTimeOffset = newState.gsTime.getPastTimeSinceNowString()
            self.updateComplications()
        }
    }
    
    func updateComplications() {
        let complications = CLKComplicationServer.sharedInstance()
        if (complications.activeComplications != nil) {
            for c in complications.activeComplications! {
                complications.reloadTimeline(for: c)
            }
        }
    }
}
