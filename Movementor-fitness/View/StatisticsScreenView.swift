//
//  StatisticsScreenView.swift
//  Movementor-fitness
//
//  Created by user on 10/12/24.
//

import SwiftUI

struct StatisticsScreenView: View {
    
    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some View {
        VStack {
            if healthKitManager.isHealthDataAvailable {
                if healthKitManager.isAuthorized {
                    Text("Step count by HealthKit")
                        .font(.headline)
                    Text("\(Int(healthKitManager.stepCount))")
                        .font(.largeTitle)
                        .padding()
                } else {
                    Button(action: {
                        healthKitManager.requestAuthorization()
                    }) {
                        Text("Request HealthKit Authorization")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if healthKitManager.isHealthDataAvailable {
                healthKitManager.requestAuthorization()
                healthKitManager.fetchStepCount()
            } else {
                print("Health data is not available.")
            }
        }
    }
}

#Preview {
    StatisticsScreenView()
}
