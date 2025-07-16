//
//  ContentView.swift
//  iBreathe Watch App
//
//  Created by Anurag Pandit on 15/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var navigateToSession = false
    @State private var showHistory = false
    @State private var selectedDuration: Int = 1
    let durationOptions = [1, 3, 5]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("🧘‍♀️ iBreathe")
                        .font(.title3)
                    
                    Picker("Duration",
                           selection: $selectedDuration) {
                        ForEach(durationOptions,
                                id: \.self) { value in
                            Text("\(value) min")
                        }
                    }
                    .pickerStyle(.automatic)
                    .frame(maxWidth: 100, minHeight: 50)
                    
                    Button("Start \(selectedDuration)-min Session") {
                        self.navigateToSession.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("View History") {
                        self.showHistory.toggle()
                    }
                    .buttonStyle(.bordered)
                }
                .navigationDestination(isPresented: $showHistory) {
                    SessionHistoryView()
                }
                
                .navigationDestination(isPresented: $navigateToSession) {
                    BreatheSessionView(durationInMinutes: selectedDuration)
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    ContentView()
}
