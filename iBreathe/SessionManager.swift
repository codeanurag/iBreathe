//
//  SessionManager.swift
//  iBreathe
//
//  Created by Anurag Pandit on 15/07/25.
//


import WatchConnectivity

class SessionManager: NSObject, WCSessionDelegate, ObservableObject {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    static let shared = SessionManager()
    var session: WCSession? = WCSession.isSupported() ? WCSession.default : nil

    func setup() {
        session?.delegate = self
        session?.activate()
    }

    // Add delegate methods as needed
}
