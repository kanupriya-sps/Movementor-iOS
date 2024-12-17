//
//  StatCardView.swift
//  Movementor-fitness
//
//  Created by user on 13/12/24.
//

import SwiftUI

struct StatCardView: View {
    let iconName: String
    let iconColor: Color
    let title: String
    let value: String
    let progressValue : Float
    let progressColor: Color
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                Text(title)
                Spacer()
            }
            HStack{
                Spacer()
                Text(value)
                    .font(.title3)
                    .bold()
            }
            ProgressView(value: progressValue)
                .accentColor(progressColor)
            //.padding(.vertical, 8)
            
            // Spacer()
        }
        .frame(width: 154, height: 56)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        // .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}
struct HeartStatCardView: View {
    let iconName: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                Text(title)
                Spacer()
            }
            HStack{
                Spacer()
                Text(value)
                    .font(.title3)
                    .bold()
            }
            HeartRateWaveView()
                .frame(height: 100)
                .padding(.top, 8)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), .white]),
                                   startPoint: .bottom,
                                   endPoint: .top)
                )
                .cornerRadius(10)
            //            Image("heartLines")
            //                .resizable()
            //                .scaledToFill()
            //                .frame(width: 154, height: 80)
            //.padding(.horizontal, -30)
            //            ProgressView(value: progressValue)
            //                .accentColor(.pink)
            //                //.padding(.vertical, 8)
            
            // Spacer()
        }
        .frame(width: 154, height: 154)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        // .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

struct HeartRateWaveView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let midHeight = height / 2
                let waveAmplitude: CGFloat = 20 // Height of the wave
                let waveLength: CGFloat = width / 5 // Length of a single wave
                
                path.move(to: CGPoint(x: 0, y: midHeight))
                
                for i in stride(from: 0, through: width, by: 1) {
                    let y = midHeight + waveAmplitude * sin(2 * .pi * i / waveLength)
                    path.addLine(to: CGPoint(x: i, y: y))
                }
            }
            .stroke(
                LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.5)]),
                               startPoint: .leading,
                               endPoint: .trailing),
                lineWidth: 2
            )
        }
    }
}

#Preview {
    StatCardView(
        iconName: "moon.fill",
        iconColor: .purple,
        title: "sleep",
        value: "7h 34m",
        progressValue: 0.91, progressColor: .purple
    )
}

#Preview {
    HeartStatCardView(iconName: "heart.fill",
                      iconColor: .red,
                      title: "heart rate",
                      value: "88 bpm"
    )
}
