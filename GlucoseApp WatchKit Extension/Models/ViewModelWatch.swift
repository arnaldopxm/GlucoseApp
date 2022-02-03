
import Foundation
import WatchConnectivity
import ClockKit
import GlucoseAppHelper

class ViewModelWatch : NSObject,  WCSessionDelegate, ObservableObject{
    
    static let singleton = ViewModelWatch()

    var session: WCSession
    @Published var state: WatchState = WatchState.singleton
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        print("Activate session")
        session.activate()
        print("ViewModelWatch: Request current data")
        self.send(message: ["CURRENT-DATA":true])
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.process(message: message)
        }
    }
    
    func process(message: [String : Any]) {
        if let message = message[MessagesPayloadKeysConst.SEND_INFO_PHONE_2_WATCH] as? String {
            state.updateFromStateModelString(from: message)
        }
        print("ViewModelWatch: new data received")
        let complications = CLKComplicationServer.sharedInstance()
        for c in complications.activeComplications! {
            complications.reloadTimeline(for: c)
        }
    }
    
    func send(message: [String:Any], replyHandler: (([String: Any]) -> Void)? = nil) -> Void {
        if session.isReachable {
            session.sendMessage(message, replyHandler: replyHandler) { (error) in
                print(error.localizedDescription)
            }
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        if (session.isReachable) {
            print("ViewModelWatch: Request current data")
            self.send(message: ["CURRENT-DATA":true], replyHandler: self.process)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
            // code
    }
}
