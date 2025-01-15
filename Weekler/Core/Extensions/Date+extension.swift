//
//  Date+extension.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 19.08.2024.
//

import Foundation

extension Date {
    private var formatter: DateFormatter  {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var onlyDate: String {
        formatter.string(from: self)
    }
    
//    var onlyTime: String {
//        timeFormatter.string(from: self)
//    }
    
    var onlyTime: DateComponents {
        let calendar = Calendar.current
        let time = calendar.dateComponents([.hour, .minute], from: self)
        return time
    }
}
