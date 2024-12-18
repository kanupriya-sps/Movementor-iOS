//
//  RemindersViewModel.swift
//  Movementor-fitness
//
//  Created by user on 18/12/24.
//

import SwiftUI

class RemindersViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    
    // Function to add a new reminder
    func setReminder(reminderMessage: String, selectedDuration: Int, selectedUnit: String) {
        let durationInSeconds: TimeInterval
        
        // Calculate the duration in seconds based on the selected unit
        switch selectedUnit {
        case "Hours":
            durationInSeconds = TimeInterval(selectedDuration * 3600) // 1 hour = 3600 seconds
        case "Days":
            durationInSeconds = TimeInterval(selectedDuration * 86400) // 1 day = 86400 seconds
        default:
            durationInSeconds = TimeInterval(selectedDuration * 60) // Default: minutes
        }
        
        // Log the reminder setup
        print("Reminder set for \(reminderMessage) in \(selectedDuration) \(selectedUnit)")
        
        // Add the reminder to the list
        let reminder = Reminder(message: reminderMessage, selectedDuration: selectedDuration, selectedUnit: selectedUnit)
        reminders.append(reminder)
    }
    
    // Function to remove a reminder by ID
    func removeReminder(id: UUID) {
        reminders.removeAll { $0.id == id }
    }
}
