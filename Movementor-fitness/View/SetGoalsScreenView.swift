//
//  SetGoalsView.swift
//  Movementor-fitness
//
//  Created by user on 17/12/24.
//

import SwiftUI

struct SetGoalsScreenView: View {
    
    let selectedActivity: String
    @EnvironmentObject var goalManager: GoalsManagerViewModel
    
    @State private var goalName: String = ""
    @State private var goalDescription: String = ""
    @State private var targetDate: Date = Date()
    @State private var additionalField: String = ""
    @State private var navigateToSummary: Bool = false
    
    // Computed property to check if all fields are valid
    private var isFormValid: Bool {
        return !goalName.isEmpty && !goalDescription.isEmpty
    }
    
    var body: some View {
            VStack(spacing: 20) {

                Text("Set Your Goals for \(selectedActivity)")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                    .padding(.horizontal)

                // Form
                VStack(spacing: 15) {
                    TextField("Goal Name", text: $goalName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.words)

                    TextField("Goal Description", text: $goalDescription)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.sentences)

                    // Dynamic Field Based on Activity
                    if selectedActivity == "Walking" {
                        TextField("Target Steps", text: $additionalField)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                    } else if selectedActivity == "Running" {
                        TextField("Target Distance (km)", text: $additionalField)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .keyboardType(.decimalPad)
                    } else if selectedActivity == "Cycling" {
                        TextField("Target Time (hours)", text: $additionalField)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .keyboardType(.decimalPad)
                    } else if selectedActivity == "Yoga" {
                        TextField("Target Sessions", text: $additionalField)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                    }

                    DatePicker("Target Date", selection: $targetDate, in: Date()..., displayedComponents: .date)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)

                // Submit Button
                Button(action: {
                    // Handle goal submission
                    goalManager.addGoal(
                        activity: selectedActivity,
                        name: goalName,
                        description: goalDescription,
                        targetDate: targetDate,
                        additionalField: additionalField
                    )
                    navigateToSummary = true
                    print("Goals submitted for \(selectedActivity)!")
                }) {
                    Text("Submit Goals")
                        .frame(maxWidth: .infinity)
                        .bold()
                        .padding()
                        .background(isFormValid ? Color("pink") : Color("lightPink"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .disabled(!isFormValid)

                Spacer()

                NavigationLink(
                    destination: GoalsSummaryView(
                                    goalName: goalName,
                                    goalDescription: goalDescription,
                                    targetDate: targetDate,
                                    additionalField: additionalField,
                                    selectedActivity: selectedActivity
                                ).navigationBarBackButtonHidden(true),
                                isActive: $navigateToSummary,
                                label: { EmptyView() }
                            )
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
}

#Preview {
    SetGoalsScreenView(selectedActivity: "Running")
}
