//
//  iBreatheApp.swift
//  iBreathe
//
//  Created by Anurag Pandit on 15/07/25.
//

import SwiftUI

@main
struct iBreatheApp: App {
    @StateObject private var sessionManager = iPhoneSessionManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    _ = sessionManager
                }
        }
    }
}
