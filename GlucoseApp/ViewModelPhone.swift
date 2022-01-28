import Foundation
import WatchConnectivity
import GlucoseAppHelper

class ViewModelPhone : NSObject,  WCSessionDelegate{
    
    static let singleton = ViewModelPhone()
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func update(from data: DataResponse) {
        AppState.singleton.update(from: data)
        send(message: ["SG": AppState.singleton.sg, "SGTIME":AppState.singleton.sgTime])
    }
    
    func send(message: [String:Any]) -> Void {
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // code
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if (message["REQUEST"]) != nil && message["REQUEST"] as! Bool == true {
                CareLinkClient.singleton.findLastGlucoseTaskSync(updateHandler: ViewModelPhone.singleton.update)
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // code
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // code
    }
    
    
}
