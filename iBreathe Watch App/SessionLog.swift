//
//  SessionLog.swift
//  iBreathe
//
//  Created by Anurag Pandit on 16/07/25.
//


import Foundation

struct SessionLog: Identifiable, Codable {
    let id: UUID
    let duration: Int // minutes
    let timestamp: Date
}

class SessionLogger {
    private static let filename = "session_logs.json"

    // MARK: - Save New Log
    static func saveLog(duration: Int) {
        var logs = loadLogs()
        let newLog = SessionLog(id: UUID(), duration: duration, timestamp: Date())
        logs.insert(newLog, at: 0) // latest first
        saveAll(logs)
    }

    // MARK: - Load All Logs
    static func loadLogs() -> [SessionLog] {
        guard let url = getFileURL(),
              let data = try? Data(contentsOf: url),
              let logs = try? JSONDecoder().decode([SessionLog].self, from: data) else {
            return []
        }
        return logs
    }

    // MARK: - Private Helpers
    private static func saveAll(_ logs: [SessionLog]) {
        guard let url = getFileURL(),
              let data = try? JSONEncoder().encode(logs) else {
            print("❌ Failed to encode or find file URL")
            return
        }

        do {
            try data.write(to: url)
        } catch {
            print("❌ Failed to write logs: \(error)")
        }
    }

    private static func getFileURL() -> URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(filename)
    }
}
