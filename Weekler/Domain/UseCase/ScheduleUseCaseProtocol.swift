//
//  ScheduleUseCaseProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.11.2024.
//

import Foundation

protocol ScheduleUseCaseProtocol {
    func fetchTaskItems(
        predicate: Predicate<TaskItem>,
        sortDescriptor: SortDescriptor<TaskItem>,
        _ completion: @escaping (Result<[ScheduleTask], Error>) -> Void) async
    func insert(_ model: ScheduleTask) async
    func delete(_ id: UUID, predicate: Predicate<TaskItem>) async
    func edit(_ task: ScheduleTask) async
    func complete(_ task: ScheduleTask) async
    func unComplete(_ task: ScheduleTask) async
}
