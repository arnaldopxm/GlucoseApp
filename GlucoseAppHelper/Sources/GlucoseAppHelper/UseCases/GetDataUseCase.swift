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
    private var appState: AppState?;
    private var semaphore = DispatchSemaphore(value: 1)
    
    public func getLatestData(completion: ((AppState) -> Void)? = nil) {
        if let data = appState, data.isValid() {
            if (completion != nil) {
                completion!(data)
            }
            return
        } else {
            semaphore.wait()
            if appState == nil || !appState!.isValid() {
                getNewData() { newData in
                    self.semaphore.signal()
                    let sendDataToWatch = SendDataToWatch.singleton
                    sendDataToWatch.send(newData)
                    if (completion != nil) {
                        completion!(newData)
                    }
                }
            } else {
                semaphore.signal()
                if (completion != nil) {
                    completion!(appState!)
                }
            }
        }
    }
    
    private func getNewData(completion: ((AppState) -> Void)? = nil) {
        Task.init {
            let data = try await carelink.getLastSensorGlucose()
            
            let newGs = GlucoseModel(value: data.lastSG.sg)
            let newGsTrend = GlucoseTrendModel(trend: data.lastSGTrend)
            let newGsTime = GlucoseTimeModel(dateTime: data.lastSG.datetime)

            let newState = AppState(gs: newGs, gsTrend: newGsTrend, gsTime: newGsTime)
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
