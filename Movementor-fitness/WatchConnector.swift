//
//  WatchConnector.swift
//  Movementor-fitness
//
//  Created by user on 11/12/24.
//

import WatchConnectivity

class WatchConnector:NSObject {
    
    static let shared = WatchConnector()
    
    public let session = WCSession.default
    
    private override init(){
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
}

extension WatchConnector:WCSessionDelegate {
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        } else {
            print("session actibated successfully")
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        dataReceivedFromWatch(userInfo)
    }
    
    // MARK: use this for testing in simulator
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        dataReceivedFromWatch(message)
    }
    
}

// MARK: - send data to watch
extension WatchConnector {
    
    public func sendStepsToWatch(_ steps: Int) {
        if session.isReachable {
            session.sendMessage(["steps": steps], replyHandler: nil) { error in
                print("Error sending steps to watch: \(error.localizedDescription)")
            }
        } else {
            print("Watch is not reachable.")
        }
    }
}

// MARK: - receive data
extension WatchConnector {
    
    public func dataReceivedFromWatch(_ info:[String:Any]) {
        
    }
}

