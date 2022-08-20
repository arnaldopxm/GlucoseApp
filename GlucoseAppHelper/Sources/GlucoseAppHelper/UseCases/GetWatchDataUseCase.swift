//
//  File.swift
//
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftUI
import GlucoseApp_Core

public class GetWatchDataUseCase {
    
    public static let singleton = GetWatchDataUseCase()
    
    private var requestDataUseCase = RequestDataFromiPhone.singleton
    public var appState: AppState? = nil
    private var onNewDataHandleWatch: ((AppState) -> Void)? = nil
    private var onNewDataHandleComplications: ((AppState) -> Void)? = nil


    public func setOnNewDataHandlerWatch(_ handler: ((AppState) -> Void)? = nil) {
        onNewDataHandleWatch = handler
    }
    
    public func setOnNewDataHandlerComplications(_ handler: ((AppState) -> Void)? = nil) {
        onNewDataHandleComplications = handler
    }
    
    public func getLatestData(completion: ((AppState) -> Void)? = nil) {
        requestDataUseCase.keepAlive()
        if appState == nil || !appState!.isValid() {
            requestDataUseCase.request()
        }
        if completion != nil && appState != nil{
            completion!(appState!)
        }
    }
    
    public func updateData(from newState: AppState) {
        
        if (appState == nil){
            appState = newState
        } else {
            appState!.updateNeededFields(from: newState)
        }
        
        if appState != nil {
            if onNewDataHandleWatch != nil {
                onNewDataHandleWatch!(appState!)
            }
            
            if onNewDataHandleComplications != nil {
                onNewDataHandleComplications!(appState!)
            }
            
        }
    }
}
