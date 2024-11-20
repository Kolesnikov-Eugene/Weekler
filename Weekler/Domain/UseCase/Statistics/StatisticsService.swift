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
    
    func fetchCurrentWeekStatistics() async {
        print("statistics service fecth")
        await statisticsRepository.fetchStatistics()
    }
}
