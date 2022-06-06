//
//  GetDataUseCase.swift
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import GlucoseApp_Core

class GetDataUseCase {
    
    public static let singleton = GetDataUseCase()
    private let carelink: ICareLinkController = CareLinkController.singleton
    private var appState: AppState?
    private var semaphore = DispatchSemaphore(value: 1)
    
    public func getLatestData(completion: ((AppState) -> Void)? = nil) {
        if let data = appState, data.isValid() {
            self.handleCompletion(completion)
            return
        } else {
            semaphore.wait()
            if appState == nil || !appState!.isValid() {
                getNewData() { newData in
                    self.semaphore.signal()
                    let sendDataToWatch = SendDataToWatch.singleton
                    sendDataToWatch.send(newData)
                    self.handleCompletion(completion)
                }
            } else {
                semaphore.signal()
                self.handleCompletion(completion)
            }
        }
    }
    
    private func getNewData(completion: ((AppState) -> Void)? = nil) {
        Task.init {
            #if DEBUG
            if CommandLine.arguments.contains(TestingConst.TESTING_FLAG) {
                let randomIndex = Int.random(in: 0...AppState.samples.count-1)
                let newState = AppState.samples[randomIndex]
                
                if (appState == nil) { appState = newState }
                else { appState?.updateNeededFields(from: newState) }
                self.handleCompletion(completion)
                return
            }
            #endif

            let data = try await carelink.getLastSensorGlucose()
            let newGs = GlucoseModel(value: data.lastSG.sg)
            let newGsTrend = GlucoseTrendModel(trend: data.lastSGTrend)
            let newGsTime = GlucoseTimeModel(dateTime: data.lastSG.datetime)
            let newSensorState = data.lastSG.sensorState
            let newState = AppState(gs: newGs, gsTrend: newGsTrend, gsTime: newGsTime, sensorState: newSensorState)

            if (appState == nil){ appState = newState }
            else { appState?.updateNeededFields(from: newState) }
            self.handleCompletion(completion)
        }
    }
    
    private func handleCompletion(_ completion: ((AppState) -> Void)?) {
        if (completion != nil) { completion!(self.appState!) }
    }
}
