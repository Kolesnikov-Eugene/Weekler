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
    @Attribute(.unique) let id: UUID
    @Relationship var task: TaskItem
    
    init(id: UUID, task: TaskItem) {
        self.id = id
        self.task = task
    }
}
