//
//  ContentView.swift
//  iBreathe Watch App
//
//  Created by Anurag Pandit on 15/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var navigateToSession = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("🧘‍♀️ iBreathe")
                    .font(.title3)
                
                Button("Start Session") {
                    self.navigateToSession.toggle()
                }
                .navigationDestination(isPresented: $navigateToSession) {
                    BreatheSessionView()
                }
#if !targetEnvironment(simulator)
                Text("⌚️ iBreathe")
                    .font(.headline)
                Button("Send to iPhone") {
                    WatchSessionManager.shared.send(message: ["fromWatch": "Hello iPhone 👋"])
                }
#endif
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
