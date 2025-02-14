//
//  ScheduleTask.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 06.06.2024.
//

import Foundation

struct ScheduleTask: Hashable, SourceItemProtocol {
    let id: UUID
    let dates: [Date]
    let description: String
    let isNotificationEnabled: Bool
    let completed: Bool
}
