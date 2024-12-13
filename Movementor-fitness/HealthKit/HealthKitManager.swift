//
//  HealthKitManager.swift
//  Movementor-fitness
//
//  Created by user on 12/12/24.
//

import Foundation
import HealthKit

protocol HealthStoreProtocol {
    func requestAuthorization(toShare: Set<HKSampleType>?, read: Set<HKObjectType>?, completion: @escaping (Bool, Error?) -> Void)
    func execute(_ query: HKQuery)
    func save(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void)
}

extension HKHealthStore: HealthStoreProtocol {}

class HealthKitManager: ObservableObject {
    private var healthStore = HKHealthStore()
    
    @Published var stepCount: Double = 0.0
    @Published var heartRate: Double = 0.0
    @Published var isAuthorized = false
    
    // Ensure HealthKit is available on the device
    var isHealthDataAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    // Define the type for step count data
    private var stepCountType: HKQuantityType?
    private var heartRateType: HKQuantityType?
    
    init(healthStore: HealthStoreProtocol = HKHealthStore()) {
        self.healthStore = (healthStore as? HKHealthStore)!
            self.stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)
            self.heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        }
           
    
    // Request HealthKit authorization to read and write step count
    func requestAuthorization() {
        guard let stepCountType = self.stepCountType else {
            print("Step count type is unavailable.")
            return
        }
        guard let heartRateType = self.heartRateType else {
            print("heart rate type is unavailable.")
            return
        }
        
        // Define the data types to read and write
        let dataTypesToRead: Set<HKObjectType> = [stepCountType, heartRateType]
        let dataTypesToWrite: Set<HKSampleType> = [stepCountType]
        
        healthStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthorized = true
                    self.fetchStepCount()
                } else {
                    self.isAuthorized = false
                    if let error = error {
                        print("HealthKit authorization failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // Fetch the step count for today
    func fetchStepCount() {
        guard let stepCountType = self.stepCountType else {
            print("Step count type is unavailable.")
            return
        }
        
        // Set the predicate to query steps from today
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictEndDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("Failed to fetch step count: \(error.localizedDescription)")
                return
            }
            
            if let result = result, let quantity = result.sumQuantity() {
                DispatchQueue.main.async {
                    self.stepCount = quantity.doubleValue(for: HKUnit.count())
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    // Write a manual step count value to HealthKit
    func writeStepCount(steps: Double) {
        guard let stepCountType = self.stepCountType else {
            print("Step count type is unavailable.")
            return
        }
        
        // Create a quantity sample to write
        let stepQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: steps)
        let stepSample = HKQuantitySample(type: stepCountType, quantity: stepQuantity, start: Date(), end: Date())
        
        healthStore.save(stepSample) { success, error in
            DispatchQueue.main.async { [weak self] in
                if success {
                    print("Successfully saved step count to HealthKit.")
                    self?.fetchStepCount()
                } else {
                    if let error = error {
                        print("Failed to save step count: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    func fetchHeartRateData(completion: @escaping (Double?) -> Void) {
        // Ensure that the heart rate quantity type is available
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            print("Heart rate type is unavailable.")
            completion(nil)
            return
        }

        // Define the date range for today's heart rate data
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)

        // Create the sample query to fetch heart rate data
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: predicate,
            limit: 1, // Limit to 1 most recent sample
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)],
            resultsHandler: { query, results, error in
                // Handle the results or error
                guard let samples = results as? [HKQuantitySample], let sample = samples.first else {
                    print("No heart rate data found or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                // Extract the heart rate in beats per minute
                let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                completion(heartRate)
            }
        )

        // Execute the query using the HealthKit store
        healthStore.execute(query)
    }

    
//    func fetchHeartRateData(completion: @escaping (Double?) -> Void) {
//        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
//
//        let now = Date()
//        let startOfDay = Calendar.current.startOfDay(for: now)
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
//
//        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { query, results, error in
//            guard let samples = results as? [HKQuantitySample], let sample = samples.first else {
//                print("No heart rate data found or error occurred: \(error?.localizedDescription ?? "Unknown error")")
//                completion(nil)
//                return
//            }
//
//            // Heart rate is stored as beats per minute (BPM)
//            self.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
//            completion(self.heartRate)
//        }
//
//        healthStore.execute(query)
//    }

}
