//
//  ScheduleStorageDataProvider.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 30.09.2024.
//

import Foundation
import SwiftData

@ModelActor
final actor ScheduleStorageDataProvider: ScheduleStorageDataProviderProtocol {
    private var context: ModelContext { modelExecutor.modelContext }
    
    init(container: ModelContainer) {
        self.modelContainer = container
        let context = ModelContext(container)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    // MARK: - public methods
    func fetchTaskItems<T: ScheduleDataBaseType>(
        predicate: Predicate<T>,
        sortDescriptor: SortDescriptor<T>,
        _ completion: (Result<[T], Error>
        ) -> Void) {
        let descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: [sortDescriptor])
        
        do {
            completion(.success(try context.fetch(descriptor)))
        } catch {
            completion(.failure(error))
        }
    }
    
    func insert<T: ScheduleDataBaseType>(_ model: T) {
        context.insert(model)
        try? context.save()
    }
    
    func delete<T: ScheduleDataBaseType>(_ id: UUID, predicate: Predicate<T>) {
        try? self.context.delete(model: T.self, where: predicate)
    }
    
    func edit(_ task: ScheduleTask) {
        let id: UUID = task.id
        let predicate = #Predicate<TaskItem> { $0.id == id }
        let descriptor = FetchDescriptor<TaskItem>(predicate: predicate)
        let items = try? context.fetch(descriptor)
        if let taskToEdit = items?.first {
            taskToEdit.editWithNew(task)
        }
    }
    
    func complete(_ task: ScheduleTask) {
        let id: UUID = task.id
        let predicate = #Predicate<TaskItem> { $0.id == id }
        let descriptor = FetchDescriptor<TaskItem>(predicate: predicate)
        let items = try? self.context.fetch(descriptor)
        if let taskToEdit = items?.first {
            let completedTask = CompletedTask(id: UUID(), task: taskToEdit)
            taskToEdit.completed = completedTask
        }
    }
    
    // TODO: - implement deletion from completed
    func unComplete(_ task: ScheduleTask) {
        let id: UUID = task.id
        let predicate = #Predicate<TaskItem> { $0.id == id }
        let descriptor = FetchDescriptor<TaskItem>(predicate: predicate)
        let items = try? self.context.fetch(descriptor)
        if let taskToEdit = items?.first {
            taskToEdit.completed = nil
        }
    }
}

protocol ScheduleStorageDataProviderProtocol: ModelActor {
    func fetchTaskItems<T: ScheduleDataBaseType>(
        predicate: Predicate<T>,
        sortDescriptor: SortDescriptor<T>,
        _ completion: (Result<[T], Error>) -> Void)
    func insert<T: ScheduleDataBaseType>(_ model: T)
    func delete<T: ScheduleDataBaseType>(_ id: UUID, predicate: Predicate<T>)
    func edit(_ task: ScheduleTask)
    func complete(_ task: ScheduleTask)
    func unComplete(_ task: ScheduleTask)
}
