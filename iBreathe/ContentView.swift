//
//  ContentView.swift
//  iBreathe
//
//  Created by Anurag Pandit on 15/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("📱 iBreathe")
                .font(.title)
            Button("Send to Watch") {
                iPhoneSessionManager.shared.send(message: ["fromiPhone": "Hello Watch ⌚️"])
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
