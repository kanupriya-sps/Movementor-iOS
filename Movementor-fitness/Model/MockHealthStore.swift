//
//  MockHealthStore.swift
//  Movementor-fitness
//
//  Created by user on 13/12/24.
//

import HealthKit

class MockHealthStore: HealthStoreProtocol {
    var savedSamples: [HKSample] = []
    var queries: [HKQuery] = []
    
    func requestAuthorization(toShare: Set<HKSampleType>?, read: Set<HKObjectType>?, completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
    
     func save(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void) {
        if let sample = object as? HKSample {
            savedSamples.append(sample)
        }
        completion(true, nil) // Simulate successful save
    }
    
     func execute(_ query: HKQuery) {
        queries.append(query)
    }
}

