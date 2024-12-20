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
    @Published var standTime: Double = 0.0
    @Published var exerciseTime: Double = 0.0
    @Published var cyclingTime: Double = 0.0
    @Published var caloriesBurned: Double = 0.0
    @Published var yogaTime: Double = 0.0
    @Published var cyclingDistance: Double = 0.0
    @Published var runningDistance: Double = 0.0
    @Published var isAuthorized = false
   // @Published var showAlert: Bool = false
    @Published var lastActiveTimestamp: Date = Date() // Timestamp of the last activity
    
    // for calculating ideal time
    var lastStepCount: Double = 0
    var lastExerciseTime: Double = 0
    
    // Ensure HealthKit is available on the device
    var isHealthDataAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    // Define the type for step count data
    private var stepCountType: HKQuantityType?
    private var heartRateType: HKQuantityType?
    private var standTimeType: HKQuantityType?
    private var exerciseTimeType: HKQuantityType?
    private var workoutType: HKWorkoutType?
    
    init(healthStore: HealthStoreProtocol = HKHealthStore()) {
        self.healthStore = (healthStore as? HKHealthStore)!
        self.stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)
        self.heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        self.standTimeType = HKObjectType.quantityType(forIdentifier: .appleStandTime)
        self.exerciseTimeType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        self.workoutType = HKObjectType.workoutType()
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
        guard let standTimeType = self.standTimeType else {
            print("stand time type is unavailable.")
            return
        }
        guard let exerciseTimeType = self.exerciseTimeType else {
            print("exercise time type is unavailable.")
            return
        }
        guard let workoutType = self.workoutType else {
            print("workout type is unavailable.")
            return
        }
        
        
        // Define the data types to read and write
        let dataTypesToRead: Set<HKObjectType> = [stepCountType, heartRateType, standTimeType, exerciseTimeType, workoutType]
        let dataTypesToWrite: Set<HKSampleType> = [stepCountType, workoutType]
        
        healthStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthorized = true
                    self.fetchStepCount()
                    self.fetchHeartRateData { _ in }
                    self.fetchStandTime()
                    self.fetchExerciseTime()
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
    
    // Fetch Stand Time
    func fetchStandTime() {
        guard let standTimeType = self.standTimeType else {
            print("Stand time type is unavailable.")
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictEndDate)
        
        let query = HKStatisticsQuery(quantityType: standTimeType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("Failed to fetch stand time: \(error.localizedDescription)")
                return
            }
            
            if let result = result, let quantity = result.sumQuantity() {
                DispatchQueue.main.async {
                    self.standTime = quantity.doubleValue(for: HKUnit.hour())
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    // Fetch Exercise Time
    func fetchExerciseTime() {
        guard let exerciseTimeType = self.exerciseTimeType else {
            print("Exercise time type is unavailable.")
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictEndDate)
        
        let query = HKStatisticsQuery(quantityType: exerciseTimeType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("Failed to fetch exercise time: \(error.localizedDescription)")
                return
            }
            
            if let result = result, let quantity = result.sumQuantity() {
                DispatchQueue.main.async {
                    self.exerciseTime = quantity.doubleValue(for: HKUnit.minute())
                }
            }
        }
        
        healthStore.execute(query)
//        fetchCaloriesBurned(for: .activeEnergyBurned) { calories in
//            self.caloriesBurned = calories
//        }
    }
    
    // Fetch workout Time
    func fetchWorkoutTime() {
        guard let workoutType = self.workoutType else {
            print("Workout type is unavailable.")
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictEndDate)
        
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { query, results, error in
            if let error = error {
                print("Failed to fetch cycling time: \(error.localizedDescription)")
                return
            }
            
            guard let workouts = results as? [HKWorkout] else {
                print("No workouts found.")
                return
            }
            
            // Sum up the cycling time for all cycling workouts
            let cyclingDuration = workouts
                .filter { $0.workoutActivityType == .cycling }
                .reduce(0.0) { $0 + $1.duration } // Duration is in seconds
            let yogaDuration = workouts
                .filter { $0.workoutActivityType == .yoga }
                .reduce(0.0) { $0 + $1.duration }
            
            DispatchQueue.main.async {
                self.cyclingTime = cyclingDuration / 60 // Convert seconds to minutes
                self.yogaTime = yogaDuration / 60
            }
        }
        
        healthStore.execute(query)
        fetchCaloriesBurned(for: .activeEnergyBurned) { calories in
            self.caloriesBurned = calories
        }
    }
    
    func fetchCaloriesBurned(for activityType: HKQuantityTypeIdentifier, completion: @escaping (Double) -> Void) {
        guard let caloriesType = HKObjectType.quantityType(forIdentifier: activityType) else {
            print("Required data type is unavailable.")
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictEndDate)

        let query = HKStatisticsQuery(quantityType: caloriesType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("Failed to fetch calories: \(error.localizedDescription)")
                completion(0.0)
                return
            }

            if let result = result, let quantity = result.sumQuantity() {
                let calories = quantity.doubleValue(for: HKUnit.kilocalorie()) // Calories burned in kilocalories
                DispatchQueue.main.async {
                    completion(calories) // Return calories in completion handler
                }
            } else {
                DispatchQueue.main.async {
                    completion(0.0) // No calories data found
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func saveWorkout(type: HKWorkoutActivityType, distance: Double) {
        // Convert distance to meters
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance * 1000) // Convert km to meters
        
        // Create the workout object
        let workout = HKWorkout(
            activityType: type,
            start: Date(),
            end: Date(),
            workoutEvents: nil,
            totalEnergyBurned: nil,
            totalDistance: distanceQuantity,
            metadata: nil
        )
        
        // Save the workout to HealthKit
        healthStore.save(workout) { success, error in
            DispatchQueue.main.async {
                if success {
                    let activityName = type.activityName
                    print("\(activityName) workout saved successfully with distance: \(distance) km")
                } else if let error = error {
                    print("Failed to save workout: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchWorkoutDistance(for activityType: HKWorkoutActivityType) {
        // Define the predicate for filtering workouts based on activity type
        let predicate = HKQuery.predicateForWorkouts(with: activityType)
        
        // Define the sort descriptor to get the most recent workout first
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Create the query to fetch workouts
        let query = HKSampleQuery(
            sampleType: HKSampleType.workoutType(),
            predicate: predicate,
            limit: 1, // We only need the most recent workout
            sortDescriptors: [sortDescriptor]
        ) { [weak self] _, results, _ in
            guard let self = self, let workouts = results as? [HKWorkout], let latestWorkout = workouts.first else { return }
            
            // Get the distance of the latest workout
            if let distance = latestWorkout.totalDistance?.doubleValue(for: .meter()) {
                // Convert the distance from meters to kilometers
                let totalDistanceInKilometers = distance / 1000.0
                
                // Print the fetched distance
                print("Fetched distance for \(activityType.activityName): \(totalDistanceInKilometers) km")
                
                DispatchQueue.main.async {
                    if activityType == .running {
                        self.runningDistance = totalDistanceInKilometers
                    } else if activityType == .cycling {
                        self.cyclingDistance = totalDistanceInKilometers
                    }
                }
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    func checkForInactivity() {
        let currentTime = Date()
        
        // If step count or exercise time has changed, update last active timestamp
        if self.stepCount != lastStepCount || self.exerciseTime != lastExerciseTime {
            lastActiveTimestamp = currentTime
            lastStepCount = self.stepCount
            lastExerciseTime = self.exerciseTime
        }
        
        // Calculate inactivity duration
        let inactivityDuration = currentTime.timeIntervalSince(lastActiveTimestamp)
        
        // Show alert if inactive for 2 hours (7200 seconds)
        if inactivityDuration >= 7200 {
            //                    DispatchQueue.main.async {
            //                        self.showAlert = true
            //                    }
            GlobalAlertManager.shared.triggerAlert(
                title: "Time to Move!",
                message: "You've been inactive for 2 hours. Take a short walk or stretch!"
            )
        }
    }
    
    func startInactivityMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in // Check every 5 minutes
            self.fetchStepCount()
            self.fetchExerciseTime()
            self.checkForInactivity()
        }
    }
}

extension HKWorkoutActivityType {
    var activityName: String {
        switch self {
        case .running:
            return "Running"
        case .cycling:
            return "Cycling"
        default:
            return "Unknown Activity"
        }
    }
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
