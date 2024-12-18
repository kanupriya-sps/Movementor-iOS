//
//  GoalsSummaryView.swift
//  Movementor-fitness
//
//  Created by user on 18/12/24.
//

import SwiftUI

struct GoalsSummaryView: View {
    let goalName: String
    let goalDescription: String
    let targetDate: Date
    let additionalField: String
    let selectedActivity: String
    
    @EnvironmentObject var goalManager: GoalsManagerViewModel
    
    @State private var navigateToHome = false
        
    var body: some View {
        VStack(spacing: 20) {
            // Success Icon
            Spacer()
            VStack {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color.green)
                    .padding(.top, 20)
                
                Text("Successfully set goal")
                    .font(.system(size: 24))
                    .foregroundColor(.teal)
                    .bold()
                    .padding(.top, 10)
                
                Text("You managed to set your \(selectedActivity) goal!")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.top, 20)
            .padding(.bottom, 50)
            
            // Goal Summary Card
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "flame.fill") // Custom icon
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.pink)
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading) {
                        Text(goalName)
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.black)
                        Text(goalDescription)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    Spacer()
                }
                .padding(.bottom, 10)
                
                Divider()
                
                // Goal details
                GoalDetailRow(label: selectedActivityFieldName(), value: additionalField)
                GoalDetailRow(label: "Target Date", value: formattedDate(targetDate))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Done Button
            Button(action: {
                // Trigger navigation to Home Screen
                navigateToHome = true
                print("Done tapped")
            }) {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("pink"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            Spacer()
            NavigationLink(
                destination: TabBarView().navigationBarBackButtonHidden(true),
                isActive: $navigateToHome,
                label: { EmptyView() }
            )
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        // printing the added goals only for testing purpose
        .onAppear {
            for goals in goalManager.goals {
                print(goals)
            }
        }
    }
    
    // Helper function for dynamic field names
    private func selectedActivityFieldName() -> String {
        switch selectedActivity {
        case "Walking": return "Target Steps"
        case "Running": return "Target Distance (km)"
        case "Cycling": return "Target Time (hours)"
        case "Yoga": return "Target Sessions"
        default: return "Additional Info"
        }
    }
    
    // Format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// Component for each Goal Detail Row
struct GoalDetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
                .font(.system(size: 16))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16))
                .bold()
                .foregroundColor(.black)
        }
        .padding()
    }
}
#Preview {
    GoalsSummaryView(
        goalName: "Morning Run",
        goalDescription: "Complete a 5km run to start the day fresh.",
        targetDate: Date(),
        additionalField: "5",
        selectedActivity: "Running"
    )
}
