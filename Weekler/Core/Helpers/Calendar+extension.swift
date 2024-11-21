//
//  Calendar+extension.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 21.11.2024.
//

import Foundation

extension Calendar {
    static func getCurrentWeekDatesArray() -> [String] {
        let calendar = self.current
        let currentDate = Date()
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)
        let startOfWeek = calendar.date(from: dateComponents)
        guard let startOfWeek else {
            fatalError("error")
        }
        let weekDates = (0...6).map { calendar.date(byAdding: .day, value: $0, to: startOfWeek)?.onlyDate ?? Date().onlyDate }
        return weekDates
    }
}
