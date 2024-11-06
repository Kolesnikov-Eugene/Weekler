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
    @Attribute(.unique) private(set) var id: UUID
    var date: Date
    var taskDescription: String
    var isNotificationEnabled: Bool
    @Relationship(deleteRule: .cascade) var completed: CompletedTask?
    
    var onlyDate: String
    
    init(id: UUID = UUID(), date: Date, taskDescription: String, isNotificationEnabled: Bool) {
        self.id = id
        self.date = date
        self.taskDescription = taskDescription
        self.isNotificationEnabled = isNotificationEnabled
        onlyDate = date.onlyDate
    }
    
    func editWithNew(_ task: TaskToEdit) {
        date = task.date
        taskDescription = task.description
        isNotificationEnabled = task.isNotificationEnabled
        onlyDate = date.onlyDate
    }
}
