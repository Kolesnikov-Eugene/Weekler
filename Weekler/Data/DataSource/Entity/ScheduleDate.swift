//
//  ScheduleDate.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 14.01.2025.
//

import Foundation
import SwiftData

@Model
final class ScheduleDate: Hashable, Identifiable {
    @Attribute(.unique) private(set) var id: UUID
    @Relationship var taskItem: TaskItem
    var date: Date
    
    var onlyDate: String
    
    init(taskItem: TaskItem, date: Date) {
        self.id = UUID()
        self.taskItem = taskItem
        self.date = date
        onlyDate = date.onlyDate
    }
}
