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
    let date: Date
    let taskDescription: String
    let isNotificationEnabled: Bool
    
    init(id: UUID = UUID(), date: Date, taskDescription: String, isNotificationEnabled: Bool) {
        self.id = id
        self.date = date
        self.taskDescription = taskDescription
        self.isNotificationEnabled = isNotificationEnabled
    }
}
