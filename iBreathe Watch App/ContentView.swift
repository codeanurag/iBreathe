//
//  ContentView.swift
//  iBreathe Watch App
//
//  Created by Anurag Pandit on 15/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var navigateToSession = false
    @State private var selectedDuration: Int = 1
    let durationOptions = [1, 3, 5]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("🧘‍♀️ iBreathe")
                    .font(.title3)
                
                Picker("Duration", selection: $selectedDuration) {
                    ForEach(durationOptions, id: \.self) { value in
                        Text("\(value) min")
                    }
                }
                .pickerStyle(.wheel)
                
                Button("Start \(selectedDuration)-min Session") {
                    self.navigateToSession.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationDestination(isPresented: $navigateToSession) {
                BreatheSessionView(durationInMinutes: selectedDuration)
            }
#if !targetEnvironment(simulator)
            Text("⌚️ iBreathe")
                .font(.headline)
            Button("Send to iPhone") {
                WatchSessionManager.shared.send(message: ["fromWatch": "Hello iPhone 👋"])
            }
#endif
        }
    }
}

#Preview {
    ContentView()
}
