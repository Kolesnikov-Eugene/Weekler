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
    private var context: ModelContext { modelExecutor.modelContext }
    
    init() {
        do {
            let container = try ModelContainer(for: TaskItem.self)
            self.modelContainer = container
            let context = ModelContext(container)
            modelExecutor = DefaultSerialModelExecutor(modelContext: context)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - public methods
    func fetchTaskItems(for date: String) -> [TaskItem] {
        let predicate = #Predicate<TaskItem> { $0.onlyDate == date }
        let sortDescriptor = SortDescriptor<TaskItem>(\.date, order: .forward)
        let descriptor = FetchDescriptor<TaskItem>(predicate: predicate, sortBy: [sortDescriptor])
        do {
            let scheduleForSelectedDate = try context.fetch(descriptor)
            return scheduleForSelectedDate
        } catch {
            fatalError("Error fetching schedule for selected date: \(error.localizedDescription)")
        }
    }
    
    func insert(_ model: TaskItem) {
        context.insert(model)
        try? context.save()
    }
    
    func deleteTask(with id: UUID) {
        let predicate = #Predicate<TaskItem> { $0.id == id }
        do {
            try self.context.delete(model: TaskItem.self, where: predicate)
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
    
    func completeTask(with id: UUID) {
        let predicate = #Predicate<TaskItem> { $0.id == id }
        let descriptor = FetchDescriptor<TaskItem>(predicate: predicate)
        do {
            let items = try self.context.fetch(descriptor)
            if let taskToEdit = items.first {
                let completedTask = CompletedTask(id: UUID(), task: taskToEdit)
                taskToEdit.completed = completedTask
                try context.save()
            }
        } catch {
            fatalError("Error completing task: \(error.localizedDescription)")
        }
    }
    
    // TODO: - implement deletion from completed
    func unCompleteTask(with id: UUID) {
        let predicate = #Predicate<TaskItem> { $0.id == id }
        let descriptor = FetchDescriptor<TaskItem>(predicate: predicate)
        do {
            let items = try self.context.fetch(descriptor)
            if let taskToEdit = items.first {
                taskToEdit.completed = nil
                try context.save()
            }
        } catch {
            fatalError("Error uncompleting task: \(error.localizedDescription)")
        }
    }
}
