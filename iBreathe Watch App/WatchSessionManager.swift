//
//  WatchSessionManager.swift
//  iBreathe
//
//  Created by Anurag Pandit on 16/07/25.
//


import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchSessionManager()

    override private init() {
        super.init()
        activateSession()
    }

    private func activateSession() {
        guard WCSession.isSupported() else {
            print("❌ WatchConnectivity not supported")
            return
        }

        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("🔁 Watch session activated: \(activationState.rawValue)")
        if let error = error {
            print("⚠️ Activation error: \(error.localizedDescription)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            print("📩 Received message from iPhone: \(message)")
        }
    }

    // MARK: - Send message to iPhone
    func send(message: [String: Any]) {
        guard WCSession.default.isReachable else {
            print("📵 iPhone not reachable")
            return
        }

        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("❌ Send error: \(error.localizedDescription)")
        }
    }
}
