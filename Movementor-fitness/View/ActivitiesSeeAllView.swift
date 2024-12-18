//
//  ActivitiesSeeAllView.swift
//  Movementor-fitness
//
//  Created by user on 18/12/24.
//

import SwiftUI

struct ActivitiesSeeAllView: View {
    
    let activities = [
        ActivityDetails(name: "Jogging", duration: "1 mile", calories: "100 cal", imageName: "jogging"),
        ActivityDetails(name: "Cycling", duration: "1 mile", calories: "50-60 cal", imageName: "cycling"),
        ActivityDetails(name: "Hiking", duration: "1 mile", calories: "150 cal", imageName: "hiking"),
        ActivityDetails(name: "Swimming", duration: "30 min", calories: "200-250 cal", imageName: "swimming"),
        ActivityDetails(name: "Sit-Up", duration: "30 min", calories: "130-150 cal", imageName: "sitUp"),
        ActivityDetails(name: "Yoga", duration: "30 min", calories: "150 cal", imageName: "yoga"),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text("Activities")
                .font(.system(size: 30))
                .bold()
                .padding(.horizontal)
                .padding(.top)
            
            // List of Activities
            List(activities) { activity in
                ActivityRow(activity: activity)
            }
            .listStyle(PlainListStyle())
            .contentShape(Rectangle()) // Ensures the row doesn't respond to taps
            .allowsHitTesting(false)
        }
    }
}
// MARK: - Activity Row View
struct ActivityRow: View {
    let activity: ActivityDetails
    
    var body: some View {
        HStack {
            // Image
            Image(activity.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.trailing, 8)
            
            // Text Information
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("\(activity.duration) (\(activity.calories))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Play Button
            Button(action: {
                print("\(activity.name) tapped")
            }) {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("pink"))
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ActivitiesSeeAllView()
}
