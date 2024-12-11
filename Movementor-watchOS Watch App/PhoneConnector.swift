//
//  PhoneConnector.swift
//  Movementor-fitness
//
//  Created by user on 11/12/24.
//

import WatchConnectivity

class PhoneConnector:NSObject, ObservableObject {
    
    static let shared = PhoneConnector()
    @Published var steps: Int = 0
    
    public let session = WCSession.default
    
    var progressReceivedFromPhone: ((CGFloat) -> ())?
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
}

extension PhoneConnector:WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        dataReceivedFromPhone(userInfo)
    }
    
    // MARK: use this for testing in simulator
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let receivedSteps = message["steps"] as? Int {
            DispatchQueue.main.async {
                self.steps = receivedSteps // Update the observable steps
            }
        }
    }
}


// MARK: - send data to phone
extension PhoneConnector {
    
    //    public func sendDataToPhone(data: [String: Any]) {
    //        guard session.isReachable else {
    //            print("Phone is not reachable.")
    //            return
    //        }
    //
    //        session.sendMessage(data, replyHandler: nil) { error in
    //            print("Failed to send message: \(error.localizedDescription)")
    //        }
    //    }
    //
    public func sendStepsToWatch(_ steps: Int) {
        if session.isReachable {
            session.sendMessage(["steps": steps], replyHandler: nil) { error in
                print("Error sending steps to watch: \(error.localizedDescription)")
            }
        } else {
            print("Watch is not reachable.")
        }
    }
    
    //    public func sendUserInfoToPhone(data: [String: Any]) {
    //        session.transferUserInfo(data)
    //    }
}

// MARK: - receive data
extension PhoneConnector {
    
    public func dataReceivedFromPhone(_ info: [String: Any]) {
        if let steps = info["steps"] as? Int {
            print("Steps received: \(steps)")
        }
    }
}

