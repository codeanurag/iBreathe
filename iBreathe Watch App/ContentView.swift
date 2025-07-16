//
//  ContentView.swift
//  iBreathe Watch App
//
//  Created by Anurag Pandit on 15/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("⌚️ iBreathe")
                .font(.headline)
            Button("Send to iPhone") {
                WatchSessionManager.shared.send(message: ["fromWatch": "Hello iPhone 👋"])
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
