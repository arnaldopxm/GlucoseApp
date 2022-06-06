//
//  File.swift
//
//
//  Created by Arnaldo Quintero on 10/2/22.
//

import Foundation
import GlucoseApp_Core

class SendDataToWatch {

    public static let singleton = SendDataToWatch()

    public func send(_ data: AppState) {
        let stringData = data.getStringSerialized()
        let session: IiOSSessionController = iOSSessionController.singleton
        let payload = [
            MessagesPayloadKeysEnum.SEND_INFO_PHONE_2_WATCH.rawValue: stringData
        ]
        session.send(payload)
    }

}
