//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 10/2/22.
//

import Foundation
import GlucoseApp_Core

public class ReceiveDataFromiPhoneUseCase {
    
    public static let singleton = ReceiveDataFromiPhoneUseCase()
    
    public func receiveData(_ data: String) {
        guard let newState = AppState.parseFrom(jsonString: data)  else{
            print("Watch: no new data")
            return
        }
        
        let watchData = GetWatchDataUseCase.singleton
        watchData.updateData(from: newState)
    }
}
