//
//  DaysOfWeek.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 23.04.2024.
//

import JTAppleCalendar

extension DaysOfWeek {
    static func getShortDayOfWeek(for day: DaysOfWeek) -> String {
        switch day {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Cб"
        case .sunday:
            return "Вс"
        }
    }
}
