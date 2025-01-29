//
//  ScheduleDataSourceProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 06.11.2024.
//

import Foundation
import SwiftData

protocol ScheduleDataSourceProtocol {
    func fetchTaskItems<T: PersistentModel>(
        predicate: Predicate<T>,
        sortDescriptor: SortDescriptor<T>
    ) async -> [T]
    func insert<T: PersistentModel>(_ model: T) async
    func delete<T: PersistentModel>(with predicate: Predicate<T>) async
    func saveContext() async throws
}
