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
    var taskDescription: String
    var isNotificationEnabled: Bool
//    @Relationship(deleteRule: .cascade) var completed: CompletedTask?
    @Relationship(deleteRule: .cascade) var dates: [ScheduleDate]?
    
    var time: Date? // TODO: - ?
    
    init(
        id: UUID = UUID(),
        taskDescription: String,
        isNotificationEnabled: Bool,
        plannedDates: [Date]
    ) {
        self.id = id
        self.taskDescription = taskDescription
        self.isNotificationEnabled = isNotificationEnabled
        self.time = plannedDates.first
        
        insert(plannedDates)
    }
    
    func editWithNew(_ task: TaskToEdit) {
        taskDescription = task.description
        isNotificationEnabled = task.isNotificationEnabled
        insert(task.dates)
    }
    
    private func insert(_ plannedDates: [Date]) {
        var plannedDatesForCurrentTask: [ScheduleDate] = []
        plannedDates.forEach { date in
            let isCompleted = false // when create task it is not completed, value is always false
            let scheduleDate = ScheduleDate(taskId: id, date: date, isCompleted: isCompleted)
            plannedDatesForCurrentTask.append(scheduleDate)
        }
        dates = plannedDatesForCurrentTask
    }
}
