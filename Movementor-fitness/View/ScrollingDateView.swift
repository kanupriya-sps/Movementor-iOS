//
//  ScrollingDateView.swift
//  Movementor-fitness
//
//  Created by user on 17/12/24.
//

import SwiftUI

struct ScrollingDateView: View {
    @State private var days: [Date] = []
    @State private var selectedDate: Date = Date() // Default selected date is today
    
    let dateFormatter = DateFormatter()
    let shortFormatter = DateFormatter()
    let dayFormatter = DateFormatter()
    
    init() {
        // Initialize formatters
        dateFormatter.dateFormat = "EEEE, dd MMM" // Full format e.g., "Monday, 04 Jun"
        shortFormatter.dateFormat = "dd" // Short format e.g., "04"
        dayFormatter.dateFormat = "EEEE" // Day format e.g., "Monday"
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(days, id: \.self) { date in
                    let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                    let isToday = Calendar.current.isDate(date, inSameDayAs: Date())
                    
                    Text(
                        isSelected
                        ? "\(isToday ? "Today" : dayFormatter.string(from: date)), \(formatDate(date))"
                        : shortFormatter.string(from: date)
                    )
                    .font(.system(size: 14))
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(isSelected ? Color("lightPink") : Color.clear)
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            selectedDate = date
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .onAppear {
            loadDates()
        }
    }
    
    // Function to generate dates for the current week
    private func loadDates() {
        let calendar = Calendar.current
        let today = Date()
        
        days = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset - 3, to: today)
        }
        
        selectedDate = today // Today is selected by default
    }
    
    // Function to format the date as "dd MMM"
    private func formatDate(_ date: Date) -> String {
        let dayMonthFormatter = DateFormatter()
        dayMonthFormatter.dateFormat = "dd MMM"
        return dayMonthFormatter.string(from: date)
    }
}

//#Preview {
//    ScrollingDateView()
//}
