//
//  ActivityCardView.swift
//  Movementor-fitness
//
//  Created by user on 13/12/24.
//

import SwiftUI

struct ActivityCardView: View {
    let time: String
    let calories: String
    let iconName: String
    let distance: String
    let activity: String
    let statusImage: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                HStack{
                    Text(time)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("🔥 \(calories)")
                        .font(.caption)
                        .foregroundColor(.pink)
                }
                HStack{
                    Image(iconName)
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading){
                       
                        Text(distance)
                            .font(.headline)
                        Text(activity)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            Spacer()
            Image(systemName: statusImage)
                .font(.largeTitle)
                .foregroundColor(iconColor)
        }
        .padding()
       // .background(Color.white)
        .cornerRadius(10)
        //.shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ActivityCardView(
        time: "Today, 06:30 AM",
        calories: "563.4 cal",
        iconName: "jogging",
        distance: "10.00/10.00 miles",
        activity: "Cycling",
        statusImage: "checkmark.circle.fill",
        iconColor: .green
    )
}
