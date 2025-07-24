//
//  BreatheSessionView.swift
//  iBreathe
//
//  Created by Anurag Pandit on 16/07/25.
//


import SwiftUI
import WatchKit

struct BreatheSessionView: View {
    let durationInMinutes: Int
    
    @State private var scale: CGFloat = 1.0
    @State private var isInhaling = true
    @State private var secondsRemaining: Int
    @State private var isPaused = false
    
    @State private var countdownTimer: Timer?
    @State private var breathingTimer: Timer?
    
    let inhaleDuration: TimeInterval = 4
    let exhaleDuration: TimeInterval = 4
    
    init(durationInMinutes: Int) {
        self.durationInMinutes = durationInMinutes
        self._secondsRemaining = State(initialValue: durationInMinutes * 60)
    }
    
    var body: some View {
        Text("🧘‍♂️ Breathe")
            .font(.headline)
            .padding(.top)
        ScrollView {
            VStack(spacing: 4) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(isInhaling ? Color.green.opacity(0.6) : Color.blue.opacity(0.6))
                        .frame(width: 50, height: 50)
                        .scaleEffect(scale)
                        .animation(.easeInOut(duration: isInhaling ? inhaleDuration : exhaleDuration), value: scale)
                }
                Spacer()
                Text(isInhaling ? "Inhale..." : "Exhale...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("⏱ \(secondsRemaining) sec left")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Button(isPaused ? "Resume" : "Pause") {
                    isPaused.toggle()
                    triggerHaptic(for: .click)
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        
        .onAppear {
            scale = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startSession()
            }
        }
        .onDisappear {
            stopSession()
        }
    }
    
    func startSession() {
        runBreathingCycle()
        breathingTimer = Timer.scheduledTimer(
            withTimeInterval: inhaleDuration + exhaleDuration,
            repeats: true
        ) { _ in
            if !isPaused {
                runBreathingCycle()
            }
        }
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if !isPaused {
                secondsRemaining -= 1
                if secondsRemaining <= 0 {
                    timer.invalidate()
                    breathingTimer?.invalidate()
                    triggerHaptic(for: .stop)
                    SessionLogger.saveLog(duration: durationInMinutes)
                    WatchSessionManager.shared.sendLogsToPhone()
                }
            }
        }
    }
    
    func stopSession() {
        countdownTimer?.invalidate()
        breathingTimer?.invalidate()
        countdownTimer = nil
        breathingTimer = nil
    }
    
    func runBreathingCycle() {
        isInhaling = true
        scale = 1.4
        triggerHaptic(for: .start)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + inhaleDuration) {
            guard !isPaused else { return }
            self.isInhaling = false
            self.scale = 1.0
            triggerHaptic(for: .stop)
        }
    }
    
    func triggerHaptic(for phase: Phase) {
        switch phase {
        case .start:
            WKInterfaceDevice.current().play(.start)
        case .stop:
            WKInterfaceDevice.current().play(.stop)
        case .click:
            WKInterfaceDevice.current().play(.click)
        }
    }
    
    enum Phase {
        case start, stop, click
    }
}

