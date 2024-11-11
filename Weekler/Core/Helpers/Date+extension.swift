//
//  Date+extension.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 19.08.2024.
//

import Foundation

extension Date {
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    
    var onlyDate: String {
        formatter.string(from: self)
    }
}
