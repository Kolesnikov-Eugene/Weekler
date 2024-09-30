//
//  ScheduleDataBaseType.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import Foundation
import SwiftData

protocol ScheduleDataBaseType: Sendable, PersistentModel {
    var id: UUID { get }
    var date: Date { get }
    var taskDescription: String { get }
    var isNotificationEnabled: Bool { get }
}
