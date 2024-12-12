//
//  HealthKitManager.swift
//  Movementor-fitness
//
//  Created by user on 12/12/24.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var stepCount: Double = 0.0
    @Published var isAuthorized = false
    
    // Ensure HealthKit is available on the device
    var isHealthDataAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    // Define the type for step count data
    private var stepCountType: HKQuantityType?
    
    init() {
        stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)
    }
    
    // Request HealthKit authorization to read and write step count
    func requestAuthorization() {
        guard let stepCountType = self.stepCountType else {
            print("Step count type is unavailable.")
            return
        }
        
        // Define the data types to read and write
        let dataTypesToRead: Set<HKObjectType> = [stepCountType]
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
}
