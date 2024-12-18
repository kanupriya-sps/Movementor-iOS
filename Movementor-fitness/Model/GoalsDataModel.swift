//
//  GoalsDataModel.swift
//  Movementor-fitness
//
//  Created by user on 18/12/24.
//

import Foundation

struct Goal: Identifiable {
    let id = UUID()
    let activity: String
    let name: String
    let description: String
    let targetDate: Date
    let additionalField: String
}

struct Activity: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

