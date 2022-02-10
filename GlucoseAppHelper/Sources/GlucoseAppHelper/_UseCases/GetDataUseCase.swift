//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

class GetDataUseCase {
    
    public static let singleton = GetDataUseCase()
    private let carelink: ICareLinkController = CareLinkController.singleton
    private var appState: _WatchState?;
    
    public func getLatestData(completion: ((_WatchState) -> Void)? = nil) {
        if let data = appState, data.isValid() {
            if (completion != nil) {
                completion!(data)
            }
            return
        } else {
            getNewData(completion: completion)
        }
    }
    
    private func getNewData(completion: ((_WatchState) -> Void)? = nil) {
        Task.init {
            let data = try await carelink.getLastSensorGlucose()
            
            let newGs = GlucoseModel(value: data.lastSG.sg)
            let newGsTrend = GlucoseTrendModel(trend: data.lastSGTrend)
            let newGsTime = GlucoseTimeModel(dateTime: data.lastSG.datetime)

            let newState = _WatchState(gs: newGs, gsTrend: newGsTrend, gsTime: newGsTime)
            if (appState == nil){
                appState = newState
            } else {
                appState?.updateNeededFields(from: newState)
            }
            
            if (completion != nil) {
                completion!(self.appState!)
            }
        }
        
    }
    
}
