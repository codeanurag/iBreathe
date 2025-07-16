//
//  ContentView.swift
//  iBreathe
//
//  Created by Anurag Pandit on 15/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("📲 iBreathe iPhone")
                    .font(.title)
                
                NavigationLink("View Synced Logs") {
                    SessionHistoryView()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ContentView()
}
