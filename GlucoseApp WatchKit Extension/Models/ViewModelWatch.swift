
import Foundation
import WatchConnectivity
import ClockKit

class ViewModelWatch : NSObject,  WCSessionDelegate, ObservableObject{
    
    static let singleton = ViewModelWatch()

    var session: WCSession
    @Published var sg = "---"
    @Published var sgTime = ""
    @Published var nextUpdateTime = ""
    
    var sgString: String {
        return "\(sg) - \(sgTime)"
    }
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        print("Activate session")
        session.activate()
        print("ViewModelWatch: Request current data")
        self.send(message: ["CURRENT-DATA":true])
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            //request user/pass from app. then fetch backgorund jobs to update data straight from the watch
            self.process(message: message)
        }
    }
    
    func process(message: [String : Any]) {
        self.sg = message["SG"] as? String ?? self.sg
        self.sgTime = message["SGTIME"] as? String ?? self.sgTime
        print("ViewModelWatch: new data received")
        let complications = CLKComplicationServer.sharedInstance()
        for c in complications.activeComplications! {
            complications.reloadTimeline(for: c)
        }
    }
    
    func send(message: [String:Any]) -> Void {
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        if (session.isReachable) {
            print("ViewModelWatch: Request current data")
            self.send(message: ["CURRENT-DATA":true])
        }
    }
}
