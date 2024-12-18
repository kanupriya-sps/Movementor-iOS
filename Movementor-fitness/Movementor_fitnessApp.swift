//
//  Movementor_fitnessApp.swift
//  Movementor-fitness
//
//  Created by user on 10/12/24.
//

import SwiftUI

@main
struct Movementor_fitnessApp: App {
    
    @StateObject var goalsManager = GoalsManagerViewModel() // Initialize the ViewModel
    @StateObject var reminderManager = RemindersViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(goalsManager)  // Inject the ViewModel into the environment
                .environmentObject(reminderManager)
        }
    }
}
