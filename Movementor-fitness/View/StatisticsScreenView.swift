//
//  StatisticsScreenView.swift
//  Movementor-fitness
//
//  Created by user on 10/12/24.
//

import SwiftUI

struct StatisticsScreenView: View {
    
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var activityManager = ActivityManager()
    
    @State private var cyclingDistance = ""
    @State private var runningDistance = ""
    
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
            Text("Ideal Duration")
                .font(.headline)
                .padding(.top, 50)
            Text("\(activityManager.lastIdealState)")
                .font(.caption)
            
            Text("Enter distance covered in cycling")
            TextField("distance covered in km", text: $cyclingDistance)
            Text("Enter distance covered in running")
            TextField("distance covered in km", text: $runningDistance)
            
            Button(action: {
                if let cyclingDistance = Double(self.cyclingDistance),
                       let runningDistance = Double(self.runningDistance) {
                        healthKitManager.saveWorkout(type: .cycling, distance: cyclingDistance)
                        healthKitManager.saveWorkout(type: .running, distance: runningDistance)
                    } else {
                        print("Invalid input. Please enter valid numeric distances.")
                    }
            }){
                Text("save details to health kit")
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
            activityManager.requestAuthorization()
        }
    }
}

#Preview {
    StatisticsScreenView()
}
