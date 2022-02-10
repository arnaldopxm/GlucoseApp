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
    private var appState: AppState? = nil
    private var onNewDataHandle: ((AppState) -> Void)? = nil

    public func setOnNewDataHandler(_ handler: ((AppState) -> Void)? = nil) {
        onNewDataHandle = handler
    }
    
    public func getLatestData(completion: ((AppState) -> Void)? = nil) {
        if appState == nil || appState!.isValid() {
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
        
        if onNewDataHandle != nil && appState != nil {
            onNewDataHandle!(appState!)
        }
    }
}
