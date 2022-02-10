//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 10/2/22.
//

import Foundation

public class RequestSendDataToWatch {
    
    public static let singleton = RequestSendDataToWatch()
    private let getData = GetDataUseCase.singleton
    private let sendData = SendDataToWatch.singleton
    
    public func requestSend() {
        getData.getLatestData() { newData in
            self.sendData.send(newData)
        }
    }
    
}
