//
//  CompletedTask.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.09.2024.
//

import Foundation
import SwiftData

@Model
final class CompletedTask {
    @Attribute(.unique) private(set) var id: UUID
    @Relationship var task: TaskItem
    var dateCompleted: Date
    
    init(id: UUID, task: TaskItem, dateCompleted: Date) {
        self.id = id
        self.task = task
        self.dateCompleted = dateCompleted
    }
}
