//
//  ScheduleStorageDataProvider.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 30.09.2024.
//

import Foundation
import SwiftData

@ModelActor
final actor ScheduleDataSource: ScheduleDataSourceProtocol {
    
    // MARK: - private properties
    private var context: ModelContext { modelExecutor.modelContext }
    
    // MARK: - lifecycle
    init() {
        do {
            let container = try ModelContainer(for: TaskItem.self, ScheduleDate.self)
            self.modelContainer = container
            let context = ModelContext(container)
            modelExecutor = DefaultSerialModelExecutor(modelContext: context)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - public methods
    func fetchTaskItems<T: PersistentModel>(
        predicate: Predicate<T>,
        sortDescriptor: SortDescriptor<T>
    ) -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: [sortDescriptor])
        
        do {
            let scheduleForSelectedDate = try context.fetch(descriptor)
            return scheduleForSelectedDate
        } catch {
            fatalError("Error fetching schedule for selected date: \(error.localizedDescription)")
        }
    }
    
    func insert<T: PersistentModel>(_ model: T) {
        
        do {
            print(model)
            try context.insert(model)
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    func deleteTask<T: PersistentModel>(with predicate: Predicate<T>) {
        do {
            try self.context.delete(model: T.self, where: predicate)
            try context.save()
        } catch {
            fatalError("Error deleting task: \(error.localizedDescription)")
        }
    }
    
    func edit(_ task: TaskToEdit) {
        let id: UUID = task.id
        let predicate = #Predicate<TaskItem> { $0.id == id }
        let descriptor = FetchDescriptor<TaskItem>(predicate: predicate)
        
        do {
            let items = try context.fetch(descriptor)
            if let taskToEdit = items.first {
                taskToEdit.editWithNew(task)
                try context.save()
            }
        } catch {
            fatalError("Error editing task: \(error.localizedDescription)")
        }
    }
    
    func completeTask<T: PersistentModel>(with predicate: Predicate<T>) {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        
        do {
            let items = try self.context.fetch(descriptor)
            if let taskToEdit = items.first as? TaskItem {
                let completedTask = CompletedTask(id: UUID(), task: taskToEdit)
                taskToEdit.completed = completedTask
                try context.save()
            }
        } catch {
            fatalError("Error completing task: \(error.localizedDescription)")
        }
    }
    
    // TODO: - implement deletion from completed
    func unCompleteTask<T: PersistentModel>(with predicate: Predicate<T>) {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        
        do {
            let items = try self.context.fetch(descriptor)
            if let taskToEdit = items.first as? TaskItem {
                taskToEdit.completed = nil
                try context.save()
            }
        } catch {
            fatalError("Error uncompleting task: \(error.localizedDescription)")
        }
    }
}

// MARK: - StatisticsDataSourceProtocol
extension ScheduleDataSource: StatisticsDataSourceProtocol {}
