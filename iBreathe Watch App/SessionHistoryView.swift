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
        List(logs) { log in
            VStack(alignment: .leading, spacing: 4) {
                Text("🕒 \(log.duration)-min session")
                    .font(.headline)

                Text(log.timestamp.formatted(.dateTime.hour().minute().day().month().year()))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("History")
        .onAppear {
            logs = SessionLogger.loadLogs()
        }
    }
}
