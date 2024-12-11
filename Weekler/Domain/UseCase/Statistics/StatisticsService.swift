//
//  StatisticsService.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.11.2024.
//

import Foundation

final class StatisticsService: StatisticsServiceProtocol {
    
    // MARK: - private properties
    private let statisticsRepository: StatisticsRepositoryProtocol
    
    // MARK: - lifecycle
    init(
        statisticsRepository: StatisticsRepositoryProtocol
    ) {
        self.statisticsRepository = statisticsRepository
    }
    
    // MARK: - public methods
    func fetchCurrentWeekStatistics(for currentWeek: [String]) async -> [ScheduleTask] {
        let schedule = await statisticsRepository.fetchStatistics(for: currentWeek)
        return schedule
    }
}
