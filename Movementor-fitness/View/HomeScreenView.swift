//
//  HomeScreenView.swift
//  Movementor-fitness
//
//  Created by user on 10/12/24.
//

import SwiftUI

struct HomeScreenView: View {
    
    @State private var steps: Int = 0
    @State private var heartRate: Int = 0
    @State private var name: String = PersonalDetails.name
    @State private var showActionSheet: Bool = false  // State to toggle ActionSheet
    @State private var navigateToSetGoalsScreen = false
    @State private var navigateToAddActivityScreen = false
    @State private var navigateToAddReminderScreen = false
    
    @State private var isModalPresented = false

    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // user details section
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            Image("profileIcon")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            Text("\(name)")
                                .font(.system(size: 22))
                                .bold()
                            Spacer()
                            Button(action: {
                                // setting action
                            }) {
                                Image("setting")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .padding(.horizontal, 20)
                        ScrollingDateView()
                        Divider()
                        
                        // Your Stats Section
                        HStack {
                            Text("Your Stats")
                                .font(.headline)
                            Spacer()
                            Text("See all")
                                .font(.subheadline)
                                .foregroundColor(Color("pink"))
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 10) {
                            // Progress Card
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Spacer()
                                    Text("In-Progress")
                                        .font(.system(size:18))
                                    //Spacer()
                                    Text("56%")
                                        .font(.system(size:22))
                                        .bold()
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.gray)
                                        .frame(width: 20, height: 18)
                                }
                                ProgressView(value: 0.56)
                                    .accentColor(Color("pink"))
                                    .scaleEffect(y: 2)
                                    .padding(.vertical, 12)
                                HStack {
                                    Text("You’ve burned")
                                        .font(.subheadline)
                                    Image(systemName: "flame.fill")
                                        .resizable()
                                        .foregroundStyle(.pink)
                                        .frame(width: 13, height: 13)
                                    Text("\(healthKitManager.caloriesBurned, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(Color("pink"))
                                    Text("out of 2,000 cal.")
                                        .font(.subheadline)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            // .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                            
                            // Stats Grid
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 15) {
                                    StatCardView(
                                        iconName: "figure.walk",
                                        iconColor: .green,
                                        title: "steps",
                                        value: "\(Int(healthKitManager.stepCount))",
                                        progressValue: 0.78, progressColor: .green
                                    )
                                    StatCardView(
                                        iconName: "moon.fill",
                                        iconColor: .purple,
                                        title: "sleep",
                                        value: "7h 34m",
                                        progressValue: 0.91, progressColor: .purple
                                    )
                                }
                                HeartStatCardView(
                                    iconName: "heart.fill",
                                    iconColor: .red,
                                    title: "heart rate",
                                    value: "\(Int(healthKitManager.heartRate)) bpm"
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    Divider()
                    
                    // Your Activities Section
                    VStack(spacing: 15) {
                        HStack {
                            Text("Your Activities")
                                .font(.headline)
                            Spacer()
                            Text("See all")
                                .font(.subheadline)
                                .foregroundColor(Color("pink"))
                                .onTapGesture {
                                    isModalPresented = true
                                }
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 2) {
                            ActivityCardView(
                                time: "Today, 08:10 AM",
                                calories: "\(Double(healthKitManager.caloriesBurned)) cal",
                                iconName: "jogging",
                                distance: "\(healthKitManager.runningDistance)/5.00 miles",
                                activity: "Jogging",
                                statusImage: "pause.circle.fill",
                                iconColor: Color("pink")
                            )
                            ActivityCardView(
                                time: "Today, 06:30 AM",
                                calories: "\(Double(healthKitManager.caloriesBurned)) cal",
                                iconName: "cycling",
                                distance: "\(healthKitManager.cyclingDistance)/10.00 miles",
                                activity: "Cycling",
                                statusImage: "checkmark.circle.fill",
                                iconColor: .green
                            )
                            ActivityCardView(
                                time: "Today, 06:00 AM",
                                calories: "\(Double(healthKitManager.caloriesBurned)) cal",
                                iconName: "yoga",
                                distance: "\(Int(healthKitManager.yogaTime))/30 min",
                                activity: "Yoga",
                                statusImage: "checkmark.circle.fill",
                                iconColor: .green
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
            // Add Button (Fixed at Bottom)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showActionSheet = true  // Show the ActionSheet
                        print("Add Button Tapped")
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color("pink"))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(5), radius: 5, x: 0, y: 3)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 40)
                    Spacer()
                }
            }
            .overlay(
                AddActionSheetView(isPresented: $showActionSheet) { option in
                    if option == "setGoals" {
                        navigateToSetGoalsScreen = true
                    } else if option == "addActivity" {
                        navigateToAddActivityScreen = true
                    } else if option == "addReminder"{
                        navigateToAddReminderScreen = true
                    }
                } // Calling the custom ActionSheet View
            )
            .navigationDestination(isPresented: $navigateToSetGoalsScreen) {
                GoalActivitySelectionView()
            }
            .navigationDestination(isPresented: $navigateToAddActivityScreen) {
                AddActivityScreenView()
            }
            .navigationDestination(isPresented: $navigateToAddReminderScreen) {
                AddReminderScreenView()
            }
        }
        .onAppear {
                    // Fetch data when the view appears
                    healthKitManager.fetchWorkoutDistance(for: .running)
                    healthKitManager.fetchWorkoutDistance(for: .cycling)
                }
        .sheet(isPresented: $isModalPresented) {
            ActivitiesSeeAllView()
                   }
        .background(Color(.white))
    }
}

#Preview {
    HomeScreenView()
}

//    var body: some View {
//        VStack {
//            Spacer()
//            Text("Step count: \(steps)")
//                .font(.headline)
//            Button(action: {
//                steps += 1 // Increase steps locally
//                WatchConnector.shared.sendStepsToWatch(steps)
//                print("step increased!")
//            }) {
//                Text("Increase count by 1")
//            }
//            .padding(10)
//            .frame(width: 350, height: 50)
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//            Spacer()
//            Button(action: {
//                steps = 0
//                WatchConnector.shared.sendStepsToWatch(steps)
//            }) {
//                Text("clear all steps")
//            }
//            .padding(10)
//            .frame(width: 350, height: 50)
//            .background(Color.red)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//            .padding(.bottom, 30)
//        }
//        .navigationBarHidden(true)
//    }
