//
//  HealthKitManagerTest.swift
//  Movementor-fitnessTests
//
//  Created by user on 13/12/24.
//

import Testing
import XCTest
import HealthKit
@testable import Movementor_fitness

class HealthKitManagerTest: XCTestCase {

    var mockHealthStore: MockHealthStore!
        var healthKitManager: HealthKitManager!

    override func setUp() {
           super.setUp()
           mockHealthStore = MockHealthStore()
           healthKitManager = HealthKitManager(healthStore: mockHealthStore)
       }


        func testFetchStepCount_Success() {
            // Arrange: Mock step count data
            let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: 1000)
            let sample = HKQuantitySample(type: HKObjectType.quantityType(forIdentifier: .stepCount)!, quantity: quantity, start: Date(), end: Date())
            mockHealthStore.savedSamples = [sample]
                // mockHealthStore.mockError = nil
            
            // Act
            healthKitManager.fetchStepCount()
            
            // Assert
            XCTAssertEqual(healthKitManager.stepCount, 1000)
        }
        
        func testFetchStepCount_Failure() {
            // Arrange: Mock an error
         //   mockHealthStore.savedSamples = nil
            //mockHealthStore.mockError = NSError(domain: "HealthKitError", code: 1, userInfo: nil)
            
            // Act
            healthKitManager.fetchStepCount()
            
            // Assert
            XCTAssertEqual(healthKitManager.stepCount, 0)
        }
    func testFetchHeartRateData_Success() {
        // Arrange: Mock heart rate data
        let quantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 72)
        let sample = HKQuantitySample(type: HKObjectType.quantityType(forIdentifier: .heartRate)!, quantity: quantity, start: Date(), end: Date())
        mockHealthStore.savedSamples = [sample]
       // mockHealthStore.mockError = nil
        
        let expectation = self.expectation(description: "HeartRateDataFetched")
        
        // Act
        healthKitManager.fetchHeartRateData { heartRate in
            XCTAssertEqual(heartRate, 72)
            expectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 1.0)
    }

    func testFetchHeartRateData_Failure() {
        // Arrange: Mock an error
        //mockHealthStore.savedSamples = nil
      //  mockHealthStore.mockError = NSError(domain: "HealthKitError", code: 1, userInfo: nil)
        
        let expectation = self.expectation(description: "HeartRateDataFetchFailed")
        
        // Act
        healthKitManager.fetchHeartRateData { heartRate in
            XCTAssertNil(heartRate)
            expectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 1.0)
    }

}
