//
//  ScheduleDataManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import Foundation
import SwiftData

final class ScheduleUseCase: ScheduleUseCaseProtocol {
    private lazy var provider: ScheduleRepositoryProtocol = {
        do {
            let container = try ModelContainer(for: TaskItem.self)
            print("conteiner \(Thread.current)")
            return ScheduleRepository(container: container)
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    init() {}
    
    // MARK: - public methods
    func fetchTaskItems(
        predicate: Predicate<TaskItem>,
        sortDescriptor: SortDescriptor<TaskItem>,
        _ completion: @escaping (Result<[ScheduleTask], Error>) -> Void) async {
            await provider.fetchTaskItems(
                predicate: predicate,
                sortDescriptor: sortDescriptor) { (result: Result<[TaskItem], Error>) in
                    switch result {
                    case .success(let items):
                        let tasks = items.compactMap { task in
                            let completed = task.completed != nil
                            return ScheduleTask(
                                id: task.id,
                                date: task.date,
                                description: task.taskDescription,
                                isNotificationEnabled: task.isNotificationEnabled,
                                completed: completed)
                        }
                        completion(.success(tasks))
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }
        }
    
    func insert(_ model: ScheduleTask) async {
        let model = TaskItem(
            id: model.id,
            date: model.date,
            taskDescription: model.description,
            isNotificationEnabled: model.isNotificationEnabled
        )
        await provider.insert(model)
    }
    
    func delete(_ id: UUID, predicate: Predicate<TaskItem>) async {
        await provider.delete(id, predicate: predicate)
    }
    
    func edit(_ task: ScheduleTask) async {
        await provider.edit(task)
    }
    
    func complete(_ task: ScheduleTask) async {
        await provider.complete(task)
    }
    
    func unComplete(_ task: ScheduleTask) async {
        await provider.unComplete(task)
    }
}
