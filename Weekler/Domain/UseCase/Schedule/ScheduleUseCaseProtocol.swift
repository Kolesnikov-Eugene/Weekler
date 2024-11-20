//
//  ScheduleUseCaseProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.11.2024.
//

import Foundation

protocol ScheduleUseCaseProtocol {
    func fetchTaskItems(for date: String) async -> [ScheduleTask]
    func insert(_ task: ScheduleTask) async
    func deleteTask(with id: UUID) async
    func edit(_ task: ScheduleTask) async
    func completeTask(with id: UUID) async
    func unCompleteTask(with id: UUID) async
}
