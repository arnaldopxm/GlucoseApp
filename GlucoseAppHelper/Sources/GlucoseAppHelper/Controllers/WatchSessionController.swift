//
//  iOSSessionController.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 10/2/22.
//

import Foundation
import WatchConnectivity
import SwiftUI

public class WatchSessionController: NSObject, WCSessionDelegate, IWatchSessionController {
    
    public static let singleton: IWatchSessionController = WatchSessionController()
    
    private let session: WCSession
    private let receiveDataUseCase: ReceiveDataFromiPhoneUseCase = ReceiveDataFromiPhoneUseCase.singleton
    
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
        if let payload = extractValueFromMessage(from: message, key: .SEND_INFO_PHONE_2_WATCH) as? String{
            receiveDataUseCase.receiveData(payload)
        }
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext message: [String : Any]) {
        if let payload = extractValueFromMessage(from: message, key: .SEND_INFO_PHONE_2_WATCH) as? String{
            receiveDataUseCase.receiveData(payload)
        }
    }
    
    public func send(_ message: [String: Any]) {
//        if session.isPaired {
            session.sendMessage(message, replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
//        }
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    
    private func extractValueFromMessage(from message: [String : Any], key: MessagesPayloadKeysEnum) -> Any? {
        if let payload = message[key.rawValue] {
            return payload
        }
        return nil
    }
    
    public func sessionReachabilityDidChange(_ session: WCSession) {
        if (session.isReachable) {
            //            TOFIX`
            //            print("ViewModelWatch: Request current data")
            //            self.send(message: ["CURRENT-DATA":true], replyHandler: self.process)
        }
    }
    
#if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //    code
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        //    code
    }
#endif
}
