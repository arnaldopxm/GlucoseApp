
import Foundation
import WatchConnectivity
import ClockKit

class ViewModelWatch : NSObject,  WCSessionDelegate, ObservableObject{
    
    static let singleton = ViewModelWatch()

    var session: WCSession
    @Published var sg = "---"
    @Published var sgTime = ""
    
    var sgString: String {
        return "\(sg) - \(sgTime)"
    }
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            //request user/pass from app. then fetch backgorund jobs to update data straight from the watch
            self.sg = message["SG"] as? String ?? self.sg
            self.sgTime = message["SGTIME"] as? String ?? self.sgTime
            let complications = CLKComplicationServer.sharedInstance()
            for c in complications.activeComplications! {
                complications.reloadTimeline(for: c)
            }
        }
    }
}
