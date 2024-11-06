//
//  ScheduleDataSourceProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 06.11.2024.
//

import Foundation

protocol ScheduleDataSourceProtocol {
    func fetchTaskItems(for date: String) async -> [TaskItem]
    func insert(_ model: TaskItem) async
    func deleteTask(with id: UUID) async
    func edit(_ task: TaskToEdit) async
    func completeTask(with id: UUID) async
    func unCompleteTask(with id: UUID) async
}
