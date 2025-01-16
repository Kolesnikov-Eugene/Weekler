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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let predicate = #Predicate<TaskItem> { item in
            return item.datesToComplete?.contains(date) ?? false
        }
        let sortDescriptor = SortDescriptor<TaskItem>(\.id)
        var items = await dataSource.fetchTaskItems(predicate: predicate, sortDescriptor: sortDescriptor)
        items.sort { $0.time!.onlyTime < $1.time!.onlyTime }
        let i = items.map { item in
            return ScheduleTask(
                id: item.id,
                dates: [Date()],
                description: item.taskDescription,
                isNotificationEnabled: item.isNotificationEnabled,
                completed: item.completed != nil
            )
        }
        return i
        
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
//        let id: UUID = task.id
//        let predicate = #Predicate<TaskItem> { $0.id == id }
//        let sortDescriptor = SortDescriptor<TaskItem>(\.id)
//        let items = await dataSource.fetchTaskItems(predicate: predicate, sortDescriptor: sortDescriptor)
//        let itemToEdit = items.first!
//        
//        
//        
//        let datesPredicate = #Predicate<ScheduleDate> { $0.taskId == id }
//        let sortDates = SortDescriptor<ScheduleDate>(\.date)
//        let dates = await dataSource.fetchTaskItems(predicate: datesPredicate, sortDescriptor: sortDates)
//        await dataSource.deleteItems(dates)
        
        let taskToEdit = TaskToEdit(
            id: task.id,
            dates: task.dates,
            description: task.description,
            isNotificationEnabled: task.isNotificationEnabled,
            completed: task.completed
        )
//        itemToEdit.editWithNew(taskToEdit)
//        await dataSource.edit(taskToEdit)
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
