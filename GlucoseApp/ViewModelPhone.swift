import Foundation
import WatchConnectivity
import GlucoseAppHelper
import SwiftUI

class ViewModelPhone : NSObject,  WCSessionDelegate{
    
    static let singleton = ViewModelPhone()
    private let state = AppState.singleton
    private let session: WCSession
    
    public var currentSession {
        return session
    }
    
    public func updateWatchStatus() {
        if session.isWatchAppInstalled {
            if session.isReachable {
                state.setWatchStatus(statusColorPair: WatchStatusModel.CONNECTED)
            } else {
                state.setWatchStatus(statusColorPair: WatchStatusModel.DISCONNECTED)
            }
        }
        state.setWatchStatus(statusColorPair: WatchStatusModel.NOT_INSTALLED)
    }
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    private func sendCurrentData() {
        send([
            MessagesPayloadKeysConst.SEND_INFO_PHONE_2_WATCH: state.getWatchState().getStringSerialized()
        ])
    }
    
    func update(from data: DataResponse) {
        print("ViewModelPhone: Updating data")
        if AppState.singleton.update(from: data) {
            print("ViewModelPhone: new data, sending to Watch")
            sendCurrentData()
        }
    }
    
    func send(_ message: [String:Any]) -> Void {
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            if (message["REQUEST"]) != nil && message["REQUEST"] as! Bool == true {
                print("ViewModelPhone: Message received, Reload Data")
                CareLinkClient.singleton.findLastGlucoseTaskSync(updateHandler: ViewModelPhone.singleton.update)
            }
            if (message["CURRENT-DATA"]) != nil && message["REQUEST"] as! Bool == true {
                print("ViewModelPhone: Message received, Send Current Data")
                let response = [
                    MessagesPayloadKeysConst.SEND_INFO_PHONE_2_WATCH: self.state.getWatchState().getStringSerialized()
                ]
                replyHandler(response)
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        self.updateWatchStatus()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        self.updateWatchStatus()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        self.updateWatchStatus()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        self.updateWatchStatus()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        self.updateWatchStatus()
    }
    
}
