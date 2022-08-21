//
//  ContentViewSamples.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 21/8/22.
//

import Foundation
import GlucoseApp_Core

extension ContentViewPresenter {
    
    convenience init(_ newState: AppState) {
        self.init()
        setSampleData(newState)
    }
    
    static let sample_ok_notrend = ContentViewPresenter(.sample_ok_notrend)
    static let sample_ok_up = ContentViewPresenter(.sample_ok_up)
    static let sample_ok_down = ContentViewPresenter(.sample_ok_down)
    static let sample_high_notrend = ContentViewPresenter(.sample_high_notrend)
    static let sample_high_up = ContentViewPresenter(.sample_high_up)
    static let sample_high_down = ContentViewPresenter(.sample_high_down)
    static let sample_low_notrend = ContentViewPresenter(.sample_low_notrend)
    static let sample_low_up = ContentViewPresenter(.sample_low_up)
    static let sample_low_down = ContentViewPresenter(.sample_low_down)
    
    func setSampleData(_ newState: AppState) {
        DispatchQueue.main.async {
            if (newState.gs.value == 0) {
                self.sgValue = "---"
                self.sgTime = newState.sensorState ?? "NO_DATA"
            } else {
                self.sgValue = newState.gs.value.formatted()
                self.sgTime = newState.gsTime.getFormattedHourTime()
            }
            self.sgColor = newState.gs.getColor()
            self.sgTrend = newState.gsTrend
            self.sgTimeOffset = newState.gsTime.getPastTimeSinceNowString()
            
        }
    }
}
