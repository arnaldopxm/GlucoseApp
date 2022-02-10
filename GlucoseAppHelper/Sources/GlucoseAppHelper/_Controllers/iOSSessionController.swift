//
//  iOSSessionController.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 10/2/22.
//

import Foundation
import WatchConnectivity
import SwiftUI

public class iOSSessionController: NSObject, WCSessionDelegate, IiOSSessionController {
    
    public static let singleton = iOSSessionController()
    
    private let session: WCSession
    private let requestSendData: RequestSendDataToWatch = RequestSendDataToWatch.singleton
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        if let _ = extractValueFromMessage(from: message, key: .REQUEST_INFO_WATCH_2_PHONE) {
            requestSendData.requestSend()
        }
    }
    
    public func send(_ message: [String: Any]) {
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    private func extractValueFromMessage(from message: [String : Any], key: MessagesPayloadKeysEnum) -> Any? {
        if let payload = message[key.rawValue] {
            return payload
        }
        return nil
    }
    
#if os(iOS)
    public var getWatchStatus: (String, Color) {
        
        if session.isWatchAppInstalled {
            if session.isReachable {
                return WatchStatusModel.CONNECTED
            } else {
                return WatchStatusModel.DISCONNECTED
            }
        }
        return WatchStatusModel.NOT_INSTALLED
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //        code
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        //        code
    }
#endif
    
}
