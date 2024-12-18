//
//  RemindersDataModel.swift
//  Movementor-fitness
//
//  Created by user on 18/12/24.
//

import Foundation

struct Reminder: Identifiable {
    let id = UUID()
    var message: String
    var selectedDuration: Int
    var selectedUnit: String
}
