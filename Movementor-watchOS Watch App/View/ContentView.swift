//
//  ContentView.swift
//  Movementor-watchOS Watch App
//
//  Created by user on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var steps: Int = MockData.steps
    @State private var pieData: [Double] = MockData.pieChartData
    
    var body: some View {
            TabView {
                // Steps View
                VStack {
                    Text("Steps")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text("\(steps)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Spacer()
                    Text("Swipe up for more details")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.05)) // Light background
                .cornerRadius(10)
                
                // Pie Chart View
                VStack {
                    Text("Activity Breakdown")
                        .font(.headline)
                        .padding(.bottom, 15)
                    PieChartView(data: pieData)
                        .frame(width: 50, height: 50)
                    Spacer()
                    Text("Swipe down to go back")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.05)) // Light background
                .cornerRadius(10)
            }
            .tabViewStyle(.verticalPage) // Vertical swipe
        }
    }

// Custom Pie Chart View
struct PieChartView: View {
    var data: [Double]
    var colors: [Color] = [.blue, .green, .orange, .red]
    
    var body: some View {
        ZStack {
            ForEach(0..<data.count, id: \.self) { index in
                PieSliceView(startAngle: angle(for: index),
                             endAngle: angle(for: index + 1),
                             color: colors[index % colors.count])
            }
        }
        .aspectRatio(1, contentMode: .fit) // Keep the aspect ratio square
    }

    private func angle(for index: Int) -> Angle {
        let total = data.reduce(0, +)
        let value = data.prefix(index).reduce(0, +)
        return .degrees(360 * value / total)
    }
}

struct PieSliceView: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            Path { path in
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .fill(color)
            .rotationEffect(.degrees(-90))
        }
    }
}
#Preview {
    ContentView()
}
