//
//  ComplicationsPresenter.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 13/2/22.
//

import Foundation
import GlucoseAppHelper
import ClockKit
import GlucoseApp_Core

public class ComplicationsPresenter {
    
    public static let singleton = ComplicationsPresenter()
    
    private let getWatchData = GetWatchDataUseCase.singleton

    public var sgValue: String = "---"
    public var sgTimeOffset: String = "Hace X min."
    
    init() {
        getWatchData.setOnNewDataHandlerComplications(self.updateData)
    }
    
    func reloadComplications() {
        let complications = CLKComplicationServer.sharedInstance()
        if (complications.activeComplications != nil) {
            for c in complications.activeComplications! {
                complications.reloadTimeline(for: c)
            }
        }
    }
    
    func updateData(from newState: AppState) {
        if (newState.gs.value == 0) {
            self.sgValue = newState.sensorState ?? "---"
        } else {
            self.sgValue = newState.gs.value.formatted() + newState.gsTrend.getArrows()
        }
        self.sgTimeOffset = newState.gsTime.getPastTimeSinceNowString()
        reloadComplications()
    }
    
    func updateTime(from newTime: String) {
        self.sgTimeOffset = newTime
        reloadComplications()
    }
}
