//
//  BreatheSessionView.swift
//  iBreathe
//
//  Created by Anurag Pandit on 16/07/25.
//


import SwiftUI
import WatchKit

struct BreatheSessionView: View {
    @State private var scale: CGFloat = 1.0
    @State private var isInhaling = true
    @State private var timer: Timer?
    @State private var secondsRemaining = 60 // 1-minute session

    let inhaleDuration: TimeInterval = 4
    let exhaleDuration: TimeInterval = 4

    var body: some View {
        VStack(spacing: 10) {
            Text("🧘‍♂️ iBreathe")
                .font(.headline)

            ZStack {
                Circle()
                    .fill(isInhaling ? Color.green.opacity(0.8) : Color.blue.opacity(0.6))
                    .frame(width: 50, height: 50)
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: isInhaling ? inhaleDuration : exhaleDuration), value: scale)
            }
            .padding(4)

            Text(isInhaling ? "Inhale..." : "Exhale...")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("⏱ \(secondsRemaining) sec left")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .onAppear(perform: startSession)
        .onDisappear(perform: stopSession)
    }

    func startSession() {
        runBreathingCycle()
        timer = Timer.scheduledTimer(withTimeInterval: inhaleDuration + exhaleDuration, repeats: true) { _ in
            runBreathingCycle()
        }

        // Countdown timer
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { countdownTimer in
            secondsRemaining -= 1
            if secondsRemaining <= 0 {
                countdownTimer.invalidate()
                stopSession()
            }
        }
    }

    func runBreathingCycle() {
        isInhaling = true
        scale = 1.4
        triggerHaptic(for: .start)

        DispatchQueue.main.asyncAfter(deadline: .now() + inhaleDuration) {
            self.isInhaling = false
            self.scale = 1.0
            triggerHaptic(for: .stop)
        }
    }

    func stopSession() {
        timer?.invalidate()
        timer = nil
    }

    func triggerHaptic(for phase: Phase) {
        switch phase {
        case .start:
            WKInterfaceDevice.current().play(.start)
        case .stop:
            WKInterfaceDevice.current().play(.stop)
        }
    }

    enum Phase {
        case start, stop
    }
}
