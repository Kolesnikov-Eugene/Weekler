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
            return L10n.Localizable.Calendar.Short.monday
        case .tuesday:
            return L10n.Localizable.Calendar.Short.tuesday
        case .wednesday:
            return L10n.Localizable.Calendar.Short.wednesday
        case .thursday:
            return L10n.Localizable.Calendar.Short.thursday
        case .friday:
            return L10n.Localizable.Calendar.Short.friday
        case .saturday:
            return L10n.Localizable.Calendar.Short.saturday
        case .sunday:
            return L10n.Localizable.Calendar.Short.sunday
        }
    }
}
