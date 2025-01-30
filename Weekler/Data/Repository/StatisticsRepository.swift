//
//  StatisticsRepository.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.11.2024.
//

import Foundation

final class StatisticsRepository: StatisticsRepositoryProtocol {
    
    // MARK: - private methods
    private let dataSource: StatisticsDataSourceProtocol
    
    // MARK: - lifecycle
    init(
        dataSource: StatisticsDataSourceProtocol
    ) {
        self.dataSource = dataSource
    }
    
    // MARK: - public methods
    func fetchStatistics(for currentWeek: [String]) async -> [ScheduleTask] {
        let predicate = #Predicate<ScheduleDate> { currentWeek.contains($0.onlyDate) }
        let sortDescriptor = SortDescriptor<ScheduleDate>(\.date, order: .forward)

        let scheduleDatesItems = await dataSource.fetchTaskItems(
            predicate: predicate,
            sortDescriptor: sortDescriptor
        )
        
        let ids = scheduleDatesItems.map(\.taskId)
        
        let taskPredicate = #Predicate<TaskItem> { ids.contains($0.id) }
        let sort = SortDescriptor<TaskItem>(\.id, order: .forward)
        
        let scheduleItems = await dataSource.fetchTaskItems(
            predicate: taskPredicate,
            sortDescriptor: sort
        )
        
        let currentScheduleTaskArray = scheduleItems.compactMap { task in
            if let dates = task.dates?.map({ $0.date }),
               let completed = task.dates?.first?.isCompleted {
                return ScheduleTask(
                    id: task.id,
                    dates: dates,
                    description: task.taskDescription,
                    isNotificationEnabled: task.isNotificationEnabled,
                    completed: completed
                )
            }
            return nil
        }
        
        return currentScheduleTaskArray
    }
}
