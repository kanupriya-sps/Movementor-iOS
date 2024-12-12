//
//  SignUpView.swift
//  Movementor-fitness
//
//  Created by user on 12/12/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var navigateToTabBar: Bool = false
    
    // Computed property to check if all fields are valid
    private var isFormValid: Bool {
        return !fullName.isEmpty && !email.isEmpty && !phoneNumber.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Logo
                Image("appLogo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .padding(.top, 80)
                    .padding(.bottom, 20)
                Text("Sign Up")
                    .font(.system(size: 40))
                    .bold()
                    .padding(.bottom, -20)
                Text("to continue")
                    .padding(.bottom, 20)
                
                // Form
                VStack(spacing: 15) {
                    TextField("Full Name", text: $fullName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.words)
                        .onChange(of: fullName) { newValue in
                            // Allow only numeric characters
                            fullName = newValue.filter { $0.isLetter }
                        }
                        .textContentType(.name)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .keyboardType(.phonePad)
                        .onChange(of: phoneNumber) { newValue in
                            // Allow only numeric characters
                            phoneNumber = newValue.filter { $0.isNumber }
                        }
                        .textContentType(.telephoneNumber)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .textContentType(.password)
                }
                .padding(.horizontal, 20)
                
                // Sign Up Button
                Button(action: {
                    // Handle Sign Up action
                    navigateToTabBar = true
                    print("Sign Up tapped!")
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .bold()
                        .padding()
                        .background(Color(red: 0.9686, green: 0.3569, blue: 0.6157))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                // .disabled(!isFormValid) // uncomment this later after testing
                
                Spacer()
                
                NavigationLink(
                    destination: TabBarView(),
                    isActive: $navigateToTabBar,
                    label: {
                        EmptyView()
                    }
                )
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    SignUpView()
}
