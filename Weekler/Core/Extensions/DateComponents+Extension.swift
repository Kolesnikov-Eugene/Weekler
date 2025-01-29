//
//  DateComponents+Extension.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 15.01.2025.
//

import Foundation

extension DateComponents {
    static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        guard let leftHour = lhs.hour,
              let leftMinute = lhs.minute,
              let rightMinute = rhs.minute,
              let rightHour = rhs.hour else {
            return false
        }
        return (leftHour, leftMinute) < (rightHour, rightMinute)
    }
}
