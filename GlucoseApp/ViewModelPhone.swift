import Foundation
import WatchConnectivity

class ViewModelPhone : NSObject,  WCSessionDelegate, ObservableObject{
    
    static let singleton = ViewModelPhone()
    
    var sg: String = "SG"
    var sgTime: String = "... fetching ..."
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func update(from data: DataResponse) {
        if data.lastSG.datetime != nil {
            sg = "\(data.lastSG.sg) \(data.lastSGTrend.icon)"
            sgTime = data.lastSG.datetime!
        } else {
            sg = "---"
            sgTime = "No Data"
        }
        send(message: ["SG": sg, "SGTIME":sgTime])
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
