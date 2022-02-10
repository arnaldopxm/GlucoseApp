//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 10/2/22.
//

import Foundation

class RequestDataFromiPhone {
    
    public static let singleton = RequestDataFromiPhone()
    
    public func request() {
        let stringData = "request"
        let session = WatchSessionController.singleton
        let payload = [
            MessagesPayloadKeysEnum.REQUEST_INFO_WATCH_2_PHONE.rawValue: stringData
        ]
        session.send(payload)
    }
    
    
}
