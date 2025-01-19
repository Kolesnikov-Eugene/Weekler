//
//  ScheduleRepository.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 05.11.2024.
//

import Foundation

struct Query: Hashable {
    let date: Date
    let taskIsCompleted: Bool
}

final class ScheduleRepository: ScheduleRepositoryProtocol {
    
    // MARK: - private properties
    private let dataSource: ScheduleDataSourceProtocol
    
    // MARK: - lifecycle
    init(
        dataSource: ScheduleDataSourceProtocol
    ) {
        self.dataSource = dataSource
    }
    
    // MARK: - public methods
    func fetchTaskItems(with query: Query) async -> [ScheduleTask] {
        let predicate = createPredicate(with: query)
        let sortDescriptor = SortDescriptor<ScheduleDate>(\.date, order: .forward)
        
        let scheduleDatesItems = await dataSource.fetchTaskItems(
            predicate: predicate,
            sortDescriptor: sortDescriptor
        )
        
        let ids = scheduleDatesItems.map(\.taskId)
        
        let taskPredicate = #Predicate<TaskItem> { ids.contains($0.id) }
        let sort = SortDescriptor<TaskItem>(\.id, order: .forward)
        
        var scheduleItems = await dataSource.fetchTaskItems(
            predicate: taskPredicate,
            sortDescriptor: sort
        )
        
        scheduleItems.sort { $0.time!.onlyTime < $1.time!.onlyTime }
//        
        let currentScheduleTaskArray = scheduleItems.compactMap { task in
            if let dates = task.dates?.map({ $0.date }) {
                return ScheduleTask(
                    id: task.id,
                    dates: dates,
                    description: task.taskDescription,
                    isNotificationEnabled: task.isNotificationEnabled,
                    completed: query.taskIsCompleted
                )
            }
            return nil
        }
        return currentScheduleTaskArray
    }
    
    func insert(_ task: ScheduleTask) async {
        let model = TaskItem(
            id: task.id,
            taskDescription: task.description,
            isNotificationEnabled: task.isNotificationEnabled,
            plannedDates: task.dates
        )
        
        await dataSource.insert(model)
    }
    
    func deleteTask(with id: UUID) async {
        let predicate = #Predicate<TaskItem> { $0.id == id }
        await dataSource.delete(with: predicate)
    }
    
    // TODO: - split logic in this method
    func edit(_ task: ScheduleTask) async {
        let taskId = task.id
        
        let predicate = #Predicate<ScheduleDate> { $0.taskId == taskId }
        await dataSource.delete(with: predicate)
        
        let predicateTask = #Predicate<TaskItem> { $0.id == taskId }
        let sortDescriptor = SortDescriptor<TaskItem>(\.id)
        let taskItemsToEdit = await dataSource.fetchTaskItems(
            predicate: predicateTask,
            sortDescriptor: sortDescriptor
        )
        
        guard let taskItemToEdit = taskItemsToEdit.first else { return }
        let taskToEdit = TaskToEdit(
            id: task.id,
            dates: task.dates,
            description: task.description,
            isNotificationEnabled: task.isNotificationEnabled
        )
        
        taskItemToEdit.editWithNew(taskToEdit)
        do {
            try await dataSource.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func toggleTaskCompletion(with id: UUID, isCompleted: Bool) async {
        let predicate = #Predicate<ScheduleDate> { $0.taskId == id }
        let sortDescriptor = SortDescriptor<ScheduleDate>(\.date)
        let taskItems = await dataSource.fetchTaskItems(
            predicate: predicate,
            sortDescriptor: sortDescriptor
        )
        guard let item = taskItems.first else { return }
        item.isCompleted = isCompleted
        do {
            try await dataSource.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createPredicate(with query: Query) -> Predicate<ScheduleDate> {
        let onlyDate = query.date.onlyDate
        if query.taskIsCompleted {
            return #Predicate<ScheduleDate> { $0.onlyDate == onlyDate && $0.isCompleted }
        }
        return #Predicate<ScheduleDate> { $0.onlyDate == onlyDate && !$0.isCompleted }
    }
}
