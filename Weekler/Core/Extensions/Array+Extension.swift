//
//  Array+Extension.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 27.01.2025.
//

import Foundation

extension Array where Element == ScheduleTask {
    mutating func sortByTime() {
        self.sort { date1, date2 in
            guard let date1 = date1.dates.first,
                  let date2 = date2.dates.first else {
                return false
            }
            return date1.onlyTime < date2.onlyTime
        }
    }
}
