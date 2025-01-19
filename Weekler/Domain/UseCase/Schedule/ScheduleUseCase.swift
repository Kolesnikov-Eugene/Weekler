//
//  ScheduleDataManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import Foundation

final class ScheduleUseCase: ScheduleUseCaseProtocol {
    
    // MARK: - private properties
    private let repository: ScheduleRepositoryProtocol
    
    // MARK: - lifecycle
    init(
        repository: ScheduleRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    // MARK: - public methods
    func fetchTaskItems(with query: Query) async -> [ScheduleTask] {
        await repository.fetchTaskItems(with: query)
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
    
    func toggleTaskCompletion(with id: UUID, isCompleted: Bool) async {
        await repository.toggleTaskCompletion(with: id, isCompleted: isCompleted)
    }
    
//    func completeTask(with id: UUID) async {
//        await repository.toggleTaskCompletion(with: id, isCompleted: true)
//    }
//    
//    func unCompleteTask(with id: UUID) async {
//        await repository.toggleTaskCompletion(with: id, isCompleted: false)
//    }
}
