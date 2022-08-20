//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftUI
import GlucoseApp_Core

public class GetiPhoneDataUseCase {
    
    public static let singleton = GetiPhoneDataUseCase()
    private let dataUseCase = GetDataUseCase.singleton
    
    public func getLatestData(completion: ((AppState) -> Void)? = nil) {
        dataUseCase.getLatestData(completion: completion)
    }
    
    #if os(iOS)
    public func getCurrentWatchStatus() -> (String, Color) {
        let iOSSession = iOSSessionController.singleton
        return iOSSession.getWatchStatus
    }
    #endif
}
