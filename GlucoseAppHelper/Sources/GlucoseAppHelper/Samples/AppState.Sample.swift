//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 29/1/22.
//

import Foundation
import SwiftUI
import GlucoseApp_Core

extension AppState {

    public static let samples = [
        sample_ok_up,
        sample_ok_down,
        sample_high_up,
        sample_high_down,
        sample_low_up,
        sample_low_down
    ]
    
    public static let sample_ok_notrend = AppState(.sample_ok_notrend, WatchStatusConst.CONNECTED)
    public static let sample_ok_up = AppState(.sample_ok_up, WatchStatusConst.NOT_INSTALLED)
    public static let sample_ok_down = AppState(.sample_ok_down, WatchStatusConst.DISCONNECTED)
    public static let sample_high_notrend = AppState(.sample_high_notrend, WatchStatusConst.CONNECTED)
    public static let sample_high_up = AppState(.sample_high_up, WatchStatusConst.DISCONNECTED)
    public static let sample_high_down = AppState(.sample_high_down, WatchStatusConst.NOT_INSTALLED)
    public static let sample_low_notrend = AppState(.sample_low_notrend, WatchStatusConst.CONNECTED)
    public static let sample_low_up = AppState(.sample_low_up, WatchStatusConst.DISCONNECTED)
    public static let sample_low_down = AppState(.sample_low_down, WatchStatusConst.NOT_INSTALLED)
 
    convenience init(_ data: DataResponse, _ watchStatus: (String, Color)? = nil) {
        let newGs = GlucoseModel(value: data.lastSG.sg)
        let newGsTrend = GlucoseTrendModel(trend: data.lastSGTrend)
        let newGsTime = GlucoseTimeModel(dateTime: data.lastSG.datetime)
        self.init(gs: newGs, gsTrend: newGsTrend, gsTime: newGsTime)
    }
}

extension DataResponse {
    static let sample_ok_notrend = DataResponse(lastSG: .sample_ok, lastSGTrend: .NONE)
    static let sample_ok_up = DataResponse(lastSG: .sample_ok, lastSGTrend: .UP)
    static let sample_ok_down = DataResponse(lastSG: .sample_ok, lastSGTrend: .DOWN)
    static let sample_high_notrend = DataResponse(lastSG: .sample_high, lastSGTrend: .NONE)
    static let sample_high_up = DataResponse(lastSG: .sample_high, lastSGTrend: .UP_DOUBLE)
    static let sample_high_down = DataResponse(lastSG: .sample_high, lastSGTrend: .DOWN_DOUBLE)
    static let sample_low_notrend = DataResponse(lastSG: .sample_low, lastSGTrend: .NONE)
    static let sample_low_up = DataResponse(lastSG: .sample_low, lastSGTrend: .UP_TRIPLE)
    static let sample_low_down = DataResponse(lastSG: .sample_low, lastSGTrend: .DOWN_TRIPLE)
}

extension SensorGlucose {
    private static let interval = Double(Int.random(in: 0...5)) * -60.0
    private static let date = Date.now.addingTimeInterval(interval)
    private static let dateString = DateTimeService.dateToString(date: date, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")

    static let sample_ok = SensorGlucose(sg: 120, datetime: dateString)
    static let sample_high = SensorGlucose(sg: 300, datetime: dateString)
    static let sample_low = SensorGlucose(sg: 60, datetime: dateString)
}
