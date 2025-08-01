//
//  iBreatheApp.swift
//  iBreathe Watch App
//
//  Created by Anurag Pandit on 15/07/25.
//

import SwiftUI

@main
struct iBreathe_Watch_AppApp: App {
    @StateObject private var healthManager = HealthManager()
    @StateObject private var sessionManager = WatchSessionManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    healthManager.requestAuthorization()
                    _ = sessionManager
                }
        }
    }
}
