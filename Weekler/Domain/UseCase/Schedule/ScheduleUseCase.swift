//
//  ScheduleDataManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import Foundation

final class ScheduleUseCase: ScheduleUseCaseProtocol {
    private let repository: ScheduleRepositoryProtocol
    
    init(
        repository: ScheduleRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    // MARK: - public methods
    func fetchTaskItems(for date: String) async -> [ScheduleTask] {
        await repository.fetchTaskItems(for: date)
    }
    
    func insert(_ task: ScheduleTask) async {
        await repository.insert(task)
    }
    
    func deleteTask(with id: UUID) async {
        await repository.deleteTask(with: id)
    }
    
    func edit(_ task: ScheduleTask) async {
        await repository.edit(task)
    }
    
    func completeTask(with id: UUID) async {
        await repository.completeTask(with: id)
    }
    
    func unCompleteTask(with id: UUID) async {
        await repository.unCompleteTask(with: id)
    }
}
