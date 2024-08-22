//
//  TaskItem.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import Foundation
import SwiftData

@Model
final class TaskItem: ScheduleDataBaseType {
    @Attribute(.unique) let id: UUID
    var date: Date
    var taskDescription: String
    var isNotificationEnabled: Bool
    
    var onlyDate: String
    
    init(id: UUID = UUID(), date: Date, taskDescription: String, isNotificationEnabled: Bool) {
        self.id = id
        self.date = date
        self.taskDescription = taskDescription
        self.isNotificationEnabled = isNotificationEnabled
        onlyDate = date.onlyDate
    }
    
    func edit(_ task: ScheduleTask) {
        date = task.date
        taskDescription = task.description
        isNotificationEnabled = task.isNotificationEnabled
    }
}
