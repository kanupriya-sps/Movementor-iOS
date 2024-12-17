//
//  ProfileScreenView.swift
//  Movementor-fitness
//
//  Created by user on 10/12/24.
//

import SwiftUI

struct ProfileScreenView: View {
    
    @State private var name: String = PersonalDetails.name
    @State private var joinedOn: String = PersonalDetails.joinedOn
    @State private var height: Int = PersonalDetails.height
    @State private var weight: Int = PersonalDetails.weight
    @State private var age: Int = PersonalDetails.age
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Details
                HStack(spacing: 15) {
                    Image("profileIcon")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(name)")
                            .font(.title3)
                            .bold()
                        Text("joined \(joinedOn)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("\(height) m • \(weight) kg • \(age) yrs")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Edit action
                    }) {
                        Text("Edit")
                            .font(.system(size: 16))
                            .bold()
                            .frame(width: 60, height: 30)
                            .background(Color("pink"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 30)
                
                Divider()
                
                // This Week's Progress
                VStack(spacing: 15) {
                    Text("This Week’s progress")
                        .font(.headline)
                        .frame(alignment: .leading)
                    
                    HStack(spacing: 30) {
                        HStack(spacing: 5) {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                            Text("67,525 steps")
                                .font(.subheadline)
                        }
                        
                        HStack(spacing: 5) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.red)
                            Text("6,730.5 cal")
                                .font(.subheadline)
                        }
                        
                        HStack(spacing: 5) {
                            Image(systemName: "figure.walk")
                                .foregroundColor(.blue)
                            Text("50.2 mi")
                                .font(.subheadline)
                        }
                    }
                    .frame(alignment: .center)
                    
                    // Bar Chart (Static Example)
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(0..<7) { day in
                            VStack {
                                Spacer()
                                Rectangle()
                                    .fill(day == 5 ? Color("pink") : Color("lightPink"))
                                    .frame(width: 20, height: CGFloat.random(in: 50...200))
                                
                                Text(["S", "M", "T", "W", "T", "F", "S"][day])
                                    .font(.caption)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width ,height: 200)
                    
                    Text("you’ve completed 3 out of 7 daily goals.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Your Goal Setting
                VStack(alignment: .leading, spacing: 15) {
                    Text("Your Goal setting")
                        .font(.headline)
                    
                    HStack {
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.red)
                            Text("Calories to burn")
                                .font(.subheadline)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("2,000 cal")
                                .font(.subheadline)
                            Text("5 days")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack {
                        HStack {
                            Image(systemName: "figure.walk.circle.fill")
                                .foregroundColor(.green)
                            Text("Steps to walk")
                                .font(.subheadline)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("20,000 steps")
                                .font(.subheadline)
                            Text("daily")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Your sleep cycle")
                        .font(.headline)
                    
                    HStack {
                        HStack {
                            Image(systemName: "moon.fill")
                                .foregroundColor(Color("pink"))
                            Text("Bed time")
                                .font(.subheadline)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("10:00 PM")
                                .font(.subheadline)
                            Text("daily")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack {
                        HStack {
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(.yellow)
                            Text("wake up time")
                                .font(.subheadline)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("06:30 AM")
                                .font(.subheadline)
                            Text("daily")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding(.vertical)
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ProfileScreenView()
}
