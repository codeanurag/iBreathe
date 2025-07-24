//
//  HealthKitManager.swift
//  iBreathe
//
//  Created by Anurag Pandit on 20/07/25.
//


import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()

    private init() {}

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }

        let mindfulnessType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        let typesToShare: Set = [mindfulnessType]
        let typesToRead: Set = [mindfulnessType]

        healthStore.requestAuthorization(toShare: typesToShare,
                                         read: typesToRead,
                                         completion: completion)
    }

    func saveMindfulnessSession(start: Date, end: Date) {
        let mindfulnessType = HKCategoryType.categoryType(forIdentifier: .mindfulSession)!
        let session = HKCategorySample(type: mindfulnessType,
                                       value: 0,
                                       start: start,
                                       end: end)
        
        healthStore.save(session) { success, error in
            if !success {
                print("⚠️ Failed to save mindfulness session: \(String(describing: error))")
            } else {
                print("✅ Mindfulness session saved to HealthKit.")
            }
        }
    }
}
