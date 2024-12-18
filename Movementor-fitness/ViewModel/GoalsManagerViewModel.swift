//
//  GoalsManagerViewModel.swift
//  Movementor-fitness
//
//  Created by user on 18/12/24.
//

import SwiftUI

class GoalsManagerViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    
    func addGoal(activity: String, name: String, description: String, targetDate: Date, additionalField: String) {
        let newGoal = Goal(activity: activity, name: name, description: description, targetDate: targetDate, additionalField: additionalField)
        goals.append(newGoal)
    }
}
