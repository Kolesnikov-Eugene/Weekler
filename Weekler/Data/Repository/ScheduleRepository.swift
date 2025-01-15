//
//  ScheduleRepository.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 05.11.2024.
//

import Foundation

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
    
    // MARK: - Working
    func fetchTaskItems(for date: String) async -> [ScheduleTask] {
        let predicate = #Predicate<ScheduleDate> { $0.onlyDate == date }
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
        
//        scheduleItems.forEach { item in
//            print(item.time?.onlyTime)
//        }
        
        scheduleItems.sort { $0.time!.onlyTime < $1.time!.onlyTime }
        
        scheduleItems.forEach { item in
            let dates = item.dates?.map { $0.date }
        }
        
        let currentScheduleTaskArray = scheduleItems.map { task in
            let dates = task.dates?.map { $0.date }
            return ScheduleTask(
                id: task.id,
                dates: dates!,
                description: task.taskDescription,
                isNotificationEnabled: task.isNotificationEnabled,
                completed: task.completed != nil
            )
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
        print(task.dates)
        
        await dataSource.insert(model)
    }
    
    func deleteTask(with id: UUID) async {
        let predicate = #Predicate<TaskItem> { $0.id == id }
        await dataSource.deleteTask(with: predicate)
    }
    
    func edit(_ task: ScheduleTask) async {
        let taskToEdit = TaskToEdit(
            id: task.id,
            dates: task.dates,
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
