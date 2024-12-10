//
//  TabBarView.swift
//  Movementor-fitness
//
//  Created by user on 10/12/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = "Home" // Default selected tab
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white // Tab bar background color
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
            TabView(selection: $selectedTab) {
                HomeScreenView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag("Home") // Tag identifies this tab
                
                StatisticsScreenView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.bar.fill")
                    }
                    .tag("Statistics")
                
                ProfileScreenView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag("Profile")
            }
            .onAppear {
                selectedTab = "Home" // Always default to Home
            }
        }
}

#Preview {
    TabBarView()
}
