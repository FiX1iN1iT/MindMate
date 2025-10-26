//
//  Calendar+Ext.swift
//  MindMate
//
//  Created by Alexander on 25.10.2025.
//

import Foundation

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components) ?? date
    }
}
