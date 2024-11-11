//
//  TaskToEdit.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 06.11.2024.
//

import Foundation

struct TaskToEdit {
    let id: UUID
    let date: Date
    let description: String
    let isNotificationEnabled: Bool
    let completed: Bool
}
