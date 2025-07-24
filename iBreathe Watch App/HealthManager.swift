//
//  HealthManager.swift
//  iBreathe
//
//  Created by Anurag Pandit on 16/07/25.
//


import Foundation
import HealthKit

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available.")
            return
        }
        
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        ]
        
        healthStore.requestAuthorization(toShare: [],
                                         read: readTypes) { success, error in
            if success {
                print("✅ HealthKit authorization granted.")
            } else {
                print("❌ HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
