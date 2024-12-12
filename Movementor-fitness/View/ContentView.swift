//
//  ContentView.swift
//  Movementor-fitness
//
//  Created by user on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
                VStack(spacing: 0) {
                    Image("appLogo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                        .padding(.bottom, 10)
                        .edgesIgnoringSafeArea(.all)
                    Text("Welcome To Your Ultimate Training Companion!")
                        .font(.system(size: 30))
                        .bold()
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.bottom, 40)
                    NavigationLink(destination: SignUpView()) {
                        HStack {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                            Image("arrowRight")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.9686, green: 0.3569, blue: 0.6157))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
