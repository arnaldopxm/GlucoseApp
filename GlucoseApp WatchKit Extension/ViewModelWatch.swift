
import Foundation
import WatchConnectivity

class ViewModelWatch : NSObject,  WCSessionDelegate, ObservableObject{
    var session: WCSession
    @Published var sg = "SG"
    
    
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
            }
        }
    
}
