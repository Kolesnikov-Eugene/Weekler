//
//  ScheduleRepositoryProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.11.2024.
//

import Foundation

protocol ScheduleRepositoryProtocol {
    func fetchTaskItems<T: ScheduleDataBaseType>(
        predicate: Predicate<T>,
        sortDescriptor: SortDescriptor<T>,
        _ completion: (Result<[T], Error>) -> Void) async
    func insert<T: ScheduleDataBaseType>(_ model: T) async
    func delete<T: ScheduleDataBaseType>(_ id: UUID, predicate: Predicate<T>) async
    func edit(_ task: ScheduleTask) async
    func complete(_ task: ScheduleTask) async
    func unComplete(_ task: ScheduleTask) async
}
