//
//  SessionHistoryView.swift
//  iBreathe
//
//  Created by Anurag Pandit on 16/07/25.
//


import SwiftUI

struct SessionHistoryView: View {
    @State private var logs: [SessionLog] = []

    var body: some View {
        NavigationStack {
            List(logs) { log in
                VStack(alignment: .leading, spacing: 4) {
                    Text("🕒 \(log.duration)-minute session")
                        .font(.headline)

                    Text(log.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Session History")
            .onAppear {
                logs = loadLogs()
            }
        }
    }

    private func loadLogs() -> [SessionLog] {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("received_logs.json")

        guard let url = fileURL,
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([SessionLog].self, from: data)
        else {
            return []
        }

        return decoded
    }
}
