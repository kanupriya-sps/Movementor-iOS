//
//  ActivityManager.swift
//  Movementor-fitness
//
//  Created by user on 13/12/24.
//

import HealthKit

class ActivityManager: ObservableObject {
    private var healthStore: HKHealthStore?
    
    @Published var lastIdealState: String  = ""
    @Published var isAuthorized = false
    
    // Ensure HealthKit is available on the device
    var isHealthDataAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    // Define the type for step count data
    private var stepCountType: HKQuantityType?
    
    init() {
        //since appleStandTime is only available in watchOS as of now that's why we as using .stepCount for timebeing
        stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)
    }
    
    deinit{
        print("IdealStateManager deinit")
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
        
        healthStore = nil
        healthStore = HKHealthStore()
        healthStore?.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthorized = true
                    self.startTrackingStepCount()
                } else {
                    self.isAuthorized = false
                    if let error = error {
                        print("HealthKit authorization failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func startTrackingStepCount() {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // Set up a predicate to get data from the past
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        
        // Set up the query to receive real-time updates
        let query = HKAnchoredObjectQuery(type: stepCountType,
                                          predicate: predicate,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { [weak self] (query, samples, deletedObjects, anchor, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching step count: \(error.localizedDescription)")
                    return
                }
                
                // Process the step count data
                self.handleStepCountSamples(samples)
            }
        }
        
        query.updateHandler = { [weak self] (query, samples, deletedObjects, anchor, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching step count: \(error.localizedDescription)")
                    return
                }
                
                // Handle updates to the step count
                self.handleStepCountSamples(samples)
            }
        }
        
        // Execute the query
        healthStore?.execute(query)
    }
    
    func handleStepCountSamples(_ samples: [HKSample]?) {
        guard let samples = samples, let lastSample = samples.last else { return }
        let elapsed = Date().timeIntervalSince(lastSample.endDate)
        lastIdealState = convertSecondsToHoursMinutes(seconds: elapsed)
    }
    
    func convertSecondsToHoursMinutes(seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let remainingSeconds = Int(seconds) % 60
        let fractionalSeconds = seconds - Double(Int(seconds))
        return "\(hours) hours, \(minutes) minutes, \(remainingSeconds) seconds"
    }
}

