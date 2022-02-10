//
//  MessagesPayloadKeys.Const.swift
//  
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation

public struct MessagesPayloadKeysConst {
    public static let SEND_INFO_PHONE_2_WATCH = "Send_Info_Phone_To_Watch"
    public static let REQUEST_INFO_WATCH_2_PHONE = "Send_Info_Watch_To_Phone"
}

public enum MessagesPayloadKeysEnum: String {
    case SEND_INFO_PHONE_2_WATCH
    case REQUEST_INFO_WATCH_2_PHONE
}
