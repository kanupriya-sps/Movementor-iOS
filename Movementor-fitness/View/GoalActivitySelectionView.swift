//
//  GoalActivitySelectionView.swift
//  Movementor-fitness
//
//  Created by user on 17/12/24.
//

import SwiftUI

struct GoalActivitySelectionView: View {
    @State private var selectedActivity: String? = nil
    
    // Activities
    private let activities = [
        Activity(name: "Walking", imageName: "walking"),
        Activity(name: "Running", imageName: "jogging"),
        Activity(name: "Cycling", imageName: "cycling"),
        Activity(name: "Yoga", imageName: "yoga")
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("What are your goals")
                    .font(.system(size: 40))
                    .bold()
                    .padding(.top, 50)
                    .padding(.bottom, -20)
                Text("Exercise?")
                    .font(.system(size: 40))
                    .bold()
                    .padding(.bottom, -20)
                Text("Let's define you goals and will help you to achieve it")
                    .padding(.bottom, 20)
                
                // Activity Cards
                ForEach(activities) { activity in
                    Button(action: {
                        selectedActivity = activity.name
                    }) {
                        HStack {
                            Text(activity.name)
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .bold()
                                .padding()
                            
                            Spacer()
                            
                            Image(activity.imageName)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                        .frame(height: 70)
                        .frame(maxWidth: .infinity)
                        .background(Color.clear) // Clear background
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("pink"), lineWidth: 2) // Pink border
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Navigation to GoalSettingView
               // if let activity = selectedActivity {
                    NavigationLink(
                        destination: SetGoalsScreenView(selectedActivity: selectedActivity ?? ""),
                        isActive: Binding(
                            get: { selectedActivity != nil },
                            set: { _ in selectedActivity = nil }
                        ),
                        label: { EmptyView() }
                    )
               // }
            }
            .padding()
            .background(Color(.white).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    GoalActivitySelectionView()
}
