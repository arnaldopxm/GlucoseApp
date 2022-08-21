//
//  ContentViewPresenter.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import GlucoseAppHelper
import SwiftUI
import GlucoseApp_Core

public class ContentViewPresenter: ObservableObject {
    
    public static let singleton = ContentViewPresenter()
    private let getiPhoneDataUseCase = GetiPhoneDataUseCase.singleton
    private let providersPresenter = ProvidersPresenter.singleton
    private let mainApp = GlucoseAppPresenter.singleton
    
    @Published public var sgValue: String = "---"
    @Published public var sgColor: Color = ColorsConst.SG_HIGH
    @Published public var sgTime: String = "---"
    @Published public var sgTimeOffset: String = "Hace X min."
    @Published public var sgTrend: GlucoseTrendModel = GlucoseTrendModel(trend: .NONE)

    //review
    @Published public var watchStatus: (String, Color) = WatchStatusConst.NOT_INSTALLED

    func getData() {
        getiPhoneDataUseCase.getLatestData() { newState in
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
                self.watchStatus = self.getiPhoneDataUseCase.getCurrentWatchStatus()
                
            }
        }
    }
}
