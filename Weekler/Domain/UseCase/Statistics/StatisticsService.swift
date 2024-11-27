//
//  StatisticsService.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.11.2024.
//

import Foundation

final class StatisticsService: StatisticsServiceProtocol {
    
    private let statisticsRepository: StatisticsRepositoryProtocol
    
    init(
        statisticsRepository: StatisticsRepositoryProtocol
    ) {
        self.statisticsRepository = statisticsRepository
    }
    
    func fetchCurrentWeekStatistics(for currentWeek: [String]) async -> [ScheduleTask] {
        print("statistics service fecth")
        let schedule = await statisticsRepository.fetchStatistics(for: currentWeek)
        return schedule
    }
}
