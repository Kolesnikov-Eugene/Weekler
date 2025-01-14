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
//    var date: Date
    var taskDescription: String
    var isNotificationEnabled: Bool
    @Relationship(deleteRule: .cascade) var completed: CompletedTask?
    @Relationship(deleteRule: .cascade) var dates: [ScheduleDate]?
    
//    var onlyDate: String
    
    init(
        id: UUID = UUID(),
//        date: Date,
        taskDescription: String,
        isNotificationEnabled: Bool,
        plannedDates: [Date]
    ) {
        self.id = id
//        self.date = date
        self.taskDescription = taskDescription
        self.isNotificationEnabled = isNotificationEnabled
//        onlyDate = date.onlyDate
        
        insert(plannedDates)
    }
    
    func editWithNew(_ task: TaskToEdit) {
//        date = task.date
        taskDescription = task.description
        isNotificationEnabled = task.isNotificationEnabled
        insert(task.dates)
//        onlyDate = date.onlyDate
    }
    
    private func insert(_ plannedDates: [Date]) {
        //        let alreadyAddedDates = dates ?? []
        //        plannedDates.forEach { date in
        //            if !(alreadyAddedDates.map { $0.date }.contains(date)) {
        //                let scheduleDate = ScheduleDate(taskItem: self, date: date)
        //                dates?.append(scheduleDate)
        //            }
        //        }
        plannedDates.forEach { date in
            print("appending", date)
            let scheduleDate = ScheduleDate(taskItem: self, date: date)
            dates?.append(scheduleDate)
        }
    }
}
