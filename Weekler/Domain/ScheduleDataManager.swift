//
//  ScheduleDataManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import Foundation
import SwiftData

final class ScheduleDataManager: ScheduleDataManagerProtocol, Sendable {
    private let dataBuilder: ScheduleDataProviderBuilderProtocol
    
    init(dataBulder: ScheduleDataProviderBuilderProtocol) {
        self.dataBuilder = dataBulder
    }
    
    // MARK: - public methods
    func fetchTaskItems(
        predicate: Predicate<TaskItem>,
        sortDescriptor: SortDescriptor<TaskItem>,
        _ completion: @escaping (Result<[ScheduleTask], Error>) -> Void) {
            Task.detached {
                do {
//                    let container = try ModelContainer(for: TaskItem.self)
//                    let scheduleStorageDataProvider = ScheduleStorageDataProvider(container: container)
                    let provider = self.dataBuilder.createDataProvider()
                    await provider().fetchTaskItems(
                        predicate: predicate,
                        sortDescriptor: sortDescriptor) { [weak self] (result: Result<[TaskItem], Error>) in
                            guard let self = self else { return }
                            switch result {
                            case .success(let items):
                                print(items)
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
                    
                } catch {
                    fatalError(error.localizedDescription)
                }
                
        }
    }
    
    func insert(_ model: ScheduleTask) {
        Task.detached {
            do {
                let provider = self.dataBuilder.createDataProvider()
                let model = TaskItem(
                    id: model.id,
                    date: model.date,
                    taskDescription: model.description,
                    isNotificationEnabled: model.isNotificationEnabled
                )
                
                await provider().insert(model)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func delete(_ id: UUID, predicate: Predicate<TaskItem>) {
        
    }
    
    func edit(_ task: ScheduleTask) {
        
    }
    
    func complete(_ task: ScheduleTask) {
        
    }
    
    func unComplete(_ task: ScheduleTask) {
        
    }
}

protocol ScheduleDataManagerProtocol {
    func fetchTaskItems(
        predicate: Predicate<TaskItem>,
        sortDescriptor: SortDescriptor<TaskItem>,
        _ completion: @escaping (Result<[ScheduleTask], Error>) -> Void)
    func insert(_ model: ScheduleTask)
    func delete(_ id: UUID, predicate: Predicate<TaskItem>)
    func edit(_ task: ScheduleTask)
    func complete(_ task: ScheduleTask)
    func unComplete(_ task: ScheduleTask)
}

protocol ScheduleDataProviderBuilderProtocol: Sendable {
    func createDataProvider()  -> @Sendable () async -> ScheduleStorageDataProviderProtocol
}
