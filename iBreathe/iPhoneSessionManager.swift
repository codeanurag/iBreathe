//
//  iPhoneSessionManager.swift
//  iBreathe
//
//  Created by Anurag Pandit on 16/07/25.
//


import Foundation
import WatchConnectivity
import HealthKit

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
        switch activationState {
        case .notActivated:
            print("❌ 📱 iPhone Session not activated")
        case .inactive:
            print("🔄 📱 iPhone Session inactive")
        case .activated:
            print("✅ 📱 iPhone Session activated and ready")
        @unknown default:
            print("📩 Received unknown 📱 iPhone activation state \(activationState.rawValue)")
        }
        if let error = error {
            print("⚠️ 📱 iPhone session Activation error: \(error.localizedDescription)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["logs"] as? Data {
            do {
                let logs = try JSONDecoder().decode([SessionLog].self, from: data)
                saveLogsToPhone(logs)
            } catch {
                print("❌ Failed to decode logs from watch: \(error)")
            }
        }
    }

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
private
extension iPhoneSessionManager {
    func saveLogsToPhone(_ logs: [SessionLog]) {
        let url = getLogFileURL()
        do {
            let data = try JSONEncoder().encode(logs)
            try data.write(to: url)
            print("✅ Logs saved to iPhone file")
            // 🧠 Save to HealthKit
            logs.forEach { log in
                let start = log.timestamp
                let end = Calendar.current.date(byAdding: .minute, value: log.duration, to: start)!
                HealthKitManager.shared.saveMindfulnessSession(start: start, end: end)
            }
        } catch {
            print("❌ Failed to save logs to file: \(error)")
        }
    }
    func getLogFileURL() -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("received_logs.json")
    }
}
