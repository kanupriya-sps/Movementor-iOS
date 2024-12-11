//
//  HomeScreenView.swift
//  Movementor-fitness
//
//  Created by user on 10/12/24.
//

import SwiftUI

struct HomeScreenView: View {
    
    @State private var steps: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            Text("Step count: \(steps)")
                .font(.headline)
            Button(action: {
                steps += 1 // Increase steps locally
                WatchConnector.shared.sendStepsToWatch(steps)
                print("step increased!")
            }) {
                Text("Increase count by 1")
            }
            .padding(10)
            .frame(width: 350, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            Spacer()
            Button(action: {
                steps = 0
                WatchConnector.shared.sendStepsToWatch(steps)
            }) {
                Text("clear all steps")
            }
            .padding(10)
            .frame(width: 350, height: 50)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    HomeScreenView()
}
