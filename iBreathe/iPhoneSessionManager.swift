//
//  iPhoneSessionManager.swift
//  iBreathe
//
//  Created by Anurag Pandit on 16/07/25.
//


import Foundation
import WatchConnectivity

class iPhoneSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = iPhoneSessionManager()

    override private init() {
        super.init()
        activateSession()
    }

    private func activateSession() {
        guard WCSession.isSupported() else {
            print("❌ WatchConnectivity not supported on iPhone")
            return
        }

        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    // MARK: - WCSessionDelegate

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("📴 iPhone session became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("🔁 iPhone session deactivated. Re-activating...")
        session.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("📱 iPhone session activated with state: \(activationState.rawValue)")
        if let error = error {
            print("⚠️ iPhone session activation error: \(error.localizedDescription)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            print("📩 Received message from Watch: \(message)")
            // You can handle incoming watch data here
        }
    }

    // Optional: Send message to Watch
    func send(message: [String: Any]) {
        guard WCSession.default.isReachable else {
            print("📵 Watch not reachable")
            return
        }

        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
            print("❌ Error sending message to Watch: \(error.localizedDescription)")
        })
    }
}
