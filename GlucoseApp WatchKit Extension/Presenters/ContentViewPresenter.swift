//
//  ContentViewPresenter.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 10/2/22.
//

import Foundation
import SwiftUI
import GlucoseAppHelper
import GlucoseApp_Core

public class ContentViewPresenter: ObservableObject {
    
    public static let singleton = ContentViewPresenter()
    private let getWatchData = GetWatchDataUseCase.singleton
    private let complications = ComplicationsPresenter.singleton
    
    @Published public var sgValue: String = "---"
    @Published public var sgColor: Color = ColorsConst.SG_HIGH
    @Published public var sgTime: String = "---"
    @Published public var sgTimeOffset: String = "Hace X min."
    @Published public var sgTrend: GlucoseTrendModel = GlucoseTrendModel(trend: .NONE)
    
    init() {
        getWatchData.setOnNewDataHandlerWatch(self.updateData)
    }
    
    func getData() {
        if let newTimeOffset = self.getWatchData.appState?.gsTime.getPastTimeSinceNowString(), self.sgTimeOffset != newTimeOffset {
            self.complications.updateTime(from: newTimeOffset)
            DispatchQueue.main.async {
                self.sgTimeOffset = newTimeOffset
            }
        }
        
        print("Content View Watch: ask for data")
        #if DEBUG
        if CommandLine.arguments.contains(TestingConst.TESTING_FLAG) &&
            CommandLine.arguments.contains(TestingConst.TESTING_FLAG_WATCH_LOGGED_IN) {
            let randomIndex = Int.random(in: 0...AppState.samples.count-1)
            let newState = AppState.samples[randomIndex]
            self.updateData(from: newState)
            return
        }
        #endif
        getWatchData.getLatestData() { newState in
            self.updateData(from: newState)
        }
    }
    
    func updateData(from newState: AppState) {
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
