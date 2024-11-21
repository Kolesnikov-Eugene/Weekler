//
//  ScheduleRepository.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 05.11.2024.
//

import Foundation

final class ScheduleRepository: ScheduleRepositoryProtocol {
    private let dataSource: ScheduleDataSourceProtocol
    
    init(
        dataSource: ScheduleDataSourceProtocol
    ) {
        self.dataSource = dataSource
    }
    
    func fetchTaskItems(for date: String) async -> [ScheduleTask] {
        let predicate = #Predicate<TaskItem> { $0.onlyDate == date }
        let sortDescriptor = SortDescriptor<TaskItem>(\.date, order: .forward)
        
        let taskItems = await dataSource.fetchTaskItems(
            predicate: predicate,
            sortDescriptor: sortDescriptor
        )
        let currentScheduleTaskArray = taskItems.map {
            ScheduleTask(
                id: $0.id,
                date: $0.date,
                description: $0.taskDescription,
                isNotificationEnabled: $0.isNotificationEnabled,
                completed: $0.completed != nil
            )
        }
        return currentScheduleTaskArray
    }
    
    func insert(_ task: ScheduleTask) async {
        let model = TaskItem(
            id: task.id,
            date: task.date,
            taskDescription: task.description,
            isNotificationEnabled: task.isNotificationEnabled
        )
        await dataSource.insert(model)
    }
    
    func deleteTask(with id: UUID) async {
        let predicate = #Predicate<TaskItem> { $0.id == id }
        await dataSource.deleteTask(with: predicate)
    }
    
    func edit(_ task: ScheduleTask) async {
        let taskToEdit = TaskToEdit(
            id: task.id,
            date: task.date,
            description: task.description,
            isNotificationEnabled: task.isNotificationEnabled,
            completed: task.completed
        )
        await dataSource.edit(taskToEdit)
    }
    
    func completeTask(with id: UUID) async {
        let predicate = #Predicate<TaskItem> { $0.id == id }
        await dataSource.completeTask(with: predicate)
    }
    
    func unCompleteTask(with id: UUID) async {
        let predicate = #Predicate<TaskItem> { $0.id == id }
        await dataSource.unCompleteTask(with: predicate)
    }
}
