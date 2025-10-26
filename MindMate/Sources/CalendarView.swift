//
//  CalendarView.swift
//  MindMate
//
//  Created by Alexander on 25.10.2025.
//

import SwiftUI

struct CalendarView: View {

    // MARK: Public Properties

    @Binding var selectedDate: Date

    // MARK: Private Properties

    @State private var displayedWeek: Date = Calendar.current.startOfWeek(for: Date())

    private let calendar: Calendar = Calendar.current

    private var weeks: [Date] {
        let currentDate = Date()

        var result: [Date] = []
        for i in -12...0 {
            if let weekStart = calendar.date(byAdding: .weekOfYear, value: i, to: calendar.startOfWeek(for: currentDate)) {
                result.append(weekStart)
            }
        }

        return result
    }

    // MARK: Body

    var body: some View {
        VStack {
            Text(weekTitle(for: selectedDate))
                .font(.title3.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(weeks, id: \.self) { weekStart in
                            let days = weekGrid(for: weekStart)

                            VStack(spacing: 4) {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 7), spacing: 2) {
                                    ForEach(days, id: \.self) { date in
                                        let isSelected = calendar.isDate(selectedDate, inSameDayAs: date)
                                        let isToday = calendar.isDateInToday(date)
                                        let symbol = weekdaySymbol(for: date)

                                        VStack(spacing: 4) {
                                            Text("\(calendar.component(.day, from: date))")
                                                .font(.system(size: 24).bold())
                                                .frame(maxWidth: .infinity, minHeight: 45)

                                            Text(symbol)
                                                .font(.system(size: 11))
                                                .frame(maxWidth: .infinity)
                                        }
                                        .padding(.bottom, 8)
                                        .opacity(isSelected || isToday ? 1 : 0.3)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1)
                                                .foregroundStyle(isSelected ? Color.secondary : .clear)
                                        }
                                        .onTapGesture {
                                            if calendar.startOfDay(for: date) <= calendar.startOfDay(for: Date()) {
                                                selectedDate = date
                                            }
                                        }
                                        .sensoryFeedback(.selection, trigger: selectedDate)
                                    }
                                }
                                .containerRelativeFrame(.horizontal)
                            }
                            .id(weekStart)
                        }
                    }
                    .scrollTargetLayout()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            proxy.scrollTo(displayedWeek, anchor: .center)
                        }
                    }
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            }
        }
    }

    // MARK: Private Methods

    private func weekdaySymbol(for date: Date) -> String {
        let weekdayIndex = calendar.component(.weekday, from: date) - 1
        return calendar.shortWeekdaySymbols[weekdayIndex].prefix(3).uppercased()
    }

    private func weekTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }

    private func weekGrid(for weekStart: Date) -> [Date] {
        (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: weekStart)
        }
    }
}
