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
//        let predicate = #Predicate<TaskItem> { currentWeek.contains($0.onlyDate) }
//        let sortDescriptor = SortDescriptor<TaskItem>(\.date, order: .forward)
//        
//        let taskItems = await dataSource.fetchTaskItems(
//            predicate: predicate,
//            sortDescriptor: sortDescriptor
//        )
//        let currentScheduleTaskArray = taskItems.map {
//            ScheduleTask(
//                id: $0.id,
//                date: $0.date,
//                description: $0.taskDescription,
//                isNotificationEnabled: $0.isNotificationEnabled,
//                completed: $0.completed != nil
//            )
//        }
//        return currentScheduleTaskArray
        return []
    }
}
