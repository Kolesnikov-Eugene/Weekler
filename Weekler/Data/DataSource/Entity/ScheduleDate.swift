//
//  ScheduleDate.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 14.01.2025.
//

import Foundation
import SwiftData

// MARK: - WORKING
@Model
final class ScheduleDate: Hashable, Identifiable {
    @Attribute(.unique) private(set) var id: UUID
//    @Relationship var taskItem: TaskItem
    var taskId: UUID
    var date: Date
    
    var onlyDate: String
    
    init(/*taskItem: TaskItem,*/ taskId: UUID, date: Date) {
        self.id = UUID()
//        self.taskItem = taskItem
        self.taskId = taskId
        self.date = date
        onlyDate = date.onlyDate
        
        print("create dateItem", taskId)
    }
}
