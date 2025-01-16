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
    @Relationship(deleteRule: .cascade) var completed: CompletedTask?
    
//    var datesToCompleteRaw: String
//    
//    var datesToComplete: [String] {
//        get {
//            (try? JSONDecoder().decode([String].self, from: datesToCompleteRaw.data(using: .utf8)!)) ?? []
//        }
//        set {
//            datesToCompleteRaw = (try? JSONEncoder().encode(newValue).flatMap { String($0) }) ?? "[]"
//        }
//    }
    
    
//    @Relationship(deleteRule: .cascade) var dates: [ScheduleDate]?
//    @Attribute(.transformable(by: "ArrayStringTransformer"))
//    var datesToComplete: [String]?
//    @Attribute(.transformable(by: "NSSecureUnarchiveFromData"))
//    var datesToComplete: [String]?
    
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.datesToComplete = plannedDates.map { formatter.string(from: $0) }
//        insert(plannedDates)
    }
    
    func editWithNew(_ task: TaskToEdit) {
        taskDescription = task.description
        isNotificationEnabled = task.isNotificationEnabled
//        insert(task.dates)
    }
    
//    private func insert(_ plannedDates: [Date]) {
//        var plannedDatesForCurrentTask: [ScheduleDate] = []
//        plannedDates.forEach { date in
//            let scheduleDate = ScheduleDate(taskId: id, date: date)
//            plannedDatesForCurrentTask.append(scheduleDate)
//        }
//        dates = plannedDatesForCurrentTask
//    }
}
