//
//  File.swift
//
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftUI

public class GetWatchDataUseCase {
    
    public static let singleton = GetWatchDataUseCase()
    
    private var requestDataUseCase = RequestDataFromiPhone.singleton
    private var appState: _WatchState? = nil
    private var onNewDataHandle: ((_WatchState) -> Void)? = nil

    public func setOnNewDataHandler(_ handler: ((_WatchState) -> Void)? = nil) {
        onNewDataHandle = handler
    }
    
    public func getLatestData(completion: ((_WatchState) -> Void)? = nil) {
        if appState == nil || appState!.isValid() {
            requestDataUseCase.request()
        }
        if completion != nil && appState != nil{
            completion!(appState!)
        }
    }
    
    public func updateData(from newState: _WatchState) {
        if (appState == nil){
            appState = newState
        } else {
            appState!.updateNeededFields(from: newState)
        }
        
        if onNewDataHandle != nil && appState != nil {
            onNewDataHandle!(appState!)
        }
    }
}
