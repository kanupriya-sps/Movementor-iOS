//
//  AddReminderScreenView.swift
//  Movementor-fitness
//
//  Created by user on 18/12/24.
//

import SwiftUI

struct AddReminderScreenView: View {
    @StateObject private var reminderVM = RemindersViewModel()
    @State private var selectedDuration = 1 // Default duration (1 minute)
    @State private var selectedUnit = "Minutes" // Default unit
    @State private var reminderMessage = "" // Reminder message input
    @State private var navigateToHome = false
    
    let durationOptions = [1, 5, 10, 15, 30, 60] // Example duration options (in minutes)
    let unitOptions = ["Minutes", "Hours", "Days"] // Different time unit options
    
    var body: some View {
        VStack(spacing: 30) {
                Text("Set Reminder")
                .font(.system(size: 30))
                .bold()
                .padding(.top, 50)
                // Reminder message input
                TextField("Enter reminder message", text: $reminderMessage)
                    .padding()
                    .font(.system(size: 20))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.sentences)
                    .frame(height: 50)
                
                // Picker for duration
                Picker("Select Duration", selection: $selectedDuration) {
                    ForEach(durationOptions, id: \.self) { duration in
                        Text("\(duration) \(selectedUnit)").tag(duration)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                .frame(height: 250)
                
                // Picker for time unit (minutes, hours, days)
                Picker("Select Time Unit", selection: $selectedUnit) {
                    ForEach(unitOptions, id: \.self) { unit in
                        Text(unit).tag(unit)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Button to confirm reminder setup
                Button(action: {
                    reminderVM.setReminder(reminderMessage: reminderMessage, selectedDuration: selectedDuration, selectedUnit: selectedUnit)
                    // Trigger navigation to Home Screen
                    navigateToHome = true
                }) {
                    Text("Set Reminder")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("pink"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            Spacer()
        }
        NavigationLink(
            destination: TabBarView().navigationBarBackButtonHidden(true),
            isActive: $navigateToHome,
            label: { EmptyView() }
        )
//        // printing only for testing
//        .onAppear{
//            for reminders in reminderVM.reminders {
//                print(reminders)
//            }
//        }
    }
}

#Preview {
    AddReminderScreenView()
}
